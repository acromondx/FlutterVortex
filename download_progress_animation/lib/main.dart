import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'fadein_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isDownloading = false;
  bool _isCompleted = false;
  late Ticker _ticker;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker((elapsed) {
      setState(() {
        _progress = _animationController.value;
      });
    });
    _ticker.start();

    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isCompleted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker.stop();
    _animationController.dispose();
    super.dispose();
  }

  void _onDownloadPressed() {
    setState(() {
      _isDownloading = true;
    });
    _animationController.forward();
  }

  double iconSize = 200;
  double circularSize = 200;

  final iconColor = Colors.white;
  final bkColor = Colors.grey.shade100;

  @override
  Widget build(BuildContext context) {
    const circularColor = Colors.green;

    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: true,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            centerTitle: true,
          )),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Download Progress Animation'),
        ),
        body: Center(
          child: _isCompleted
              ? FadeInWidget(
                  child: Icon(
                    Icons.download_done_rounded,
                    size: iconSize,
                    color: iconColor,
                  ),
                )
              : _isDownloading
                  ? AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: circularSize,
                              width: circularSize,
                              child: CircularProgressIndicator(
                                strokeWidth: 15,
                                color: circularColor,
                                backgroundColor: bkColor,
                                value: _animation.value,
                              ),
                            ),
                            Text(
                              '${(_progress * 100).round()}%',
                              style: TextStyle(
                                  fontSize: 32, color: Colors.green.shade50),
                            ),
                          ],
                        );
                      },
                    )
                  : GestureDetector(
                      onTap: _onDownloadPressed,
                      child: Icon(
                        Icons.download,
                        size: iconSize,
                        color: iconColor,
                      )),
        ),
      ),
    );
  }
}
