import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/admin/admin_login.dart';
import 'package:groceryease_delivery_application/pages/bottom_nav_bar.dart';
import 'package:groceryease_delivery_application/pages/registration/login.dart';
import 'package:groceryease_delivery_application/responsive/web_responsive.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/services/shared_perf.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "", phone = "";

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    // ignore: unnecessary_null_comparison
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar((const SnackBar(
            backgroundColor: Colors.pink,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            ))));
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Wallet": "0",
          "Phone": phonecontroller.text,
          "Id": Id,
        };
        await DatabaseServices().addUserDetail(addUserInfo, Id);
        await SharedPerfHelper().saveUserName(namecontroller.text);
        await SharedPerfHelper().saveUserEmail(mailcontroller.text);
        await SharedPerfHelper().saveUserWallet('0');
        await SharedPerfHelper().saveUserId(Id);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exsists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xffB7DFF5),
                    Color(0xffD3B0E0),
                  ])),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Text(""),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Center(
                        child: Image.asset("assets/images/text logo.png",
                            width: MediaQuery.of(context).size.width,
                            height: 200)),
                    SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: WebResponsive(
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Form(
                                key: _formkey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 30.0),
                                      Text(
                                        "Sign up",
                                        style:
                                            AppWidgets.headerTextFieldStyle(),
                                      ),
                                      SizedBox(height: 30.0),
                                      TextFormField(
                                        controller: namecontroller,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Name';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Name',
                                            hintStyle: AppWidgets
                                                .semiBoldTextFieldStyle(),
                                            prefixIcon:
                                                Icon(Icons.person_outlined)),
                                      ),
                                      SizedBox(height: 30.0),
                                      TextFormField(
                                        controller: phonecontroller,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Phone Number';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Phone',
                                            hintStyle: AppWidgets
                                                .semiBoldTextFieldStyle(),
                                            prefixIcon: Icon(
                                                Icons.phone_android_outlined)),
                                      ),
                                      SizedBox(height: 30.0),
                                      TextFormField(
                                        controller: mailcontroller,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter E-mail';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Email',
                                            hintStyle: AppWidgets
                                                .semiBoldTextFieldStyle(),
                                            prefixIcon:
                                                Icon(Icons.email_outlined)),
                                      ),
                                      SizedBox(height: 30.0),
                                      TextFormField(
                                        controller: passwordcontroller,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Password';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            hintText: 'Password',
                                            hintStyle: AppWidgets
                                                .semiBoldTextFieldStyle(),
                                            prefixIcon:
                                                Icon(Icons.password_outlined)),
                                      ),
                                      SizedBox(height: 60.0),
                                      GestureDetector(
                                        onTap: () async {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            setState(() {
                                              email = mailcontroller.text;
                                              name = namecontroller.text;
                                              password =
                                                  passwordcontroller.text;
                                            });
                                          }
                                          registration();
                                        },
                                        child: Material(
                                          elevation: 5.0,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            width: 200,
                                            decoration: BoxDecoration(
                                                color: Color(0Xffff5722),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                                child: Text(
                                              "SIGN UP",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Poppins1',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 40.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Don't have an account? ",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LogIn()));
                                              },
                                              child: const Text("Login",
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                      ),
                                      Text(
                                        "OR",
                                        style: AppWidgets.boldTextFieldStyle(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Register as an Admin ",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminLogin()));
                                              },
                                              child: const Text("Admin Login",
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
