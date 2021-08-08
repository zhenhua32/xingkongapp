import 'package:flutter/material.dart';

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
              book.url,
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
