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
                    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IndVUE05RHNycml0Sy1jVHE2OWNKcCJ9.eyJlbWFpbCI6InBhbnRhb3ZheUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOi8vZGV2LXFyNi01OWVlLnVzLmF1dGgwLmNvbS8iLCJhdWQiOiJFVmpLMVpaUFN0UWNkV3VoandQZGRBdGdSaXdwNTRWUSIsImlhdCI6MTY5NTYxNjI5NywiZXhwIjoxNjk1NjUyMjk3LCJzdWIiOiJhdXRoMHw2MzAzMjE0YjZmNjE1NjM2YWM5MTdmMWIiLCJzaWQiOiJlM2NXRk5RYThIVWo1aXNZaXU1NllfR212dC1ZcVJZOSJ9.XMoC3wBoifLqqu0OEA8TTLq2m-vUxYUD5l37U4KuQvshMIVecHgBF2aGVNbYYS7PQwvdHf1XbWN3Srdlwb13w2JHecpn1-IpoBHnZgJG1YVPn1taLAm6xqUYurhQpeAW02MWf2moZ5Ko90g9cMYMC6Fhk8VrvVkfj3w8t5356mXQ9ypFincHO687-sK7H_IoaxG2Fsq_X7Pc4-8zlv3FFZJitdswpLEYxJMECZZTv_UTId7yvu_dP5_XnhcEHRnAW6f3LUKifzMICs0pOzOBnpuO01Towqlp6pbqLITYcu8gPs1PzmN0H0RphjSfQFEhX_HxVVqpE8qA_3XSRrwhwQ';
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
          ],
        ),
      ),
    );
  }
}
