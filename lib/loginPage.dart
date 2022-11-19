import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'newpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formValidate = GlobalKey<FormState>();

  userLogin(String username,passwrd)async{


    final url ="http://192.168.29.247:8000/login_api";
    var data ={
      "uname":username,
      "pass":passwrd,
    };

    var response = await http.post(Uri.parse(url),body: data);

    if(response.statusCode ==200){
      SharedPreferences pref =await SharedPreferences.getInstance();
      var data1 = jsonDecode(response.body);
    var name = data1["result"]["name"];
    var id = data1["result"]["id"];
      print(name);
     pref.setString("name", name);
     pref.setInt("id", id);

      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>NAME()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(143, 0, 255, 1),
            Colors.blue,
          ],
        )),
        child: Form(
          key: formValidate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your user user name";
                      }
                    },
                    decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        hintText: "User Name",
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your user password";
                      }
                    },
                    decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  )),
              InkWell(
                onTap: () async{
                  final validate = formValidate.currentState!.validate();

                  if (!validate) {
                    return;
                  } else {
                    userLogin(nameController.text, passwordController.text);

                   // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>NAME()));
                  }
                },
                child: Container(
                  height: 60,
                  width: 120,
                  child: Center(
                      child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(2, 2),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromRGBO(143, 0, 255, 1),
                          Colors.blue,
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
