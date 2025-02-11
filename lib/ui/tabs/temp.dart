import 'dart:async';

import 'package:flutter/material.dart';

class TimerProgressBar extends StatefulWidget {
  @override
  _TimerProgressBarState createState() => _TimerProgressBarState();
}

class _TimerProgressBarState extends State<TimerProgressBar> {
  double _progress = 0.0; // Progress value (0.0 to 1.0)
  int _duration = 10; // Total duration in seconds
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  void startProgress() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_progress < 1.0) {
        setState(() {
          _progress += 1 / _duration; // Increment progress
        });
      } else {
        _timer.cancel(); // Stop timer when progress reaches 100%
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer Progress Bar")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 20,
                color: Colors.blue,
                backgroundColor: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              "Progress: ${(_progress * 100).toInt()}%",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
