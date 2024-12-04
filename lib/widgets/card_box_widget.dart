import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';
import 'package:shimmer/shimmer.dart';

class CardBox extends StatelessWidget {
  const CardBox({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.count,
    required this.icon,
    required this.onTap,
    required this.onPressed,
    super.key,
  });

  final String imageUrl;
  final String title;
  final String price;
  final String count;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0.6, 0.6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image with better constraints
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.2,
                    color: Colors.grey[300],
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Image.asset(
                    "assets/images/fruits.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: size.height * 0.2,
                  ),
                ),
                height: size.height * 0.2, // Responsive height
                width: double.infinity,
                fit: BoxFit.cover, // Maintains aspect ratio
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppWidgets.semiBoldTextFieldStyle()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Rs. ',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: price,
                                style: AppWidgets.boldTextFieldStyle()),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onPressed,
                        icon: Icon(
                          icon,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
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
