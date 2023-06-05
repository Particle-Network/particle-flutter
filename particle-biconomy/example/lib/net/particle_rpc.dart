import 'package:particle_biconomy_example/mock/test_account.dart';
import 'package:particle_biconomy_example/model/serialize_sol_transreqentity.dart';
import 'package:particle_biconomy_example/model/serialize_trans_result_entity.dart';
import 'package:particle_biconomy_example/net/request_body_entity.dart';
import 'package:particle_biconomy_example/net/rest_client.dart';
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

    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_abi_encodeFunctionCall";
    req.params = list1;
    return await EvmRpcApi.getClient().rpc(req);
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

    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_abi_encodeFunctionCall";
    req.params = list1;
    return await EvmRpcApi.getClient().rpc(req);
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

    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_abi_encodeFunctionCall";
    req.params = list1;
    return await EvmRpcApi.getClient().rpc(req);
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

    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_abi_encodeFunctionCall";
    req.params = list1;
    return await EvmRpcApi.getClient().rpc(req);
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

    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_abi_encodeFunctionCall";
    req.params = list1;
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Request contact method.
  ///
  /// [contractAddress] your contract address.
  ///
  /// [method] your contract method name.
  ///
  /// [params] your method's parameters.
  ///
  /// [abiJsonString] your contract abi json string
  static Future<String> customMethod(String contractAddress, String method,
      List<Object> params, String? abiJsonString) async {
    var list2 = params;
    var list1 = [contractAddress, "custom_$method", list2, abiJsonString];

    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_abi_encodeFunctionCall";
    req.params = list1;
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Get suggesst fee
  /// return value unit is GWEI
  static Future<String> suggestedGasFees() async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_suggestedGasFees";
    req.params = [];
    return await EvmRpcApi.getClient().rpc(req);
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

  /// Get tokens and nfts
  ///
  /// [address] is user public address
  static Future<String> getTokensAndNFTs(String address) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_getTokensAndNFTs";
    req.params = [address];
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Get tokens
  ///
  /// [address] is user public address
  static Future<String> getTokens(String address) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_getTokens";
    req.params = [address];
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Get nfts
  ///
  /// [address] is user public address
  static Future<String> getNFTs(String address) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_getNFTs";
    req.params = [address];
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Get token by token addresses
  ///
  /// [address] is user public address
  ///
  /// [tokenAddresses] is a token address list
  static Future<String> getTokenByTokenAddresses(
      String address, List<String> tokenAddresses) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_getTokensByTokenAddresses";
    req.params = [address, tokenAddresses];
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Get transacions
  ///
  /// [address] is user public address
  static Future<String> getTransactionsByAddress(String address) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_getTransactionsByAddress";
    req.params = [address];
    return await EvmRpcApi.getClient().rpc(req);
  }

  /// Get token price,
  ///
  /// [tokenAddresses] is a token address list, for native token, pass "native"
  ///
  /// [currencies] is currency array, like ["usd", "cny"]
  static Future<String> getPrice(
      List<String> tokenAddresses, List<String> currencies) async {
    final req = RequestBodyEntity();
    req.chainId = TestAccount.evm.chainId;
    req.jsonrpc = "2.0";
    req.id = const Uuid().v4();
    req.method = "particle_getTransactionsByAddress";
    req.params = [tokenAddresses, currencies];
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
