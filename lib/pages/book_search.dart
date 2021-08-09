import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 页面参数解析
class PageArguments {
  PageArguments({required this.keyword});

  final String keyword;
}

// 定义 Book 的数据结构
class Book {
  Book(
      {required this.name,
      required this.author,
      required this.url,
      required this.imgUrl});

  final String name;
  final String author;
  final String url;
  final String imgUrl;
}

// 定义由单个 Book 组成的界面
class BookItem extends StatelessWidget {
  const BookItem({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Card(
        child: Row(
          children: <Widget>[
            Image.network(
              book.imgUrl,
              width: 110,
              height: 150,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(book.name,
                        style: Theme.of(context).textTheme.headline4),
                    Text('作者: ' + book.author),
                  ],
                ),
                height: 180,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
            Container(
              child: TextButton(
                child: Text("加入书架"),
                onPressed: null,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
              height: 180,
              padding: EdgeInsets.all(10),
            )
          ],
        ),
      ),
      padding: EdgeInsets.all(10),
    );
  }
}

// 定义由多个 Book 组成的界面
class BookList extends StatelessWidget {
  const BookList({Key? key, required this.books}) : super(key: key);

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookItem(book: books[index]);
      },
    );
  }
}

// 定义页面, 页面是由状态的
class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPage createState() => _BookPage();
}

class _BookPage extends State<BookPage> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();

    // final PageArguments arguments =
    //     ModalRoute.of(context)!.settings.arguments as PageArguments;
    // books = getBooks(keyword: arguments.keyword);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final PageArguments arguments =
        ModalRoute.of(context)!.settings.arguments as PageArguments;
    books = getBooks(keyword: arguments.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BookList(books: snapshot.data as List<Book>);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

// 获取网络数据
Future<List<Book>> getBooks({required String keyword}) async {
  var url = Uri.parse('http://127.0.0.1:8080/search');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: convert.jsonEncode({
      'keyword': keyword,
      'limit': 10,
    }),
  );
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var code = jsonResponse['code'] as int;
    if (code != 0) {
      throw Exception(jsonResponse['msg']);
    }

    // 解析成 books
    var data = jsonResponse['data']['data_list'] as List<dynamic>;
    var books = data
        .map((book) => new Book(
              name: book['name'],
              author: book['author'],
              url: book['url'],
              imgUrl: book['img_url'],
            ))
        .toList();
    return books;
  } else {
    throw Exception('无法搜索小说');
  }
}
