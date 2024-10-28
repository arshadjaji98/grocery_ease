import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/admin/home_admin.dart';
import 'package:groceryease_delivery_application/responsive/web_responsive.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  bool isRegistering = false; // Toggle between login and register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededeb),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
              padding:
                  const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 53, 51, 51), Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(
                          MediaQuery.of(context).size.width, 110.0))),
            ),
            WebResponsive(
              child: Container(
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Let's start with\nAdmin!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30.0),
                        Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 50.0),
                                _buildTextField(
                                    "Shop Name", usernameController),
                                const SizedBox(height: 40.0),
                                _buildTextField(
                                    "Password", userPasswordController,
                                    isPassword: true),
                                const SizedBox(height: 40.0),
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      isRegistering
                                          ? registerAdmin()
                                          : loginAdmin();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        isRegistering ? "Register" : "Login",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isRegistering = !isRegistering;
                                    });
                                  },
                                  child: Text(isRegistering
                                      ? "Already have an account? Login"
                                      : "Create new account"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 160, 160, 147)),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hint';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 160, 160, 147)),
        ),
      ),
    );
  }

  void registerAdmin() async {
    final username = usernameController.text.trim();
    final password = userPasswordController.text.trim();

    await FirebaseFirestore.instance.collection("Admin").add({
      'id': username,
      'password': password,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Admin registered successfully!")));

      // Navigate to HomeAdmin page after registration
      Route route = MaterialPageRoute(builder: (context) => const HomeAdmin());
      Navigator.pushReplacement(context, route);
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Registration failed!")));
    });
  }

  void loginAdmin() async {
    final username = usernameController.text.trim();
    final password = userPasswordController.text.trim();

    final snapshot = await FirebaseFirestore.instance.collection("Admin").get();
    bool isAuthenticated = false;

    for (var result in snapshot.docs) {
      if (result.data()['id'] == username &&
          result.data()['password'] == password) {
        isAuthenticated = true;
        Route route =
            MaterialPageRoute(builder: (context) => const HomeAdmin());
        Navigator.pushReplacement(context, route);
        break;
      }
    }

    if (!isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("Invalid credentials!")));
    }
  }
}
