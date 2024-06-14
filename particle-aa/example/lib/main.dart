import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_aa_example/aa_demo/aa_demo_auth_core.dart';
import 'package:particle_aa_example/aa_demo/aa_demo_connect.dart';
import 'package:particle_aa_example/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      // 2-A: wrap your app with OKToast
      textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.black,
      animationCurve: Curves.easeIn,
      animationBuilder: const OffsetAnimationBuilder().call,
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 5),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: pnPalette),
        home: const MyHomePage(title: 'Particle AA Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AADemoConnectPage(),
                        ),
                      )
                    },
                    child: const Text(
                      "AA Connect",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AADemoAuthCorePage(),
                        ),
                      )
                    },
                    child: const Text(
                      "AA Auth Core",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
