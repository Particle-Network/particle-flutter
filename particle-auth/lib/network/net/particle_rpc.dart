import 'dart:convert';
import 'dart:math';

import 'package:particle_auth/model/smart_account_config.dart';
import 'package:particle_auth/network/net/response.dart';
import 'package:particle_auth/network/net/rest_client.dart';
import 'package:particle_auth/particle_auth.dart';

class RpcOutput<T> {
  late int chainId;
  late String jsonrpc;
  late int id;
  late T result;
}

String getCurrentTimestamp() {
  var now = DateTime.now();
  var timestamp = now.millisecondsSinceEpoch;
  return timestamp.toString();
}

class EvmService {
  static Future<dynamic> rpc(String method, List<dynamic> params) async {
    final req = RequestBodyEntity();
    req.chainId = await ParticleAuth.getChainId();
    req.jsonrpc = "2.0";
    req.id = getCurrentTimestamp();
    req.method = method;
    req.params = params;
    final result = await EvmRpcApi.getClient().rpc(req);
    RpcResponse response = RpcResponse.fromJson(jsonDecode(result));
    if (response.error != null) {
      return Future.error(response.error!);
    } else {
      return response.result;
    }
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
  static Future<dynamic> suggestedGasFees() async {
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
  /// [address] is user's public address
  static Future<dynamic> getTokensAndNFTs(String address) async {
    const method = "particle_getTokensAndNFTs";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get tokens
  ///
  /// [address] is user's public address
  static Future<dynamic> getTokens(String address) async {
    const method = "particle_getTokens";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get nfts
  ///
  /// [address] is user's public address
  static Future<dynamic> getNFTs(String address) async {
    const method = "particle_getNFTs";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get token by token addresses
  ///
  /// [address] is user's public address
  ///
  /// [tokenAddresses] is a token address list
  static Future<dynamic> getTokenByTokenAddresses(
      String address, List<String> tokenAddresses) async {
    const method = "particle_getTokensByTokenAddresses";
    final params = [address, tokenAddresses];
    return await EvmService.rpc(method, params);
  }

  /// Get transacions
  ///
  /// [address] is user's public address
  static Future<dynamic> getTransactionsByAddress(String address) async {
    const method = "particle_getTransactionsByAddress";
    final params = [address];
    return await EvmService.rpc(method, params);
  }

  /// Get token price,
  ///
  /// [tokenAddresses] is a token address list, for native token, pass "native"
  ///
  /// [currencies] is currency array, like ["usd", "cny"]
  static Future<dynamic> getPrice(
      List<String> tokenAddresses, List<String> currencies) async {
    const method = "particle_getPrice";
    final params = [tokenAddresses, currencies];
    return await EvmService.rpc(method, params);
  }

  /// Get smart account
  ///
  /// [eoaAddresses] Eoa address list
  ///
  /// return json object
  static Future<List<dynamic>> getSmartAccount(
      List<SmartAccountConfig> smartAccountConfigList) async {
    const method = "particle_aa_getSmartAccount";

    return await EvmService.rpc(method, smartAccountConfigList);
  }

  /// Read contract
  ///
  /// [address] is public address
  ///
  /// [contractAddress] is contract address
  ///
  /// [methodName] is a contract method name, such as 'mint', 'balanceOf'
  ///
  /// [parameters] is parameters required by the method
  ///
  /// [abiJsonString] is abi json string, such as "[{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"quantity\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
  static Future<dynamic> readContract(String address, String contractAddress,
      String methodName, List<Object> parameters, String abiJsonString) async {
    final data = await EvmService.customMethod(
        contractAddress, methodName, parameters, abiJsonString);

    final req = RequestBodyEntity();
    req.chainId = await ParticleAuth.getChainId();
    const method = "eth_call";
    final params = [
      {"to": contractAddress, "data": data, "from": address},
      "latest"
    ];

    final result = await EvmService.rpc(method, params);
    return result;
  }

  /// Write contract, get transaction
  ///
  /// [address] is public address
  ///
  /// [contractAddress] is contract address
  ///
  /// [methodName] is a contract method name, such as 'mint', 'balanceOf'
  ///
  /// [parameters] is parameters required by the method
  ///
  /// [abiJsonString] is abi json string, such as "[{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"quantity\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
  ///
  /// [gasFeeLevel] is gas fee level, default is high.
  static Future<String> writeContract(String address, String contractAddress,
      String methodName, List<Object> parameters, String abiJsonString,
      {GasFeeLevel gasFeeLevel = GasFeeLevel.high}) async {
    final data = await EvmService.customMethod(
        contractAddress, methodName, parameters, abiJsonString);

    return createTransaction(address, data, BigInt.from(0), contractAddress,
        gasFeeLevel: gasFeeLevel);
  }

  /// Create transaction
  ///
  /// [from] is public address
  ///
  /// [data] is contract transaction parameter
  ///
  /// [value] is navtie amount
  ///
  /// [to] if it is a contract transaction, to is contract address, if it is a native transaciton, to is receiver address.
  ///
  ///
  /// [gasFeeLevel] is gas fee level, default is high.
  static Future<String> createTransaction(
      String from, String data, BigInt value, String to,
      {GasFeeLevel gasFeeLevel = GasFeeLevel.high}) async {
    final valueHex = "0x${value.toRadixString(16)}";
    final gasLimit = await EvmService.ethEstimateGas(from, to, valueHex, data);

    final gasFees = await EvmService.suggestedGasFees();
    String level;

    switch (gasFeeLevel) {
      case GasFeeLevel.high:
        level = "high";
        break;

      case GasFeeLevel.medium:
        level = "medium";
        break;

      case GasFeeLevel.low:
        level = "low";
        break;
    }

    final maxFeePerGas = double.parse(gasFees[level]["maxFeePerGas"]);
    final maxFeePerGasHex =
        "0x${BigInt.from(maxFeePerGas * pow(10, 9)).toRadixString(16)}";

    final maxPriorityFeePerGas =
        double.parse(gasFees[level]["maxPriorityFeePerGas"]);
    final maxPriorityFeePerGasHex =
        "0x${BigInt.from(maxPriorityFeePerGas * pow(10, 9)).toRadixString(16)}";

    final chainId = await ParticleAuth.getChainId();
    final chainInfo = ChainInfo.getEvmChain(chainId);

    if (chainInfo == null) {
      throw Exception("cant find chain info for chain id $chainId");
    }

    Map<String, dynamic> req;
    final isSupportEIP1559 = chainInfo.isEIP1559Supported();
    // evm transaction
    if (isSupportEIP1559) {
      req = {
        "from": from,
        "to": to,
        "gasLimit": gasLimit,
        "value": valueHex,
        "maxFeePerGas": maxFeePerGasHex,
        "maxPriorityFeePerGas": maxPriorityFeePerGasHex,
        "data": data,
        "type": "0x2",
        "nonce": "0x0",
        "chainId": "0x${chainId.toRadixString(16)}",
      };
    } else {
      req = {
        "from": from,
        "to": to,
        "gasLimit": gasLimit,
        "value": valueHex,
        "gasPrice": maxFeePerGasHex,
        "data": data,
        "type": "0x0",
        "nonce": "0x0",
        "chainId": "0x${chainId.toRadixString(16)}",
      };
    }

    final reqStr = jsonEncode(req);
    final reqHex = StringUtils.toHexString(reqStr);

    return "0x$reqHex";
  }
}

class SolanaService {
  static Future<dynamic> rpc(String method, List<dynamic> params) async {
    final req = RequestBodyEntity();
    req.chainId = await ParticleAuth.getChainId();
    req.jsonrpc = "2.0";
    req.id = getCurrentTimestamp();
    req.method = method;
    req.params = params;
    final result = await SolanaRpcApi.getClient().rpc(req);
    RpcResponse response = RpcResponse.fromJson(jsonDecode(result));
    if (response.error != null) {
      return Future.error(response.error!);
    } else {
      return response.result;
    }
  }

  /// Get tokens and NFTs
  ///
  /// [address] is user's solana public address
  static Future<dynamic> getTokensAndNFTs(
      String address, bool parseMetadataUri) async {
    const method = "enhancedGetTokensAndNFTs";
    Map<String, dynamic> dict = {"parseMetadataUri": parseMetadataUri};
    final params = [address, dict];
    return await SolanaService.rpc(method, params);
  }

  /// Seralize SOL transaction
  /// [transaction] is a SerializeSOLTransaction object
  static Future<dynamic> serializeSolTransaction(
      SerializeSOLTransaction transaction) async {
    const method = "enhancedSerializeTransaction";
    final params = ["transfer-sol", transaction];
    return await SolanaService.rpc(method, params);
  }

  /// Seralize Spl token transaction
  /// [transaction] is a SerializeSplTokenTransaction object
  static Future<dynamic> serializeSplTokenTransaction(
      SerializeSplTokenTransaction transaction) async {
    const method = "enhancedSerializeTransaction";
    final params = ["transfer-token", transaction];
    return await SolanaService.rpc(method, params);
  }

  /// Seralize unwrap SOL transaction
  /// [transaction] is a SerializeWSOLTransaction object
  static Future<dynamic> serializeWSolTokenTransaction(
      SerializeWSOLTransaction transaction) async {
    const method = "enhancedSerializeTransaction";
    final params = ["unwrap-sol", transaction];
    return await SolanaService.rpc(method, params);
  }


  /// Get token price,
  ///
  /// [tokenAddresses] is a token address list, for native token, pass "native"
  ///
  /// [currencies] is currency array, like ["usd", "cny"]
  static Future<dynamic> getPrice(
      List<String> tokenAddresses, List<String> currencies) async {
    const method = "enhancedGetPrice";
    final params = [tokenAddresses, currencies];
    return await SolanaService.rpc(method, params);
  }

  /// Get transacions
  ///
  /// [address] is user's public address
  static Future<dynamic> getTransactionsByAddress(String address) async {
    const method = "enhancedGetTransactionsByAddress";
    final params = [address];
    return await SolanaService.rpc(method, params);
  }

  /// Get token by token addresses
  ///
  /// [address] is user's public address
  ///
  /// [tokenAddresses] is a token address list
  static Future<dynamic> getTokenByTokenAddresses(
      String address, List<String> tokenAddresses) async {
    const method = "enhancedGetTokensByTokenAddresses";
    final params = [address, tokenAddresses];
    return await SolanaService.rpc(method, params);
  }
}
