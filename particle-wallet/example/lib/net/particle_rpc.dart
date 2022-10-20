
import 'package:particle_wallet_example/mock/test_account.dart';
import 'package:particle_wallet_example/model/serialize_sol_transreqentity.dart';
import 'package:particle_wallet_example/model/serialize_trans_result_entity.dart';
import 'package:particle_wallet_example/net/request_body_entity.dart';
import 'package:particle_wallet_example/net/rest_client.dart';
import 'package:uuid/uuid.dart';

class RpcOutput<T> {
  late int chainId;
  late String jsonrpc;
  late int id;
  late T result;
}

class EvmService {
  static Future<String> rpc(RequestBodyEntity req) async {
    return await EvmRpcApi.getClient().rpc(req);
  }

  static Future<String> erc20Transfer(
      String contractAddress, String sender, BigInt amount) async {
    var list2 = [sender, amount.toString()];
    var list1 = [contractAddress, "erc20_transfer", list2];

    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_abi_encodeFunctionCall";
    req.params = list1;
    return await EvmRpcApi.getClient().rpc(req);
  }

  static Future<String> suggestedGasFees() async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_suggestedGasFees";
    req.params = [];
    return await EvmRpcApi.getClient().rpc(req);
  }


  static Future<String> ethEstimateGas(
      String from, String to, String value, String data) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "eth_estimateGas";
    req.params = [
      {"from": from, "to": to, "data": data, "value": value}
    ];
    return await EvmRpcApi.getClient().rpc(req);
  }
}

class SolanaService {
  static Future<String> rpc(RequestBodyEntity req) async {
    return await SolanaRpcApi.getClient().rpc(req);
  }

  static Future<String> enhancedGetTokensAndNFTs(List<dynamic> params) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.solana.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "enhancedGetTokensAndNFTs";
    req.params = params;
    return await SolanaRpcApi.getClient().rpc(req);
  }

  static Future<SerializeTransResultEntity> enhancedSerializeTransaction(
      SerializeSOLTransReqEntity reqEntity) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.solana.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "enhancedSerializeTransaction";
    req.params = ["transfer-sol", reqEntity];
    final resp =
        await SolanaRpcApi.getClient().enhancedSerializeTransaction(req);
    return resp;
  }
}
