import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            Image.asset('assets/images/dish.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                fit: BoxFit.fill),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fresh and Healthy",
                        style: AppWidgets.semiBoldTextFieldStyle()),
                    Text("Half Fry", style: AppWidgets.headerTextFieldStyle()),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a > 1) {
                      --a;
                    }

                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Text(a.toString(), style: AppWidgets.semiBoldTextFieldStyle()),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    ++a;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
              maxLines: 4,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Delivery Time",
                    style: AppWidgets.semiBoldTextFieldStyle()),
                SizedBox(width: 25),
                Text("30 min", style: AppWidgets.semiBoldTextFieldStyle()),
                SizedBox(width: 5),
                Icon(Icons.alarm, color: Colors.black54),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Price",
                          style: AppWidgets.semiBoldTextFieldStyle()),
                      Text("\$25", style: AppWidgets.boldTextFieldStyle()),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add to Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 18)),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.shopping_cart_outlined,
                              color: Colors.white),
                        ),
                        SizedBox(width: 10)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
