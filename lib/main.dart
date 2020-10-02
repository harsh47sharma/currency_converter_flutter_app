import 'package:currencyconverterflutterapp/currencyconverter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]
  )
      .then((_) {
    runApp((MyApp()));
  });
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My app',
      home: CurrencyConverter(),
      /*initialRoute: '/',
      routes: {
        '/': (context) => FrontPage(),
        '/internetPage': (context) => NoInternetPage(),
      },*/
      theme: ThemeData(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.indigoAccent,
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
