import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';

class ProductsService  extends ChangeNotifier{

  final String _baseUrl = 'flutter-varios-92dd2-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  

}