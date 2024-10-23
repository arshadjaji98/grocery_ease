import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/pages/bottom_nav_bar.dart';
import 'package:groceryease_delivery_application/pages/registration/forgot_password.dart';
import 'package:groceryease_delivery_application/pages/registration/signup.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNav()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "No User Found for that Email",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Wrong Password Provided by User",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color(0xffB7DFF5),
                      Color(0xffD3B0E0),
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Text(""),
              ),
              Container(
                child: Column(
                  children: [
                    Center(
                        child: Image.asset(
                      "assets/images/text logo.png",
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                    )),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Form(
                            key: _formkey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Login",
                                    style: AppWidgets.headerTextFieldStyle(),
                                  ),
                                  SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: useremailcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle:
                                            AppWidgets.semiBoldTextFieldStyle(),
                                        prefixIcon: Icon(Icons.email_outlined)),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  TextFormField(
                                    controller: userpasswordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Password';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle:
                                            AppWidgets.semiBoldTextFieldStyle(),
                                        prefixIcon:
                                            Icon(Icons.password_outlined)),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPassword()));
                                    },
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        child: Text("Forgot Password?",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                  SizedBox(
                                    height: 80.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          email = useremailcontroller.text;
                                          password =
                                              userpasswordcontroller.text;
                                        });
                                      }
                                      userLogin();
                                    },
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        width: 200,
                                        decoration: BoxDecoration(
                                            color: Color(0Xffff5722),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Text(
                                          "LOGIN",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontFamily: 'Poppins1',
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppWidgets.semiBoldTextFieldStyle(),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text("Sign up",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
