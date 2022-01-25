import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({Key? key}) : super(key: key);

  @override
  State<ImageCaptureScreen> createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Center(child: Body()),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Image Capture Screen');
  }
}
