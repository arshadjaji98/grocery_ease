
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderUserListWidget extends StatefulWidget {
  const OrderUserListWidget({required this.userId,required this.expendedTile,super.key});
  final String userId;
  final Widget expendedTile;
  @override
  State<OrderUserListWidget> createState() => _OrderUserListWidgetState();
}

class _OrderUserListWidgetState extends State<OrderUserListWidget> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").doc(widget.userId).snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(data["profile_image"]),
                          radius: 30,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data["name"],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                            Text(data["phone"],style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.grey),),
                            Text(data["address"],style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.grey),),
                          ],
                        ),

                      ],
                    ),
                  ],
                ),
                widget.expendedTile,
              ],
            ),
          );
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
