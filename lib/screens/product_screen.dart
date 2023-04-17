import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/product_from_providers.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    final productsService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (__) => ProductFormProvider(productsService.selectecProduct),
      child: _ProductScreenBody(productsService: productsService),
      );

  // return _ProductScreenBody(productsService: productsService);
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productsService.selectecProduct.picture,),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed:() => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white,)),
                ),
                Positioned(
                  top: 60,
                  right: 25,
                  child: IconButton(
                    onPressed:() {},
                    icon: const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white,)),
                ),
              ],
            ),
            _ProductForm(),
           const SizedBox(height: 100,),

          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save_outlined),
          onPressed: () {
            
          },),
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                initialValue: product.name,
                onChanged: ((value) => product.name = value),
                validator: (value) {
                  if (value == null || value.length < 1)
                  return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del Producto',
                  labelText: 'Nombre:', 
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: ((value){
                  if (double.tryParse(value) == null){
                    product.price = 0;
                  } else{
                    product.price = double.parse(value);
                  }
                }),
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio:', 
                ),
              ),
              const SizedBox(height: 30,),
              SwitchListTile.adaptive(
                value: product.available, 
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged:  productForm.updateAvailability,)
            ],
          )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0,5),
          blurRadius: 5
        )] 
    );
  }
}