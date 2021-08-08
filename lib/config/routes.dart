import '../pages/home.dart';
import '../pages/book_list.dart';

var routes = {
  '/': (context) => MyHomePage(title: '行空小说之家'),
  '/book/list': (context) => BookItem(
      book: Book(
          name: '大奉打更人',
          author: '哈哈',
          url: 'http://t.wbxsw.com/tu/287/287178/287178s.jpg',
          imgUrl: 'http://t.wbxsw.com/tu/287/287178/287178s.jpg')),
};
