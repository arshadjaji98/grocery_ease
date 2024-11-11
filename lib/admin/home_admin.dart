import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/admin/add_food.dart';
import 'package:groceryease_delivery_application/services/database_services.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String? selectedCategory;
  final List<String> categories = [
    'Fruit',
    'Meat',
    'Beverages',
    'Bakery',
    'Oil'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Home Admin",
                style: AppWidgets.headerTextFieldStyle(),
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              hint: Text("Select Category"),
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFood()),
                );
              },
              child: Text("Add Food Item"),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: selectedCategory == null
                  ? Center(child: Text("Please select a category"))
                  : StreamBuilder<List<Map<String, dynamic>>>(
                      stream: DatabaseServices()
                          .getFoodItem(selectedCategory!)
                          .map((snapshot) {
                        return snapshot.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList();
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No items found"));
                        }

                        List<Map<String, dynamic>> foodItems = snapshot.data!;
                        return ListView.builder(
                          itemCount: foodItems.length,
                          itemBuilder: (context, index) {
                            final foodItem = foodItems[index];
                            return ListTile(
                              leading: foodItem['Image'] != null
                                  ? ClipRRect(
                                      child: Image.network(
                                        foodItem['Image'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.fastfood),
                              title: Text(foodItem['Name'] ?? 'No Name'),
                              subtitle:
                                  Text(foodItem['Detail'] ?? 'No Description'),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
