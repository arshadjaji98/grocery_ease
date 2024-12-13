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
  final List favourite;
  final int count;

  const Home(
      {super.key,
      required this.image,
      required this.name,
      required this.details,
      required this.price,
      required this.id,
      required this.adminId,
      required this.stock,
      required this.type,
      required this.favourite,
      required this.count});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> types = [
    "Fruit",
    "Meat",
    "Bakery",
    "Beverages",
    "Oil",
    "Vegetables",
    "Dry Fruits",
    "Snacks",
    "Honey"
  ];

  List<String> typeImage = [
    "assets/images/fruits.png",
    "assets/images/meat.png",
    "assets/images/backery.png",
    "assets/images/beverages.png",
    "assets/images/oil.png",
    "assets/images/Vegetables.png",
    "assets/images/Dry Fruits.png",
    "assets/images/Snacks.png",
    "assets/images/Honey.png",
  ];
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';
  String? selectType;
  int count = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchTerm = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> handleRefresh() async {
    return Future.delayed(Duration.zero);
  }

  Stream<QuerySnapshot> getFilteredProducts() {
    final collection = FirebaseFirestore.instance.collection("products");

    if (searchTerm.isNotEmpty) {
      return collection
          .where("name", isGreaterThanOrEqualTo: searchTerm)
          .where("name", isLessThanOrEqualTo: searchTerm + '\uf8ff')
          .snapshots();
    }

    if (selectType != null) {
      return collection.where("type", isEqualTo: selectType).snapshots();
    }

    return collection.snapshots();
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
              // Greeting Section
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
                            builder: (context) => const Favorite(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Color(0XFF8a4af3),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Text Field
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0XFF8a4af3)),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search here',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category Section
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: typeImage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectType = types[index];
                        });
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
                              Image.asset(
                                typeImage[index],
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                types[index],
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

              // Product List
              StreamBuilder(
                stream: getFilteredProducts(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitWave(color: Color(0XFF8a4af3), size: 30.0),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No items available",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  double screenWidth = MediaQuery.of(context).size.width;
                  int crossAxisCount = screenWidth > 600 ? 4 : 3;
                  double childAspectRatio = screenWidth > 600 ? 0.7 : 0.6;

                  return GridView.builder(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 10, top: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                count: 1,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: ds["image"],
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    Positioned(
                                      bottom: 3,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("card")
                                                .doc(ds["id"])
                                                .set({
                                              "image": ds["image"],
                                              "name": ds["name"],
                                              "details": ds["detail"],
                                              "id": ds["id"],
                                              "adminId": ds["adminId"],
                                              "price": ds["price"],
                                              "type": ds["type"],
                                              "count": 1,
                                            });

                                            Utils.toastMessage(
                                                "Product Added to Cart");
                                          } catch (e) {
                                            Utils.toastMessage(
                                                "Failed to add product: $e");
                                          } finally {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: 35,
                                          height: 35,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.add,
                                              color: Colors.white, size: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ds["name"],
                                style: AppWidgets.semiBoldTextFieldStyle(),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Rs. ${ds["price"]}",
                                style: AppWidgets.semiBoldTextFieldStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ],
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
}
