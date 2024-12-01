

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../user/profile.dart';

class AllAdminScreen extends StatelessWidget {
  const AllAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              var data = snapshot.data!.docs[index];
              if(data["user_role"] == "admin"){
                return Card(
                  child: ListTile(
                    leading: Text("${index + 1}"),
                    title: Text(data["name"]),
                    trailing: data["verify"] ?
                    const Text("Verify",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),) :
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: (){
                        FirebaseFirestore.instance.collection("users").doc(data["id"]).update({
                          "verify" : true,
                        });
                      },
                      child: Text("Not Verify",style: TextStyle(color: Colors.white),),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: data["id"],userRole: data["user_role"],)));
                    },
                  ),
                );
              }else{
                return const SizedBox();
              }
            },
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
