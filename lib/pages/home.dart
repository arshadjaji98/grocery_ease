// ignore_for_file: override_on_non_overriding_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/pages/details.dart';
import 'package:groceryease_delivery_application/pages/favorite.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  TextEditingController searchController = TextEditingController();
  Stream? fooditemStream;
  bool fruit = false;
  bool meat = false;
  bool backery = false;
  bool beverages = false;
  bool oil = false;
  String searchTerm = '';
  ontheload() async {
    fooditemStream = await DatabaseServices().getFoodItem('Fruit');
    setState(() {});
  }

  void onSearchChanged(String term) async {
    if (term.isEmpty) {
      fooditemStream = await DatabaseServices().getFoodItem('Fruit');
    } else {
      fooditemStream = FirebaseFirestore.instance
          .collection('foodItems')
          .where('Name', isGreaterThanOrEqualTo: term)
          .where('Name', isLessThanOrEqualTo: term + '\uf8ff')
          .snapshots();
    }
    setState(() {
      searchTerm = term;
    });
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItemsVertically() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SpinKitWave(color: Color(0XFF8a4af3), size: 30.0));
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No items available"));
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
                            image: ds['Image'],
                            name: ds['Name'],
                            details: ds['Detail'],
                            price: ds['Price'],
                            id: '',
                          )),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20, bottom: 20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: ds["Image"],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ds["Name"],
                                style: AppWidgets.semiBoldTextFieldStyle()),
                            const SizedBox(height: 5),
                            Text("Fresh and Healthy",
                                style: AppWidgets.lightTextFieldStyle()),
                            const SizedBox(height: 5),
                            Text("\$${ds["Price"]}",
                                style: AppWidgets.semiBoldTextFieldStyle()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget allItems() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SpinKitWave(color: Color(0XFF8a4af3), size: 30.0));
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No items available"));
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
                      image: ds['Image'],
                      name: ds['Name'],
                      details: ds['Detail'],
                      price: ds['Price'],
                      id: '',
                    ),
                  ),
                );
              },
              child: SizedBox(
                height: 20,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: ds["Image"],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(ds["Name"],
                              style: AppWidgets.semiBoldTextFieldStyle(),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          Text("Fresh and Healthy",
                              style: AppWidgets.lightTextFieldStyle(),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          Text("\$${ds["Price"]}",
                              style: AppWidgets.semiBoldTextFieldStyle(),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                    onChanged: onSearchChanged,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Fruit");
                        fruit = true;
                        meat = false;
                        backery = false;
                        beverages = false;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: fruit
                                ? Colors.white
                                : const Color.fromARGB(255, 114, 236, 159)
                                    .withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xff53B175))),
                        child: Row(
                          children: [
                            Image.asset('assets/images/fruits.png',
                                height: 20, width: 20),
                            SizedBox(width: 5),
                            const Text("Fruits",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Backery");
                        fruit = false;
                        meat = false;
                        backery = true;
                        beverages = false;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: backery
                                ? Colors.white
                                : const Color(0xffD3B0E0).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xffD3B0E0))),
                        child: Row(
                          children: [
                            Image.asset('assets/images/backery.png',
                                height: 20, width: 20),
                            SizedBox(width: 5),
                            const Text("Bakery",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Beverages");
                        fruit = false;
                        meat = false;
                        backery = false;
                        beverages = true;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: beverages
                                ? Colors.white
                                : const Color(0xffB7DFF5).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xffB7DFF5))),
                        child: Row(
                          children: [
                            Image.asset('assets/images/beverages.png',
                                height: 20, width: 20),
                            SizedBox(width: 5),
                            const Text("Beverages",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("Meat");
                        fruit = false;
                        meat = true;
                        backery = false;
                        beverages = false;
                        oil = false;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: meat
                                ? Colors.white
                                : const Color(0xffF7A593).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xffF7A593))),
                        child: Row(
                          children: [
                            Image.asset('assets/images/meat.png',
                                height: 20, width: 20),
                            SizedBox(width: 5),
                            const Text("Meat",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () async {
                        fooditemStream =
                            await DatabaseServices().getFoodItem("oil");
                        fruit = false;
                        meat = false;
                        backery = false;
                        beverages = false;
                        oil = true;
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: oil
                                  ? Colors.white
                                  : const Color(0xffF8A44C).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xffF8A44C))),
                          child: Row(
                            children: [
                              Image.asset('assets/images/oil.png',
                                  height: 20, width: 20),
                              SizedBox(width: 5),
                              const Text("Oil",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 200,
                child: allItems(),
              ),
              const SizedBox(height: 30),
              allItemsVertically()
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
