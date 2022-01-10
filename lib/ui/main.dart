import 'package:flutter/material.dart';
import 'package:flutter_projects/af_core/repository/repository_initializer.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'main/views/main_screen.dart';

void main() => runApp(const AltaFaceApp());

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
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        breakpoints: const [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      theme: ThemeData(fontFamily: 'PTSans'),
    );
  }

}
