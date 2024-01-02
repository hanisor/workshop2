import 'package:flutter/material.dart';
import '../controller/educatorLoginController.dart';
import '../model/educatorModel.dart';
import 'educatorRegistration.dart';
import 'forgot_password.dart';

class EducatorLogin extends StatefulWidget {
  const EducatorLogin({super.key});

  @override
  State<EducatorLogin> createState() => _EducatorLogin();
}

class _EducatorLogin extends State<EducatorLogin> {

  final EducatorLoginController _loginController = EducatorLoginController();
  final educatorEmailEditingController = TextEditingController();
  final educatorPasswordEditingController = TextEditingController();
  bool _obscurePassword = true;
  final _controller = EducatorLoginController();


  void login() async {
    String eEmail = educatorEmailEditingController.text.trim();
    String ePassword = educatorPasswordEditingController.text.trim();

    EducatorModel educator = EducatorModel(
      educatorEmail: eEmail,
      educatorPassword: ePassword,
      educatorFullName: '',
      educatorName: '',
      educatorProfilePicture: '',
      educatorExpertise: '',
      educatorPhoneNumber: '',
      educatorRePassword: '',
      role: '',
    );

    _controller.login(context, educator);
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
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Hello educator, please log in to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              Container(
                height: 200,
                width: 200,
                // Uploading the Image from Assets
                child:  Image.asset('assets/educator.jpg'),
              ),
              const SizedBox(height: 5),

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
                  controller: educatorEmailEditingController,

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
                    controller: educatorPasswordEditingController

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
                    onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => EducatorRegistration()));
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
      ),
    );
  }
}
