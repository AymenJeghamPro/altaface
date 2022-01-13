import 'package:flutter/material.dart';
import 'package:flutter_projects/af_core/repository/repository_initializer.dart';
import 'main/views/main_screen.dart';

void main() => runApp(const AltaFaceApp());

class AltaFaceApp extends StatefulWidget with WidgetsBindingObserver {
  const AltaFaceApp({Key? key}) : super(key: key);

  @override
  _AltaFaceAppState createState() => _AltaFaceAppState();
}

class _AltaFaceAppState extends State<AltaFaceApp> with WidgetsBindingObserver{

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
