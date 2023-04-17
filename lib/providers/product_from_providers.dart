import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:provider/provider.dart';

class ProductFormProvider extends ChangeNotifier{
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  bool isValidForm(){
    return formkey.currentState?.validate() ?? false;
  }
}