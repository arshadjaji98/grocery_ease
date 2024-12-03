// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryease_delivery_application/pages/registration/login.dart';
import 'package:intl/intl.dart';
import '../../services/image_picker.dart';


class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({this.adminId,super.key});

  final String? adminId;
  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  String? storeName;
  String imgUrl = '';

  @override
  void initState() {
    super.initState();
  }


  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  final controller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("All Order"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(widget.adminId).collection("orders").orderBy("timestamp",descending: true).snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  DateTime dateTime = (snapshot.data!.docs[index]["timestamp"] as Timestamp).toDate();
                  var orderDate = DateFormat('dd-MM-yyyy').format(dateTime);
                  return Card(
                    child: ExpansionTile(
                      leading: Text("${index + 1}"),
                      title: Text(orderDate,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12,color: Colors.grey)),
                      subtitle: Text(snapshot.data!.docs[index]["paymentMethod"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),
                      trailing: Text("Rs. " + snapshot.data!.docs[index]["totalAmount"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),
                      children: [
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs[index]["items"].length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: Text("${i + 1}"),
                                title: Text(snapshot.data!.docs[index]["items"][i]["name"],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),
                                subtitle: Row(
                                  children: [
                                    Text("Rs. " + snapshot.data!.docs[index]["items"][i]["price"]),
                                    SizedBox(width: 10,),
                                    Text("Qty. " + snapshot.data!.docs[index]["items"][i]["count"].toString()),
                                  ],
                                ),
                                trailing: Text(snapshot.data!.docs[index]["items"][i]["orderType"],style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black)),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}