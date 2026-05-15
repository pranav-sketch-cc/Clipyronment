import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Clipyronment extends StatefulWidget {
  final String ipAddress;
  const Clipyronment({super.key, required this.ipAddress});

  @override
  State<Clipyronment> createState() => _Clipyronmentstate();
}

class _Clipyronmentstate extends State<Clipyronment> {
  String copiedText = "INITIALIZING...";
  bool isLoading = false;
  Timer? _timer;

  Future<void> getClipboardText({bool silent = false}) async {
    if (!silent) {
      setState(() {
        isLoading = true;
        copiedText = "INTERCEPTING DATA...";
      });
    }
    
    try {
      final response = await http.get(
        Uri.parse("http://${widget.ipAddress}:5000/clipboard"),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String newText = data["text"] ?? "EMPTY_BUFFER";
        if (mounted && copiedText != newText) {
          setState(() {
            copiedText = newText;
          });
        }
      } else if (!silent) {
        setState(() {
          copiedText = "ERROR: STATUS_${response.statusCode}";
        });
      }
    } catch (e) {
      if (!silent) {
        setState(() {
          copiedText = "CONNECTION_REFUSED: UNREACHABLE_HOST";
        });
      }
    } finally {
      if (mounted && !silent) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getClipboardText();
    // Set up a timer to refresh every 1 second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getClipboardText(silent: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Important: Stop the timer when the page is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color hackerGreen = Color(0xFF00FF41);
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: hackerGreen),
        title: const Text(
          "CLIP_INTERCEPTOR",
          style: TextStyle(
            color: hackerGreen,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: hackerGreen, height: 1.0),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'Images/img.png', // Changed back to img.png to match your previous setup
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.radar, color: hackerGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "REMOTE_NODE: ${widget.ipAddress}",
                      style: const TextStyle(
                        color: hackerGreen,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "LIVE_FEED",
                      style: TextStyle(
                        color: hackerGreen,
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.circle, color: Colors.red, size: 8),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      border: Border.all(color: hackerGreen.withOpacity(0.5)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "--- DECRYPTED_PAYLOAD ---",
                            style: TextStyle(
                              color: hackerGreen,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SelectableText(
                            copiedText,
                            style: const TextStyle(
                              fontSize: 16,
                              color: hackerGreen,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : () => getClipboardText(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: hackerGreen, width: 2),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: isLoading 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: hackerGreen, strokeWidth: 2)
                        )
                      : const Text(
                          "SCAN_CLIPBOARD",
                          style: TextStyle(
                            color: hackerGreen,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
