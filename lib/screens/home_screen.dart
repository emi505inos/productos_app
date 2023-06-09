import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    
    final productService = Provider.of<ProductsService>(context);
    
    if (productService.isLoading) return LoadingScreen();


    return Scaffold(
      appBar: AppBar(
        title: Text('Productos')
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            productService.selectecProduct = productService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          } ,
          child: ProductCard(
            product: productService.products[index],)) 
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
        
      },),
      
    );
  }
}