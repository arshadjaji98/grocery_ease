import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/pages/bottom_nav_bar.dart';
import 'package:groceryease_delivery_application/pages/registration/login.dart';
import 'package:groceryease_delivery_application/responsive/web_responsive.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/services/shared_perf.dart';
import 'package:groceryease_delivery_application/widgets/utills.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  final void Function()? onTap;
  const SignUp({super.key, this.onTap});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  String email = "", password = "", name = "", phone = "", address = "";

  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    setState(() {
      _isLoading = true;
    });

    if (password.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        Utils.toastMessage("Registered Successfully");

        String Id = randomAlphaNumeric(10);
        String user = mailcontroller.text.replaceAll("@gmail.com", "replace");
        String updateusername =
            user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter = user.substring(0, 1).toUpperCase();

        Map<String, dynamic> addUserInfo = {
          "Name": updateusername,
          "Email": mailcontroller.text,
          "Wallet": "0",
          "Phone": phonecontroller.text,
          "Address": addresscontroller.text,
          "Id": Id,
          "SearchKey": firstletter
        };

        await DatabaseServices().addUserDetail(addUserInfo, Id);
        await SharedPerfHelper().saveUserName(namecontroller.text);
        await SharedPerfHelper().saveUserEmail(mailcontroller.text);
        await SharedPerfHelper().saveUserPhone(phonecontroller.text);
        await SharedPerfHelper().saveUserWallet('0');
        await SharedPerfHelper().saveUserId(Id);
        await SharedPerfHelper().saveUserAddress(addresscontroller.text);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomNav()));
      } on FirebaseAuthException catch (e) {
        Utils.toastMessage(e.toString());
      } catch (e) {
        Utils.toastMessage(e.toString());
      } finally {
        setState(() {
          _isLoading = false; // End loading
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
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
                color: Color(0XFF8a4af3),
              ),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    // Center(
                    //     child: Image.asset("assets/images/text logo.png",
                    //         width: MediaQuery.of(context).size.width,
                    //         height: 200)),
                    // const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: WebResponsive(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  // height:
                                  //     MediaQuery.of(context).size.height / 1.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Form(
                                    key: _formkey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Sign up",
                                          style:
                                              AppWidgets.headerTextFieldStyle(),
                                        ),
                                        const SizedBox(height: 30.0),
                                        TextFormField(
                                          controller: namecontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Name';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'Name',
                                              hintStyle: AppWidgets
                                                  .semiBoldTextFieldStyle(),
                                              prefixIcon: const Icon(
                                                  Icons.person_outlined)),
                                        ),
                                        const SizedBox(height: 30.0),
                                        TextFormField(
                                          controller: addresscontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Address';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'Address',
                                              hintStyle: AppWidgets
                                                  .semiBoldTextFieldStyle(),
                                              prefixIcon:
                                                  Icon(Icons.location_on)),
                                        ),
                                        const SizedBox(height: 30.0),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: phonecontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Phone Number';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'Phone',
                                              hintStyle: AppWidgets
                                                  .semiBoldTextFieldStyle(),
                                              prefixIcon: const Icon(Icons
                                                  .phone_android_outlined)),
                                        ),
                                        const SizedBox(height: 30.0),
                                        TextFormField(
                                          controller: mailcontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter E-mail';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'Email',
                                              hintStyle: AppWidgets
                                                  .semiBoldTextFieldStyle(),
                                              prefixIcon: const Icon(
                                                  Icons.email_outlined)),
                                        ),
                                        const SizedBox(height: 30.0),
                                        TextFormField(
                                          controller: passwordcontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Password';
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              hintText: 'Password',
                                              hintStyle: AppWidgets
                                                  .semiBoldTextFieldStyle(),
                                              prefixIcon: const Icon(
                                                  Icons.password_outlined)),
                                        ),
                                        const SizedBox(height: 20.0),
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
                                              await registration();
                                            }
                                          },
                                          child: Material(
                                            elevation: 5.0,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: const Color(0XFF8a4af3),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: _isLoading
                                                  ? const Center(
                                                      child: SpinKitWave(
                                                          size: 20,
                                                          color: Colors.white))
                                                  : const Center(
                                                      child: Text(
                                                        "SIGN IN",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontFamily:
                                                              'Poppins1',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
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
                                                              const LogIn()));
                                                },
                                                child: const Text("Login",
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 18,
                                                        decoration:
                                                            TextDecoration
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [Text("Sign in with google")],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
