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
                'Init',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Connect');
                // your jwt
                const jwt =
                    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IndVUE05RHNycml0Sy1jVHE2OWNKcCJ9.eyJlbWFpbCI6InBhbnRhb3ZheUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOi8vZGV2LXFyNi01OWVlLnVzLmF1dGgwLmNvbS8iLCJhdWQiOiJFVmpLMVpaUFN0UWNkV3VoandQZGRBdGdSaXdwNTRWUSIsImlhdCI6MTY5NTY5ODQwOCwiZXhwIjoxNjk1NzM0NDA4LCJzdWIiOiJhdXRoMHw2MzAzMjE0YjZmNjE1NjM2YWM5MTdmMWIiLCJzaWQiOiJlM2NXRk5RYThIVWo1aXNZaXU1NllfR212dC1ZcVJZOSJ9.ieWabUNfaYrC1zYMr4OsdEnkdgjrQ1y71A4BgxxxHXMTmRObcrKVBr37cb39Ji9o6qNP8LmJCJ0hwoEAAX90UQ5XjdtCkzAHvgfwOuJW3st7_TSZj7zW_e17PdAPmJnUWJhsQvIjpB5aUFbobxl2XGPgZrAcpXe2pre6d7N8M4uOj5MFHpWyFNgFls0h6o_8Vec0hSQ78JYcGkfAamnBskP5fUeyae0fGkXA4sKn89todEIZJgsIxbbMaa4TWDz0zLBQVfeCGhk3vU_hE-QeMhXGejZRqdb8c0H8toChSbaDmSvN0_wgNm-h91PP5MQPkCOZIxdWiFwih5pvI8WMwQ';
                AuthCoreDemo.connect(jwt);
              },
              child: const Text(
                'Connect',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('disconnect');
                AuthCoreDemo.disconnect();
              },
              child: const Text(
                'disConnect',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('isConnected');
                AuthCoreDemo.isConnected();
              },
              child: const Text(
                'isConnected',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('getUserInfo');
                AuthCoreDemo.getUserInfo();
              },
              child: const Text(
                'getUserInfo',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('switchChain');
                AuthCoreDemo.switchChain(ChainInfo.EthereumGoerli.id);
              },
              child: const Text(
                'switchChain',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('evmGetAddress');
                AuthCoreDemo.evmGetAddress();
              },
              child: const Text(
                'evmGetAddress',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('solanaGetAddress');
                AuthCoreDemo.solanaGetAddress();
              },
              child: const Text(
                'solanaGetAddress',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('personalSign');
                const message = 'Hello world!';
                AuthCoreDemo.evmPersonalSign(message);
              },
              child: const Text(
                'personalSign evm',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('personalSignUnique');
                const message = 'Hello world!';
                AuthCoreDemo.evmPersonalSignUnique(message);
              },
              child: const Text(
                'personalSignUnique evm',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('solanaSignMessage');
                const message = 'Hello world!';
                AuthCoreDemo.solanaSignMessage(message);
              },
              child: const Text(
                'solanaSignMessage solana',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('hasMasterPassword');
                AuthCoreDemo.hasMasterPassword();
              },
              child: const Text(
                'hasMasterPassword',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('changeMasterPassword');
                AuthCoreDemo.changeMasterPassword();
              },
              child: const Text(
                'changeMasterPassword',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('hasPaymentPassword');
                AuthCoreDemo.hasPaymentPassword();
              },
              child: const Text(
                'hasPaymentPassword',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('openAccountAndSecurity');
                AuthCoreDemo.openAccountAndSecurity();
              },
              child: const Text(
                'openAccountAndSecurity',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
