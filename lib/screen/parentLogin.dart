import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screen/forgot_password.dart';
import '../screen/parentRegistration.dart';

import '../controller/parentLoginController.dart';
import '../model/parentModel.dart';

class ParentLogin extends StatefulWidget {

  const ParentLogin({Key? key}) : super(key: key);

  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {

  final parentEmailEditingController = TextEditingController();
  final parentPasswordEditingController = TextEditingController();

  bool _obscurePassword = true;

  final _controller = ParentLoginController();

  void login() async {
    String pEmail = parentEmailEditingController.text.trim();
    String pPassword = parentPasswordEditingController.text.trim();

    ParentModel parent = ParentModel(
      parentEmail: pEmail,
      parentPassword: pPassword,
      parentFullName: '',
      parentName: '',
      parentProfilePicture: '',
      parentPhoneNumber: '',
      parentRePassword: '',
      role: '',
      id: '',
    );

    _controller.login(context, parent);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreen[100],


        appBar: AppBar(
            backgroundColor: (Colors.lightGreen[100])),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "LOGIN",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  "Hello parent, please log in to your account",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 10),
                Container(
                  height: 200,
                  width: 200,
                  // Uploading the Image from Assets
                  child:  Image.asset('assets/parent.jpg'),
                  ),
                const SizedBox(height: 20),


                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 3, color: Colors.deepOrangeAccent),
                            borderRadius: BorderRadius.circular(50.0),

                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: "Enter your email"),
                      keyboardType: TextInputType.emailAddress,
                      controller: parentEmailEditingController,

                    ),
                  ),


                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 3, color: Colors.deepOrangeAccent),
                          borderRadius: BorderRadius.circular(50.0),

                        ),
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: _obscurePassword
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined)),

                        hintText: "Enter your password"),
                    controller: parentPasswordEditingController,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ParentRegistration()
                        ));
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.orange[900]),
                    ),
                    onPressed: () {
                        login();
                    }, child: const Text("Login")),
              ],
            ),
          ),
        )
    );
  }
}

