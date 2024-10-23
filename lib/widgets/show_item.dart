import 'package:flutter/material.dart';

class ShowItem extends StatefulWidget {
  const ShowItem({super.key});

  @override
  _ShowItemState createState() => _ShowItemState();
}

class _ShowItemState extends State<ShowItem> {
  bool fruit = false;
  bool meat = false;
  bool backery = false;
  bool beverages = false;
  bool oil = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                fruit = true;
                meat = false;
                backery = false;
                beverages = false;
                oil = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color:
                      fruit ? Colors.white : Color(0xff53B175).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xff53B175))),
              child: Column(
                children: [
                  Image.asset('assets/images/fruits.png',
                      height: 100, width: 100),
                  Text("Fruits & \nVegetables",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins'))
                ],
              ),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                fruit = false;
                meat = false;
                backery = true;
                beverages = false;
                oil = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: backery
                      ? Colors.white
                      : Color(0xffD3B0E0).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffD3B0E0))),
              child: Column(
                children: [
                  Image.asset('assets/images/backery.png',
                      height: 100, width: 100),
                  Text("Bakery\n Snacks",
                      style: TextStyle(fontFamily: 'Poppins'))
                ],
              ),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                fruit = false;
                meat = false;
                backery = false;
                beverages = true;
                oil = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: beverages
                      ? Colors.white
                      : Color(0xffB7DFF5).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffB7DFF5))),
              child: Column(
                children: [
                  Image.asset('assets/images/beverages.png',
                      height: 100, width: 100),
                  Text("Beverages\n", style: TextStyle(fontFamily: 'Poppins'))
                ],
              ),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                fruit = false;
                meat = true;
                backery = false;
                beverages = false;
                oil = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color:
                      meat ? Colors.white : Color(0xffF7A593).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffF7A593))),
              child: Column(
                children: [
                  Image.asset('assets/images/meat.png',
                      height: 100, width: 100),
                  Text("Meat & Fish\n", style: TextStyle(fontFamily: 'Poppins'))
                ],
              ),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                fruit = false;
                meat = false;
                backery = false;
                beverages = false;
                oil = true;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color:
                      oil ? Colors.white : Color(0xffF8A44C).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffF8A44C))),
              child: Column(
                children: [
                  Image.asset('assets/images/oil.png', height: 100, width: 100),
                  Text("Cooking Oil\n", style: TextStyle(fontFamily: 'Poppins'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
