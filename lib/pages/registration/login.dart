// ignore_for_file: use_build_context_synchronously, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/pages/bottom_nav_bar.dart';
import 'package:groceryease_delivery_application/pages/registration/forgot_password.dart';
import 'package:groceryease_delivery_application/pages/registration/signup.dart';
import 'package:groceryease_delivery_application/responsive/web_responsive.dart';
import 'package:groceryease_delivery_application/widgets/utills.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class LogIn extends StatefulWidget {
  final void Function()? onTap;

  const LogIn({super.key, this.onTap});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
  bool _isLoading = false;

  final _formkey = GlobalKey<FormState>();
  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  userLogin() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Show a toast message or a snackbar
        Utils.toastMessage("Login successful! Redirecting...");
        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );
      } on FirebaseAuthException catch (e) {
        Utils.toastMessage(e.message ?? "An error occurred");
      } catch (e) {
        Utils.toastMessage("An error occurred: ${e.toString()}");
      } finally {
        setState(() {
          _isLoading =
              false; // Stop loading after login is successful or failed
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(color: Color(0XFF8a4af3)),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Center(
                //   child: Image.asset(
                //     "assets/images/text logo.png",
                //     width: MediaQuery.of(context).size.width,
                //     height: 250,
                //   ),
                // ),
                // const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: WebResponsive(
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20.0),
                              Text("Login",
                                  style: AppWidgets.headerTextFieldStyle()),
                              const SizedBox(height: 30.0),
                              TextFormField(
                                controller: useremailcontroller,
                                validator: (value) => value!.isEmpty
                                    ? 'Please Enter Email'
                                    : null,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle:
                                      AppWidgets.semiBoldTextFieldStyle(),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              TextFormField(
                                controller: userpasswordcontroller,
                                validator: (value) => value!.isEmpty
                                    ? 'Please Enter Password'
                                    : null,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle:
                                      AppWidgets.semiBoldTextFieldStyle(),
                                  prefixIcon:
                                      const Icon(Icons.password_outlined),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              GestureDetector(
                                onTap: () {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      email = useremailcontroller.text;
                                      password = userpasswordcontroller.text;
                                    });
                                    userLogin();
                                  }
                                },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: const Color(0XFF8a4af3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: _isLoading
                                        ? Center(
                                            child: SpinKitWave(
                                                size: 20, color: Colors.white))
                                        : const Center(
                                            child: Text(
                                              "LOGIN",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontFamily: 'Poppins1',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUp()),
                                      );
                                    },
                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
