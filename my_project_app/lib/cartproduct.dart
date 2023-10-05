import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_config.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> cartData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await http.get(
        Uri.parse("${AppConfig.SERVICE_URL}/api/cart/:userId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString("access_token")}'
        },
      );

      final json = jsonDecode(response.body);

      if (json["result"] == true) {
        setState(() {
          cartData = List.from(json["data"]);
        });
      } else {
        // แสดงข้อความหรือกระทบอื่น ๆ เมื่อมีข้อผิดพลาด
        print("มีข้อผิดพลาด: ${json['message']}");
        // เพิ่มบรรทัดนี้เพื่อตั้งค่า cartData เป็นรายการว่างเมื่อมีข้อผิดพลาด
        setState(() {
          cartData = [];
        });
      }
    } catch (e) {
      // แสดงข้อความข้อผิดพลาดเมื่อเกิดข้อผิดพลาด
      print("เกิดข้อผิดพลาด: $e");
    }
  }

  Widget buildCartList() {
    return ListView.builder(
      itemCount: cartData.length,
      itemBuilder: (context, index) {
        var cart = cartData[index];
        return Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff6ae792),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            title: Text(cart["product_name"]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cart["color_name"]),
                // เพิ่มข้อมูลอื่น ๆ ที่คุณต้องการแสดง
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตะกร้าสินค้า"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              // เปิดหน้าตะกร้าสินค้าเมื่อคลิกที่ไอคอนตะกร้า
              // คุณสามารถเพิ่มโค้ดเปิดหน้าตะกร้าสินค้าที่นี่
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFDCDF),
        child: buildCartList(),
      ),
    );
  }
}
