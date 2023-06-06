import 'dart:convert';

import 'package:particle_auth/network/model/serialize_sol_transreqentity.dart';
import 'package:particle_auth/network/net/request_body_entity.dart';
import 'package:particle_auth/network/net/rest_client.dart';
import 'package:particle_auth/particle_auth.dart';
import 'package:uuid/uuid.dart';

class RpcOutput<T> {
  late int chainId;
  late String jsonrpc;
  late int id;
  late T result;
}

class EvmService {
  static Future<String> rpc(String method, List<dynamic> params) async {
    final req = RequestBodyEntity();
    req.chainId = await ParticleAuth.getChainId();
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = method;
    req.params = params;
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Request data when send erc20 token.
  ///
  /// [contractAddress] is token address.
  ///
  /// [sender] is sender public address.
  ///
  /// [amount] is token amount that you want to send, for example send 0.01 token,
  /// and token decimals is 18, pass 10000000000000000.
  ///
  static Future<String> erc20Transfer(
      String contractAddress, String sender, BigInt amount) async {
    var list2 = [sender, amount.toString()];
    var list1 = [contractAddress, "erc20_transfer", list2];

    const method = "particle_abi_encodeFunctionCall";
    final params = list1;
    return await EvmService.rpc(method, params);
  }

  /// Request data when send erc721 nft.
  ///
  /// [contractAddress] is nft contract address.
  ///
  /// [sender] is sender public address.
  ///
  /// [to] is receiver public address.
  ///
  /// [tokenId] is nft token id.
  static Future<String> erc721SafeTransferFrom(
      String contractAddress, String sender, String to, String tokenId) async {
    var list2 = [sender, to, tokenId];
    var list1 = [contractAddress, "erc721_safeTransferFrom", list2];

    const method = "particle_abi_encodeFunctionCall";
    final params = list1;
    return await EvmService.rpc(method, params);
  }

  /// Request data when send erc1155 nft.
  ///
  /// [contractAddress] is nft contract address.
  ///
  /// [sender] is sender public address.
  ///
  /// [to] is receiver public address.
  ///
  /// [tokenId] is nft token id.
  ///
  /// [amount] is nft amount that you want to send, for example send 10 nft, pass "10"
  ///
  /// [data] can pass "0x"
  static Future<String> erc1155SafeTransferFrom(
      String contractAddress,
      String sender,
      String to,
      String tokenId,
      String amount,
      String data) async {
    var list2 = [sender, to, tokenId, amount, data];
    var list1 = [contractAddress, "erc1155_safeTransferFrom", list2];

    const method = "particle_abi_encodeFunctionCall";
    final params = list1;
    return await EvmService.rpc(method, params);
  }

  /// Request data when send erc20 approve.
  /// [contractAddress] is token contract address.
  ///
  /// [spender] is spender public address.
  ///
  /// [amount] is token amount.
  static Future<String> erc20Approve(
      String contractAddress, String spender, BigInt amount) async {
    var list2 = [spender, amount.toString()];
    var list1 = [contractAddress, "erc20_approve", list2];

    const method = "particle_abi_encodeFunctionCall";
    final params = list1;
    return await EvmService.rpc(method, params);
  }

  /// Request data when execute erc20 transferFrom.
  /// [contractAddress] is token contract address.
  ///
  /// [from] is from public address.
  ///
  /// [to] is to public address.
  ///
  /// [amount] is token amount.
  static Future<String> erc20TransferFrom(
      String contractAddress, String from, String to, BigInt amount) async {
    var list2 = [from, to, amount.toString()];
    var list1 = [contractAddress, "erc20_transferFrom", list2];

    const method = "particle_abi_encodeFunctionCall";
    final params = list1;
    return await EvmService.rpc(method, params);
  }

  /// Request contact method.
  ///
  /// [contractAddress] your contract address.
  ///
  /// [customMethod] your contract method name.
  ///
  /// [parameters] your method's parameters.
  ///
  /// [abiJsonString] your contract abi json string
  static Future<String> customMethod(
      String contractAddress,
      String customMethod,
      List<Object> parameters,
      String? abiJsonString) async {
    var list2 = parameters;
    var list1 = [contractAddress, "custom_$customMethod", list2, abiJsonString];

    const method = "particle_abi_encodeFunctionCall";
    final params = list1;
    return await EvmService.rpc(method, params);
  }

  /// Get suggesst fee
  /// return value unit is GWEI
  static Future<String> suggestedGasFees() async {
    const method = "particle_suggestedGasFees";
    final params = [];
    return await EvmService.rpc(method, params);
  }

  /// call eth_estimateGas, get gasLimit
  ///
  /// [from] is sender public address.
  ///
  /// [to] if send native token, is recevier address, if send erc20 token or nft, is contract address.
  ///
  /// [value] is native token amount in hex string.
  ///
  /// [data] transacion data
  static Future<String> ethEstimateGas(
      String from, String? to, String value, String data) async {
    const method = "eth_estimateGas";
    final params = [
      {"from": from, "to": to, "data": data, "value": value}
    ];
    return await EvmService.rpc(method, params);
  }

  /// Get tokens and nfts
  ///
  /// [address] is user public address
  static Future<String> getTokensAndNFTs(String address) async {
    const method = "particle_getTokensAndNFTs";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get tokens
  ///
  /// [address] is user public address
  static Future<String> getTokens(String address) async {
    const method = "particle_getTokens";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get nfts
  ///
  /// [address] is user public address
  static Future<String> getNFTs(String address) async {
    const method = "particle_getNFTs";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get token by token addresses
  ///
  /// [address] is user public address
  ///
  /// [tokenAddresses] is a token address list
  static Future<String> getTokenByTokenAddresses(
      String address, List<String> tokenAddresses) async {
    const method = "particle_getTokensByTokenAddresses";
    final params = [address, tokenAddresses];
    return await EvmService.rpc(method, params);
  }

  /// Get transacions
  ///
  /// [address] is user public address
  static Future<String> getTransactionsByAddress(String address) async {
    const method = "particle_getTransactionsByAddress";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get token price,
  ///
  /// [tokenAddresses] is a token address list, for native token, pass "native"
  ///
  /// [currencies] is currency array, like ["usd", "cny"]
  static Future<String> getPrice(
      List<String> tokenAddresses, List<String> currencies) async {
    const method = "particle_getTransactionsByAddress";
    final params = [tokenAddresses, currencies];
    return await EvmService.rpc(method, params);
  }
}

class SolanaService {
  static Future<String> rpc(String method, List<dynamic> params) async {
    final req = RequestBodyEntity();
    req.chainId = await ParticleAuth.getChainId();
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = method;
    req.params = params;
    return await SolanaRpcApi.getClient().rpc(req);
  }

  static Future<String> enhancedGetTokensAndNFTs(List<dynamic> parameters) async {
    const method = "enhancedGetTokensAndNFTs";
    final params = parameters;
    return await SolanaService.rpc(method, params);
  }

  static Future<String> enhancedSerializeTransaction(
      SerializeSOLTransReqEntity reqEntity) async {
    
    const method = "enhancedSerializeTransaction";
    final params = ["transfer-sol", reqEntity];
    return await SolanaService.rpc(method, params);
  }
}
