// ignore_for_file: override_on_non_overriding_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/pages/user/details.dart';
import 'package:groceryease_delivery_application/pages/user/favorite.dart';
import 'package:groceryease_delivery_application/widgets/utills.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  final String image, name, details, price, id, adminId, stock, type;
  const Home(
      {super.key,
      required this.image,
      required this.name,
      required this.details,
      required this.price,
      required this.id,
      required this.adminId,
      required this.stock,
      required this.type});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  TextEditingController searchController = TextEditingController();

  List<String> types = ["Fruit", "Meat", "Backery", "Beverages", "Oil"];
  String? selectType;
  List<String> typeImage = [
    "assets/images/fruits.png",
    "assets/images/meat.png",
    "assets/images/backery.png",
    "assets/images/beverages.png",
    "assets/images/oil.png",
  ];

  String searchTerm = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleRefresh() async {
    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 15, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello and Welcome!",
                    style: AppWidgets.boldTextFieldStyle(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0XFF8a4af3),
                        ),
                        borderRadius: BorderRadius.circular(4)),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Favorite()));
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Color(0XFF8a4af3),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0XFF8a4af3),
                    ),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    // onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search here',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Spacer(),
              Text(
                "Delicious Food",
                style: AppWidgets.headerTextFieldStyle(),
              ),
              Text(
                "Discover and Get Great Food",
                style: AppWidgets.lightTextFieldStyle(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: typeImage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectType = types[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectType == types[index]
                                ? Colors.deepPurple
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectType == types[index]
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(typeImage[index],
                                  height: 20, width: 20),
                              SizedBox(width: 5),
                              Text(
                                types[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: selectType == types[index]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
              Container(
                height: 200,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: SpinKitWave(
                              color: Color(0XFF8a4af3), size: 30.0));
                    }
                    if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      return const Center(
                          child: Text("No items available",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Details(
                                  image: ds['image'],
                                  name: ds['name'],
                                  details: ds['detail'],
                                  price: ds['price'].toString(),
                                  id: ds['id'],
                                  stock: ds['quantity'].toString(),
                                  adminId: ds['adminId'],
                                  type: ds['type'],
                                  favourite: ds["favourite"],
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 20,
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              child: Material(
                                color: Colors.white,
                                elevation: 5,
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              imageUrl: ds["image"],
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(ds["name"],
                                              style: AppWidgets
                                                  .boldTextFieldStyle(),
                                              textAlign: TextAlign.center),
                                          const SizedBox(height: 4),
                                          Text("Rs. ${ds["price"]}",
                                              style: AppWidgets
                                                  .semiBoldTextFieldStyle(),
                                              textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                    // Positioned(
                                    //   bottom: 8,
                                    //   right: 8,
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       FirebaseFirestore.instance
                                    //           .collection("users")
                                    //           .doc(FirebaseAuth
                                    //               .instance.currentUser!.uid)
                                    //           .collection("card")
                                    //           .doc(ds['id'])
                                    //           .set({
                                    //         "image": ds["image"],
                                    //         "name": ds["name"],
                                    //         "details": ds["detail"],
                                    //         "id": ds["id"],
                                    //         "adminId": ds["adminId"],
                                    //         "price": ds["price"],
                                    //         "type": ds["type"],
                                    //         "count": count,
                                    //       }).then((value) {
                                    //         Utils.toastMessage(
                                    //             "Items added to cart");
                                    //       }).catchError((error) {
                                    //         Utils.toastMessage(
                                    //             "Failed to add item: $error");
                                    //       });
                                    //     },
                                    //     child: Container(
                                    //       height: 36,
                                    //       width: 36,
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.green,
                                    //         shape: BoxShape.circle,
                                    //       ),
                                    //       child: const Icon(Icons.add,
                                    //           color: Colors.white),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .where("type", isEqualTo: selectType)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            SpinKitWave(color: Color(0XFF8a4af3), size: 30.0));
                  }
                  if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    return const Center(
                        child: Text("No items available",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(
                                image: ds['image'],
                                name: ds['name'],
                                details: ds['detail'],
                                price: ds['price'].toString(),
                                id: ds['id'],
                                stock: ds['quantity'].toString(),
                                adminId: ds['adminId'],
                                type: ds['type'],
                                favourite: ds["favourite"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, bottom: 20),
                          child: Material(
                            elevation: 5,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: ds["image"],
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(ds["name"],
                                              style: AppWidgets
                                                  .semiBoldTextFieldStyle()),
                                          const SizedBox(height: 5),
                                          Text("Fresh and Healthy",
                                              style: AppWidgets
                                                  .lightTextFieldStyle()),
                                          const SizedBox(height: 5),
                                          Text("Rs. ${ds["price"]}",
                                              style: AppWidgets
                                                  .semiBoldTextFieldStyle()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Positioned(
                                //   right: 10, // Distance from the right
                                //   bottom: 10, // Distance from the bottom
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       // Add the product to the cart or perform desired action
                                //       print("Added to cart: ${ds['name']}");
                                //     },
                                //     child: Container(
                                //       height: 36, // Circular button size
                                //       width: 36,
                                //       decoration: BoxDecoration(
                                //         color: Colors.green,
                                //         shape: BoxShape.circle,
                                //       ),
                                //       child: const Icon(Icons.add,
                                //           color: Colors.white),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['Name'],
                    style: AppWidgets.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
