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

class _Clipyronmentstate extends State<Clipyronment> with SingleTickerProviderStateMixin {
  String copiedText = "INITIALIZING...";
  bool isLoading = false;
  Timer? _timer;
  bool _isSyncing = false;
  int _syncCount = 0;
  late AnimationController _flickerController;

  Future<void> getClipboardText({bool silent = false}) async {
    if (!mounted) return;

    if (!silent) {
      setState(() {
        isLoading = true;
        copiedText = "INTERCEPTING DATA...";
      });
    } else {
      setState(() {
        _isSyncing = true;
      });
    }
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = "http://${widget.ipAddress}:5000/clipboard?cb=$timestamp";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Cache-Control": "no-cache, no-store, must-revalidate",
          "Pragma": "no-cache",
          "Expires": "0",
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String newText = data["text"] ?? "EMPTY_BUFFER";
        
        if (mounted) {
          setState(() {
            copiedText = newText;
            if (silent) _syncCount++;
          });
        }
      } else if (!silent && mounted) {
        setState(() {
          copiedText = "ERROR: STATUS_${response.statusCode}";
        });
      }
    } catch (e) {
      if (!silent && mounted) {
        setState(() {
          copiedText = "CONNECTION_REFUSED: UNREACHABLE_HOST";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          if (!silent) isLoading = false;
          _isSyncing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..repeat(reverse: true);
    
    getClipboardText();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getClipboardText(silent: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flickerController.dispose();
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
          "CLIPYRONMENT",
          style: TextStyle(
            color: hackerGreen,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                "ID:$_syncCount", 
                style: const TextStyle(color: hackerGreen, fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          )
        ],
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
              'Images/img_1.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
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
                    FadeTransition(
                      opacity: _isSyncing ? _flickerController : const AlwaysStoppedAnimation(1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isSyncing ? "SYNCING..." : "LIVE_FEED",
                            style: TextStyle(
                              color: _isSyncing ? Colors.white : hackerGreen,
                              fontFamily: 'monospace',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.circle, 
                            color: _isSyncing ? hackerGreen : Colors.red, 
                            size: 10
                          ),
                        ],
                      ),
                    ),
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
                          "FORCE_SCAN",
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
