import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250,),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    const SizedBox(height: 30,),
                    ChangeNotifierProvider(
                      create: (__) => LoginFormProvider(),
                      child: _LoginForm()
                      ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 50,),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
                style: ButtonStyle(
                  overlayColor:MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder()) 
                  ), 
                child: const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, color: Colors.black87),),
                ),
              const SizedBox(height: 50,),
            ],
          ),
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: loginForm.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:  InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com' ,
                labelText: 'Correo electronico',
                prefixIcon: Icons.alternate_email_sharp
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp =  RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                ? null 
                : 'El valor ingresado no luce como un correo';  
              },
            ),

            const SizedBox(height: 30,),
            
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration:  InputDecorations.authInputDecoration(
                 hintText: '******' ,
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline_sharp,

              ),
              onChanged: (value) => loginForm.password = value,
               validator: (value) {
                return (value != null && value.length >= 6)
                  ? null
                  : 'la contraseña debe ser de 6 caracteres';

                
                  
              },
            ),
            const SizedBox(height: 30,),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading ? null : () async{

                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);
                if( !loginForm.isValidForm()) return;
                loginForm.isLoading = true;
                
                final String? errorMessage = await authService.login(loginForm.email, loginForm.password);
                if (errorMessage == null){
                  Navigator.pushReplacementNamed(context, 'home');
                }else{
                  //TODO Mostrar error en pantalla
                  //print(errorMessage);
                  NotificationService.showSnackbar(errorMessage);
                loginForm.isLoading = false;
                };
              },
              child: Container(
                padding:  const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere'
                  : 'Ingresar', 
                  style: const TextStyle(color: Colors.white),),
              ),)
          ],
        ),
      ),
    );
  }
}
