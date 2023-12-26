import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screen/parentLogin.dart';

class ForgotPassword extends StatefulWidget {

const ForgotPassword({Key? key}) : super(key: key);


  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final forgotPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
          backgroundColor: (Colors.lightGreen[100])
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

            Text(
            "FORGOT PASSWORD",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
            const SizedBox(height: 30),
            Text(
              "Hello there! Seems like you forgot your password.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            Container(
              height: 200,
              width: 200,
              // Uploading the Image from Assets
              child:  Image.asset('assets/forgot password.png'),
            ),
            const SizedBox(height: 40),
              Text(
                "Please enter your email address.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: forgotPasswordController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 3, color: Colors.deepOrangeAccent),
                        borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.orange[900]),
                      ),
                      onPressed: () async{
                        var forgotEmail = forgotPasswordController.text.trim();

                        try{
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: forgotEmail)
                              .then((value) => {
                            print("Email sent!"),
                            Get.off(() => ParentLogin()),
                          });
                        } on FirebaseAuthException catch (e) {
                          print("Error $e");
                        }

                      },
                      child: Text("Forgot"),
                    ),
                  ),
                ],
              ),

              ),

            ],
            ),

          ),


      );
    }
  }
