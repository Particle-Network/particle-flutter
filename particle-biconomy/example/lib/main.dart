
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_biconomy_example/biconomy_demo/biconomy_demo_auth.dart';
import 'package:particle_biconomy_example/biconomy_demo/biconomy_demo_connect.dart';

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
      animationBuilder: const OffsetAnimationBuilder(),
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 5),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Particle Network Flutter Demo '),
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
            //add a button
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
                          builder: (context) => const BiconomyDemoAuthPage(),
                        ),
                      )
                    },
                    child: const Text(
                      "Biconomy Auth",
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
                          builder: (context) => const BiconomyDemoConnectPage(),
                        ),
                      )
                    },
                    child: const Text(
                      "Biconomy Connect",
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
