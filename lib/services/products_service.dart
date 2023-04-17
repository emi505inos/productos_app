import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart'as http;

class ProductsService  extends ChangeNotifier{

  final String _baseUrl = 'flutter-varios-92dd2-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectecProduct;
  bool isLoading = true;

  ProductsService(){
    this.loadProducts();
  }
  Future loadProducts() async{
    this.isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl,'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });
    this.isLoading = false;
    notifyListeners();

    return this.products;

  }
}