import 'dart:convert';
import 'package:particle_auth/particle_auth.dart';
import 'package:particle_biconomy_example/mock/test_account.dart';

class TransactionMock {
  static Future<String> mockSolanaTransaction(String publicAddress) async {
    final req = SerializeSOLTransReqEntity();
    req.lamports = TestAccount.solana.amount;
    req.receiver = TestAccount.solana.publicAddress;
    req.sender = publicAddress;

    final response = await SolanaService.enhancedSerializeTransaction(req);
    return jsonDecode(response)["result"]["transaction"]["serialized"];
  }

  /// Mock a transaction
  /// Send contract token in our test account, chain id 5.
  /// Chain id 5 is Ethereum goerli, supports EIP1559, so the transaction is type2.
  /// If your chain id did not support EIP1559, go to method `mockEvmSendTokenUnsupportEip1559`.
  static Future<String> mockEvmSendToken(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = TestAccount.evm.tokenContractAddress;
    BigInt amount = TestAccount.evm.amount;
    String to = contractAddress;
    final erc20Resp =
        await EvmService.erc20Transfer(contractAddress, receiver, amount);
    final data = jsonDecode(erc20Resp)["result"];

    const isSupportEIP1559 = true;

    final transaction = await EvmService.createTransaction(
        from, data, BigInt.from(0), to, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.high);
    return transaction;
  }

  /// Mock a transaction
  /// Send native token in our test account, chain id 5.
  /// Chain id 5 is Ethereum goerli, supports EIP1559.
  static Future<String> mockEvmSendNative(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    BigInt amount = TestAccount.evm.amount;
    String to = receiver;
    const data = "0x";
    const isSupportEIP1559 = true;
    final transaction = await EvmService.createTransaction(
        from, data, amount, to, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.high);

    return transaction;
  }

  /// Mock a transaction that chain not support eip1559.
  /// The example show you how to config a type0/legacy transaction.
  /// You can replace parameters to test.
  static Future<String> mockEvmSendTokenUnsupportEip1559(
      String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = TestAccount.evm.tokenContractAddress;
    BigInt amount = TestAccount.evm.amount;
    String to = contractAddress;
    final erc20Resp =
        await EvmService.erc20Transfer(contractAddress, receiver, amount);
    final data = jsonDecode(erc20Resp)["result"];

    const isSupportEIP1559 = false;
    final transaction = await EvmService.createTransaction(
        from, data, BigInt.from(0), to, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.high);

    return transaction;
  }

  /// Mock a transaction
  /// Send erc721 nft in our test account, chain id 5.
  /// Chain id 5 is Ethereum goerli, supports EIP1559, so the transaction is type2.
  /// If your chain id did not support EIP1559, go to method mockEvmSendTokenUnsupportEip1559.
  static Future<String> mockEvmErc721NFT(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = "0x9B1AAb1492c375F011811cBdBd88FFEf3ce2De76";
    String tokenId = "5301";
    String to = contractAddress;

    final erc20Resp = await EvmService.erc721SafeTransferFrom(
        contractAddress, from, receiver, tokenId);
    final data = jsonDecode(erc20Resp)["result"];

    const isSupportEIP1559 = true;
    final transaction = await EvmService.createTransaction(
        from, data, BigInt.from(0), to, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.high);

    return transaction;
  }

  /// Mock a transaction
  /// Send erc1155 nft in our test account, chain id 5.
  /// Chain id 5 is Ethereum goerli, supports EIP1559, so the transaction is type2.
  /// If your chain id did not support EIP1559, go to method mockEvmSendTokenUnsupportEip1559.
  static Future<String> mockEvmErc1155NFT(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = TestAccount.evm.nftContractAddress;
    String tokenId = TestAccount.evm.nftTokenId;
    String to = contractAddress;
    String amount = "1";
    final erc20Resp = await EvmService.erc1155SafeTransferFrom(
        contractAddress, from, receiver, tokenId, amount, "0x");
    final data = jsonDecode(erc20Resp)["result"];
    const isSupportEIP1559 = true;
    final transaction = await EvmService.createTransaction(
        from, data, BigInt.from(0), to, isSupportEIP1559,
        gasFeeLevel: GasFeeLevel.high);

    return transaction;
  }

  /// Mock a transaction, write contract
  /// write contract is same with send transaction.
  static Future<String> mockWriteContract(String publicAddress) async {
    String contractAddress = "your contract address";
    String methodName =
        "mint"; // this is your contract method name, like balanceOf, mint.
    List<Object> params = <Object>["1"]; // this is the method params.

    // abi json string, you can get it from your contract developer.
    // such as
    // [{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"quantity\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]
    const abiJsonString = null;
    const isSupportEIP1559 = true;
    final result = EvmService.writeContract(publicAddress, contractAddress,
        methodName, params, abiJsonString, isSupportEIP1559, gasFeeLevel: GasFeeLevel.high);

    return result;
  }

  /// Mock read contract
  /// read data from chain
  static Future<String> mockReadContract(String publicAddress) async {
    String contractAddress = "your contract address";
    String methodName =
        "mint"; // this is your contract method name, like balanceOf, mint.
    List<Object> parameters = <Object>["1"]; // this is the method params.
    // this is your contract ABI json string

    // abi json string, you can get it from your contract developer.
    // such as
    // [{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"quantity\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]
    const abiJsonString = null;

    final result = await EvmService.readContract(
        publicAddress, contractAddress, methodName, parameters, abiJsonString);
    return result;
  }
}
