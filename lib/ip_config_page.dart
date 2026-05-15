import 'package:clipyronment/Clipyronment.dart';
import 'package:flutter/material.dart';

class IPConfigPage extends StatefulWidget {
  const IPConfigPage({super.key});

  @override
  State<IPConfigPage> createState() => _IPConfigPageState();
}

class _IPConfigPageState extends State<IPConfigPage> {
  final TextEditingController _ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color hackerGreen = Color(0xFF00FF41);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'Images/img_1.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: hackerGreen, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: hackerGreen.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.terminal, color: hackerGreen, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        "SYSTEM LOGIN",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: hackerGreen,
                          fontFamily: 'monospace',
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _ipController,
                    style: const TextStyle(color: hackerGreen, fontFamily: 'monospace'),
                    cursorColor: hackerGreen,
                    decoration: InputDecoration(
                      labelText: "ACCESS_POINT_IP",
                      labelStyle: const TextStyle(color: hackerGreen, fontFamily: 'monospace'),
                      hintText: "192.168.x.x",
                      hintStyle: TextStyle(color: hackerGreen.withOpacity(0.4)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: hackerGreen),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: hackerGreen, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.lan, color: hackerGreen),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hackerGreen,
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        if (_ipController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Clipyronment(
                                ipAddress: _ipController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "ESTABLISH CONNECTION",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "SECURE_PROTOCOL_V2.0",
                    style: TextStyle(
                      fontSize: 10,
                      color: hackerGreen.withOpacity(0.5),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
}
