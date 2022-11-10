import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:particle_wallet_connect/model/Dapp_meta_data.dart';
import 'package:particle_wallet_connect/model/request_result.dart';
import 'package:particle_wallet_connect/model/wallet_meta_data.dart';
import 'package:particle_wallet_connect/particle_wallet_connect.dart';

class WalletConnectLogic {


  

  static init() {
    final name = "Flutter Wallet Connect Demo";
    final url = "https://particle.network";
    final icon = "https://connect.particle.network/icons/512.png";
    final description = "This is Flutter Wallet Connect Demo";
    final walletMetaData = WalletMetaData(name, icon, url, description);
    ParticleWalletConnect.init(walletMetaData);

    subscriptDidConnectSession();
    subscriptDidDisconnectSession();
    subscriptRequest();
    subscriptShouldStartSession();

    ParticleWalletConnect.registerCallback((event) {
      print(event);
      final eventObject = jsonDecode(event);
      final method = eventObject["method"] as String;
      if (method == "shouldStart") {
          
      final Map<String, dynamic> parsed = eventObject["data"]; 
      final dappMetaData = DappMetaData.fromJson(parsed);
      final topic = dappMetaData.topic;
      const publicAddress = "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4";
      const chainId = 5;
      ParticleWalletConnect.startSession(topic, publicAddress, chainId)

      } else if (method == "didConnect") {

      } else if (method == "didDisconnect") {

      } else if (method == "request") {

      }
    });
  }

  static void connect() async {
    const code = "wc:3338979D-9BDE-4104-BC8B-74CE2707D004@1?bridge=https%3A%2F%2Fbridge.walletconnect.org%2F&key=47ab5097ddccb132fc54ee3085dd5c9ba510df297d848b8ae65579977b3998b6";
    await ParticleWalletConnect.connect(code);

  }

  static void disconnect() {
    const topic = "";
    ParticleWalletConnect.disconnect(topic);
  }

  static void setCustomRpcUrl() {
    // you can set other rpc url
    const rpcUrl = "http://test.rpc.url";
    ParticleWalletConnect.setCustomRpcUrl(rpcUrl);
  }

  static void updateSession() {
    final topic = "";
    final publicAddress = "";
    final chainId = 5;
    ParticleWalletConnect.updateSession(topic, publicAddress, chainId);
  }

  static void removeSession() {
    const topic = "";
    ParticleWalletConnect.removeSessionBy(topic);
  }

  static void getSession() {
    const topic  = "";
    ParticleWalletConnect.getSessionBy(topic);
  }

  static void getAllSessions() {
    ParticleWalletConnect.getAllSessions();
  }

  static void subscriptRequest() async {
    final request = await ParticleWalletConnect.subscriptRequest();
    // handle request get result

    RequestResult result = RequestResult(request.requestId, true, "0x5");

    ParticleWalletConnect.handleRequest(result);
  }

  static void subscriptDidConnectSession() async {
    final dappMetaData = await ParticleWalletConnect.subscriptDidConnectSession();
    print(dappMetaData);
  }

  static void subscriptDidDisconnectSession() async {
    final dappMetaData = await ParticleWalletConnect.subscriptDidConnectSession();
    print(dappMetaData);
  }
  
  static void subscriptShouldStartSession() async {
    final dappMetaData = await ParticleWalletConnect.subscriptShouldStartSession();
  }

}