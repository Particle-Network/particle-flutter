import 'dart:convert';

import 'package:particle_wallet_connect/model/Dapp_info.dart';
import 'package:particle_wallet_connect/model/request_result.dart';
import 'package:particle_wallet_connect/model/wallet_meta_data.dart';
import 'package:particle_wallet_connect/particle_wallet_connect.dart';

class WalletConnectLogic {
  static String topic = "";

  static init() {
    const name = "Flutter Wallet Connect Demo";
    const url = "https://particle.network";
    const icon = "https://connect.particle.network/icons/512.png";
    const description = "This is Flutter Wallet Connect Demo";
    final walletMetaData = WalletMetaData(name, icon, url, description);
    ParticleWalletConnect.init(walletMetaData);

    ParticleWalletConnect.registerCallback((event) async {
      if (event is String) {
        final eventObject = jsonDecode(event);
        final eventMethod = eventObject["eventMethod"] as String;
        if (eventMethod == "shouldStart") {
          final Map<String, dynamic> parsed = eventObject["data"];
          final dappMetaData = DappInfo.fromJson(parsed);
          print(dappMetaData.toString());
          final topic = dappMetaData.topic;
          const publicAddress = "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4";
          const chainId = 5;
          ParticleWalletConnect.startSession(topic, publicAddress, chainId);
        } else if (eventMethod == "didConnect") {
          final Map<String, dynamic> parsed = eventObject["data"];
          final dappMetaData = DappInfo.fromJson(parsed);
          print(dappMetaData.toString());
        } else if (eventMethod == "didDisconnect") {
          final Map<String, dynamic> parsed = eventObject["data"];
          final dappMetaData = DappInfo.fromJson(parsed);
          print(dappMetaData.toString());
        } else if (eventMethod == "request") {
          final requestId = eventObject["data"]["request_id"] as String;
          final method = eventObject["data"]["method"] as String;
          // method should be one of the following methods.
          // other methods will be handle by ParticleWalletConnect
          // you can define rpc endpoint to
          //*
          // eth_sendTransaction
          // eth_signTypedData
          // eth_signTypedData_v1
          // eth_signTypedData_v3
          // eth_signTypedData_v4
          // personal_sign
          // eth_chainId
          // wallet_switchEthereumChain
          //*/
          List<dynamic>? params =
              eventObject["data"]["params"] as List<dynamic>?;

          RequestResult result = await handleRequest(requestId, method, params);
          ParticleWalletConnect.handleRequest(result);
        }
      } else {
        print(event);
      }
    });
  }

  static Future<RequestResult> handleRequest(
      String requestId, String method, List<dynamic>? params) async {
    print("request $method with $params");

    // handle request from dapp and return request
    // we user particle_auth to handle the request
    RequestResult result = RequestResult(requestId, true, "0xajswsw");
    return result;
  }

  static void connect(String code) async {
    await ParticleWalletConnect.connect(code);
  }

  static void disconnect() {
    ParticleWalletConnect.disconnect(topic);
  }

  static void setCustomRpcUrl() {
    // you can set other rpc url
    const rpcUrl = "http://test.rpc.url";
    ParticleWalletConnect.setCustomRpcUrl(rpcUrl);
  }

  static void updateSession() {
    const publicAddress = "";
    const chainId = 1;
    ParticleWalletConnect.updateSession(topic, publicAddress, chainId);
  }

  static void removeSession() {
    ParticleWalletConnect.removeSessionBy(topic);
  }

  static void getSession() {
    ParticleWalletConnect.getSessionBy(topic);
  }

  static void getAllSessions() async {
    List<DappInfo> dappMetaDatas = await ParticleWalletConnect.getAllSessions();
    print(dappMetaDatas);
    topic = dappMetaDatas.first.topic;
  }
}
