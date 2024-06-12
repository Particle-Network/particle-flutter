
import 'package:particle_base/particle_base.dart';
import 'package:particle_auth_core_example/mock/test_account.dart';

class TransactionMock {
  static Future<String> mockSOLTransaction(String publicAddress) async {
    final transaction = SerializeSOLTransaction();
    transaction.lamports = TestAccount.solana.amount.toInt();
    transaction.receiver = TestAccount.solana.publicAddress;
    transaction.sender = publicAddress;

    final result = await SolanaService.serializeSolTransaction(transaction);
    final serializedTransaction = result["transaction"]["serialized"];
    return serializedTransaction;
  }

  static Future<String> mockSplTokenTransaction(String publicAddress) async {
    final transaction = SerializeSplTokenTransaction();
    transaction.amount = TestAccount.solana.amount.toInt();
    transaction.receiver = TestAccount.solana.publicAddress;
    transaction.mint = TestAccount.solana.tokenContractAddress;
    transaction.sender = publicAddress;
    final result =
        await SolanaService.serializeSplTokenTransaction(transaction);
    final serializedTransaction = result["transaction"]["serialized"];
    return serializedTransaction;
  }

  static Future<String> mockUnwrapWSOLTransaction(String publicAddress) async {
    final transaction = SerializeWSOLTransaction();
    transaction.address = publicAddress;

    final result =
        await SolanaService.serializeWSolTokenTransaction(transaction);
    final serializedTransaction = result["transaction"]["serialized"];
    return serializedTransaction;
  }

  /// Mock a transaction
  /// Send contract token in our test account, chain id 5.
  static Future<String> mockEvmSendToken(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = TestAccount.evm.tokenContractAddress;
    BigInt amount = TestAccount.evm.amount;
    String to = contractAddress;
    final data =
        await EvmService.erc20Transfer(contractAddress, receiver, amount);

    final transaction = await EvmService.createTransaction(
        from, data, BigInt.from(0), to,
        gasFeeLevel: GasFeeLevel.high);
    return transaction;
  }

  /// Mock a transaction
  /// Send native token in our test account
  static Future<String> mockEvmSendNative(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    BigInt amount = TestAccount.evm.amount;
    String to = receiver;
    const data = "0x";
    final transaction = await EvmService.createTransaction(
        from, data, amount, to,
        gasFeeLevel: GasFeeLevel.high);

    return transaction;
  }

  /// Mock a transaction
  /// Send erc721 nft in our test account, chain id 5.
  static Future<String> mockEvmErc721NFT(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = "0x9B1AAb1492c375F011811cBdBd88FFEf3ce2De76";
    String tokenId = "5301";
    String to = contractAddress;

    final data = await EvmService.erc721SafeTransferFrom(
        contractAddress, from, receiver, tokenId);

    final transaction = await EvmService.createTransaction(
        from, data, BigInt.from(0), to,
        gasFeeLevel: GasFeeLevel.high);

    return transaction;
  }

  /// Mock a transaction
  /// Send erc1155 nft in our test account, chain id 5.
  static Future<String> mockEvmErc1155NFT(String publicAddress) async {
    String from = publicAddress;
    String receiver = TestAccount.evm.receiverAddress;
    String contractAddress = TestAccount.evm.nftContractAddress;
    String tokenId = TestAccount.evm.nftTokenId;
    String to = contractAddress;
    String amount = "1";
    final data = await EvmService.erc1155SafeTransferFrom(
        contractAddress, from, receiver, tokenId, amount, "0x");
    final transaction = await EvmService.createTransaction(
        from, data, BigInt.from(0), to,
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
    final result = EvmService.writeContract(
        publicAddress, contractAddress, methodName, params, abiJsonString,
        gasFeeLevel: GasFeeLevel.high);

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
