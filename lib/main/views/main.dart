import 'package:flutter/material.dart';

import '../../af_core/repository_initializer.dart';
import 'main_screen.dart';

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
    RepositoryInitializer.initializeRepos();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      theme: ThemeData(fontFamily: 'PTSans'),
    );
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    // get current company
    super.didChangeAppLifecycleState(state);
  }
}
