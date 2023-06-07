import 'dart:convert';
import 'dart:math';

import 'package:particle_wallet_example/mock/test_account.dart';
import 'package:particle_auth/network/net/particle_rpc.dart';
import 'package:particle_auth/network/model/serialize_sol_transreqentity.dart';
class TransactionMock {
  static Future<String> mockSolanaTransaction(String publicAddress) async {
    final req = SerializeSOLTransReqEntity();
    req.lamports = TestAccount.solana.amount;
    req.receiver = TestAccount.solana.publicAddress;
    req.sender = publicAddress;

    final response =
        await SolanaService.enhancedSerializeTransaction(req);
       return jsonDecode(response)["result"]["transaction"]["serialized"];
  }

  static Future<String> mockEvmTransaction(String sendPubKey) async {
    String sender = sendPubKey;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = TestAccount.evm.tokenContractAddress;
    BigInt amount = TestAccount.evm.amount;

    final erc20Resp =
        await EvmService.erc20Transfer(contractAddress, receiver, amount);
    final data = jsonDecode(erc20Resp)["result"];

    final gasLimitResult = await EvmService.ethEstimateGas(
        sender, TestAccount.evm.publicAddress, "0x0", data);
    final jsonObj = jsonDecode(gasLimitResult);
    final gasLimit = jsonObj["result"];

    final gasFeesResult = await EvmService.suggestedGasFees();
    final maxFeePerGas = double.parse(
        jsonDecode(gasFeesResult)["result"]["high"]["maxFeePerGas"]);
    final maxFeePerGasHex =
        "0x${BigInt.from(maxFeePerGas * pow(10, 9)).toRadixString(16)}";

    final maxPriorityFeePerGas = double.parse(
        jsonDecode(gasFeesResult)["result"]["high"]["maxPriorityFeePerGas"]);
    final maxPriorityFeePerGasHex =
        "0x${BigInt.from(maxPriorityFeePerGas * pow(10, 9)).toRadixString(16)}";

    // evm transaction
    final req = {
      "from": sender,
      "to": contractAddress,
      "gasLimit": gasLimit,
      "value": "0x0",
      "maxFeePerGas": maxFeePerGasHex,
      "maxPriorityFeePerGas": maxPriorityFeePerGasHex,
      "data": data,
      "type": "0x2",
      "nonce": "0x0",
      "chainId": "0x${TestAccount.evm.chainId.toRadixString(16)}",
    };
    //to hexString
    final reqStr = jsonEncode(req);
    final reqHex = utf8.encode(reqStr).map((e) => e.toRadixString(16)).join();

    return "0x$reqHex";
  }
}
