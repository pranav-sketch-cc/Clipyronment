import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Clipyronment extends StatefulWidget {
  const Clipyronment({super.key});
  @override
  State<Clipyronment> createState() => _Clipyronmentstate();
}

class _Clipyronmentstate extends State<Clipyronment> {

  String copiedText = "Loading...";
  Future<void> getClipboardText() async {

    try {
      final response = await http.get(
        Uri.parse("http://192.168.x.x:5000/clipboard"),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        setState(() {
          copiedText = data["text"];
        });
      }
      else {
        setState(() {
          copiedText = "Server Error";
        });
      }
    } catch (e) {

      setState(() {
        copiedText = "Connection Failed";
      });

    }
  }

  @override
  void initState() {
    super.initState();

    getClipboardText();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Clipyronment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [

          Image.asset(
            'Images/img.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Center(
            child: Card(
              color: Colors.white.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 100.0, right: 100.0, bottom: 500),
                child: Text(
                  "Copied Texts:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
