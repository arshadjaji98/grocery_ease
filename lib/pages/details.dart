import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groceryease_delivery_application/pages/favorite.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/services/shared_perf.dart';
import 'package:groceryease_delivery_application/widgets/utills.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Details extends StatefulWidget {
  final String image, name, details, price;

  Details({
    super.key,
    required this.image,
    required this.name,
    required this.details,
    required this.price,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1, total = 0;
  String? id;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20),
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
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name,
                          style: AppWidgets.headerTextFieldStyle()),
                      // SizedBox(height: 50),
                      // Text("\$${total.toString()}",
                      //     style: TextStyle(
                      //         color: const Color(0XFF8a4af3),
                      //         fontFamily: 'Poppins',
                      //         fontSize: 23)),
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
                      child: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(a.toString(), style: AppWidgets.boldTextFieldStyle()),
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
                  Text("30 min", style: AppWidgets.semiBoldTextFieldStyle()),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Price",
                          style: AppWidgets.semiBoldTextFieldStyle()),
                      Text("\$${total.toString()}",
                          style: AppWidgets.boldTextFieldStyle()),
                    ],
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> addFoodToCart = {
                        "Name": widget.name,
                        "Quantity": a.toString(),
                        "Total": total.toString(),
                        "Image": widget.image,
                      };
                      await DatabaseServices()
                          .addFoodtoCart(addFoodToCart, id!);
                      Utils.toastMessage("Food added to Cart Successfully");
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //   backgroundColor: Colors.orange,
                      //   content: Text(
                      //     "Food added to Cart Successfully",
                      //     style: TextStyle(fontSize: 20.0, color: Colors.white),
                      //   ),
                      // ));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 5, left: 5),
                      decoration: BoxDecoration(
                        color: const Color(0XFF8a4af3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
