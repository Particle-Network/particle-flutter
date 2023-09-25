import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_auth_core_example/auth_core_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
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
        home: const MyHomePage(title: 'Auth Core Demo'),
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
            ElevatedButton(
              onPressed: () {
                print('init');
                AuthCoreDemo.init(Env.dev);
              },
              child: const Text(
                "Init",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Connect');
                // your jwt
                const jwt =
                    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IndVUE05RHNycml0Sy1jVHE2OWNKcCJ9.eyJlbWFpbCI6InBhbnRhb3ZheUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOi8vZGV2LXFyNi01OWVlLnVzLmF1dGgwLmNvbS8iLCJhdWQiOiJFVmpLMVpaUFN0UWNkV3VoandQZGRBdGdSaXdwNTRWUSIsImlhdCI6MTY5MzU1MTUyOSwiZXhwIjoxNjkzNTg3NTI5LCJzdWIiOiJhdXRoMHw2MzAzMjE0YjZmNjE1NjM2YWM5MTdmMWIiLCJzaWQiOiJCcjlQUG1rSEdTT3NraF9aNnlWVlpYcldsRjVZOVRQQSJ9.iua1V9QxvEv2M5Zt4hF8PR4YzGmMzaQgW_whbA4Qs2R4ChizWHjVBXSciZFWsNhHrlBnTSD242nQkh0CjifY8d05mqvsfFQDejBDXmcyjLIj3biRF3nHMY0XGMoLkhSdqHLCoyXRlmfkrn-GD0bvvzJAK2wj_5MVB8q6ymGUu_Yutxl9aTnvPuCV4lyfUFNcGXJH63t3KPWuO-xFxiJXEVQQu9m1--byyizHr4G31jMA034dIfQMk9MgWFfBIdDtFr3Vym70aVtnLczx304zolIRN7JNOP7TqazJOu0MaQcCEemqZ_zy68WzAWiwiq0lTslv83nr7-k161Mf0UUoxg';
                AuthCoreDemo.connect(jwt);
              },
              child: const Text(
                "Connect",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('isConnected');
                AuthCoreDemo.isConnected();
              },
              child: const Text(
                "isConnected",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('getUserInfo');
                AuthCoreDemo.getUserInfo();
              },
              child: const Text(
                "getUserInfo",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
