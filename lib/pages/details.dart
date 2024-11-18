import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/services/shared_perf.dart';
import 'package:groceryease_delivery_application/widgets/utills.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Details extends StatefulWidget {
  final String image, name, details, price, id;

  const Details(
      {super.key,
      required this.image,
      required this.name,
      required this.details,
      required this.price,
      required this.id});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1, total = 0;
  String? id;
  bool isFavorite = false;
  Future<List<Map<String, dynamic>>> fetchCategoryItems(
      String categoryName) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection("Fruits").get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> toggleFavorite() async {
    String? userId = await SharedPerfHelper().getUserId();

    final favoritesRef =
        FirebaseFirestore.instance.collection('favorites').doc(userId);
    final docSnapshot = await favoritesRef.get();

    if (docSnapshot.exists) {
      var favoritesData = docSnapshot.data()?['items'] ?? [];
      if (favoritesData.contains(widget.name)) {
        favoritesData.remove(widget.name);
      } else {
        favoritesData.add(widget.name);
      }

      await favoritesRef.update({
        'items': favoritesData,
      });
    } else {
      await favoritesRef.set({
        'items': [widget.name],
      });
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> getSharedPref() async {
    id = await SharedPerfHelper().getUserId();
    setState(() {});
  }

  Future<void> onTheLoad() async {
    await getSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
    total = int.parse(widget.price);
  }

  String buttonText = "Add to Cart";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.image,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const Center(
                          child: SpinKitWave(
                            color: Color(0XFF8a4af3),
                            size: 50.0,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.image,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.5,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const Center(
                              child: SpinKitWave(
                                color: Color(0XFF8a4af3),
                                size: 50.0,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      toggleFavorite();
                                    },
                                    icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name,
                                style: AppWidgets.headerTextFieldStyle()),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (a > 1) {
                              a--;
                              total = total - int.parse(widget.price);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0XFF8a4af3),
                                borderRadius: BorderRadius.circular(5)),
                            child:
                                const Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(a.toString(),
                            style: AppWidgets.boldTextFieldStyle()),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            a++;
                            total = total + int.parse(widget.price);
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0XFF8a4af3),
                                borderRadius: BorderRadius.circular(5)),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text("Delivery Time",
                            style: AppWidgets.semiBoldTextFieldStyle()),
                        const SizedBox(width: 25),
                        Text("30 min",
                            style: AppWidgets.semiBoldTextFieldStyle()),
                        const SizedBox(width: 5),
                        const Icon(Icons.alarm, color: Colors.black54),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: AppWidgets.boldTextFieldStyle(),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.details,
                          maxLines: 4,
                          style: AppWidgets.lightTextFieldStyle(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Similar Products",
                            style: AppWidgets.boldTextFieldStyle(),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Fruit")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SpinKitWave(
                                      color: Color(0XFF8a4af3), size: 30.0),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    "Something went wrong!",
                                    style: AppWidgets.lightTextFieldStyle(),
                                  ),
                                );
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No similar products found.",
                                    style: AppWidgets.lightTextFieldStyle(),
                                  ),
                                );
                              }

                              final products = snapshot.data!.docs;

                              return SizedBox(
                                height: 200, // Adjust as needed
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index].data()
                                        as Map<String, dynamic>;
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        width: 150, // Adjust width as needed
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: Column(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: product['Image'],
                                              height: 100,
                                              width: 150,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SpinKitWave(
                                                  color: Color(0XFF8a4af3),
                                                  size: 20.0,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                product['Name'],
                                                style: AppWidgets
                                                    .semiBoldTextFieldStyle(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "\$${product['Price']}",
                                                style: AppWidgets
                                                    .lightTextFieldStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!isLoading) {
                        setState(() {
                          isLoading = true; // Start loading
                        });

                        Map<String, dynamic> addFoodToCart = {
                          "Name": widget.name,
                          "Quantity": a.toString(),
                          "Total": total.toString(),
                          "Image": widget.image,
                        };

                        try {
                          await DatabaseServices()
                              .addFoodToCart(addFoodToCart, id!);
                          Utils.toastMessage("Food added to Cart Successfully");

                          setState(() {
                            buttonText = "Added to Cart"; // Update button text
                            isLoading = false; // Stop loading
                          });
                        } catch (error) {
                          Utils.toastMessage("Failed to add food to cart");

                          setState(() {
                            isLoading = false; // Stop loading even on error
                          });
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        right: 5,
                        left: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0XFF8a4af3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading)
                            SpinKitWave(color: Colors.white, size: 15)
                          else
                            Text(
                              buttonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
