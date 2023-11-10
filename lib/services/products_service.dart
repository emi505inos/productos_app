import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-92dd2-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  

  ProductsService() {
    this.loadProducts();
  }
  Future loadProducts() async {
    this.isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
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

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      await this.CreateProduct(product);
    } else {
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }
  
  Future<String> updateProduct(Product product)async{
   
    final url = Uri.https(_baseUrl,'products/${product.id}.json');
    
    final resp = await http.put(url, body: product.toRawJson());
    final decodedData = resp.body;
    print(decodedData);


  final index = this.products.indexWhere((element) => element.id == product.id);
  this.products[index] = product;
    return product.id!;
 
  }
  Future<String> CreateProduct(Product product)async{
   
    final url = Uri.https(_baseUrl,'products.json');
    
    final resp = await http.post(url, body: product.toRawJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];


    this.products.add(product);
    return product.id!;
 
  }
}