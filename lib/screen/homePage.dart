import 'package:flutter/material.dart';
import '../screen/educatorLogin.dart';
import '../screen/parentLogin.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('AUTITRACK',
          style: TextStyle(color: Colors.white)),
        backgroundColor: (Colors.green[800]),),


        body: Center(
          child: SingleChildScrollView(

            child: Column(
              children: [

                const SizedBox(height: 30),
                Image.asset('assets/logo_autitrack.png'),
                const SizedBox(height: 30),
                const SizedBox(height: 30),
                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all(
                          Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(
                          Colors.orange[900])
                    ), onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder:
                          (context) => EducatorLogin()));
                  }, child: const Text('EDUCATOR')),

                const SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all(
                        Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all(
                        Colors.orange[900])
                ), onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder:
                          (context) => ParentLogin()));
                }, child: const Text('PARENTS')),

              ],
            ),
        ),
        ),
      );
  }
}
