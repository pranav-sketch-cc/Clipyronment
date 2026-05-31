import 'package:clipyronment/Clipyronment.dart';
import 'package:flutter/material.dart';

class ModeSelectionPage extends StatelessWidget {
  final String ipAddress;
  const ModeSelectionPage({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    const Color hackerGreen = Color(0xFF00FF41);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'Images/img_1.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.swap_horizontal_circle, color: hackerGreen, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "SELECT_MODE",
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
                const SizedBox(height: 10),
                Text(
                  "NODE_IP: $ipAddress",
                  style: TextStyle(
                    fontSize: 12,
                    color: hackerGreen.withOpacity(0.7),
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 50),
                

                _buildModeBox(
                  context,
                  title: "MOBILE_TO_LAPTOP",
                  icon: Icons.phone_android,
                  description: "Push local clipboard to remote node",
                  onTap: () {
                    debugPrint("Navigating to Mobile to Laptop mode");
                  },
                ),
                
                const SizedBox(height: 25),
                

                _buildModeBox(
                  context,
                  title: "LAPTOP_TO_MOBILE",
                  icon: Icons.laptop,
                  description: "Fetch remote clipboard to local buffer",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> Clipyronment(ipAddress: ipAddress)));
                    debugPrint("Navigating to Laptop to Mobile mode");
                  },
                ),
              ],
            ),
          ),
          
          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: hackerGreen),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeBox(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    const Color hackerGreen = Color(0xFF00FF41);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          border: Border.all(color: hackerGreen, width: 2),
          boxShadow: [
            BoxShadow(
              color: hackerGreen.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: hackerGreen, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: hackerGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      color: hackerGreen.withOpacity(0.6),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: hackerGreen),
          ],
        ),
      ),
    );
  }
}
