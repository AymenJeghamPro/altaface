import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main/views/main_screen.dart';

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();

  WidgetsFlutterBinding.ensureInitialized();
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(const AltaFaceApp());
  });
}

class AltaFaceApp extends StatefulWidget with WidgetsBindingObserver {
  const AltaFaceApp({Key? key}) : super(key: key);

  @override
  _AltaFaceAppState createState() => _AltaFaceAppState();
}

class _AltaFaceAppState extends State<AltaFaceApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      theme: ThemeData(fontFamily: 'PTSans'),
    );
  }
}
