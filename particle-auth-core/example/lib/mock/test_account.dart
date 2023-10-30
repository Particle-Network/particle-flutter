class TestAccount {
  late String publicAddress;
  late String privateKey;
  late String mnemonic;
  late String tokenContractAddress;
  late BigInt amount;
  late String nftContractAddress;
  late String nftTokenId;
  late String receiverAddress;
  late int chainId;

  TestAccount(
      this.publicAddress,
      this.privateKey,
      this.mnemonic,
      this.tokenContractAddress,
      this.amount,
      this.nftContractAddress,
      this.nftTokenId,
      this.receiverAddress,
      this.chainId);

  /// This is a evm test account with some test token, you can use this account do all test cases.
  static TestAccount evm = TestAccount(
      "0x2648cfE97e33345300Db8154670347b08643570b",
      "eacd18277e3cfca6446801b7587c9d787d5ee5d93f6a38752f7d94eddadc469e",
      "hood result social fetch pet code check yard school jealous trick lazy",
      "0x326C977E6efc84E512bB9C30f76E30c160eD06FB",
      BigInt.from(1000000000000000),
      "0xD000F000Aa1F8accbd5815056Ea32A54777b2Fc4",
      "1412",
      "0xAC6d81182998EA5c196a4424EA6AB250C7eb175b",
      5);

  /// This is a solana test account with some test token, you can use this account do all test cases.
  static TestAccount solana = TestAccount(
      "Cnbvi3bjBkYbWPVHG4dp6GAZD3qUp8nj9YsVt2PEgH77",
      "5fBYPZdP5nqH5DSAjgjMi4aSf113m5PuavakojZ7C9svt1i8vyq26pXpEf1Suivg91TUAp7TX1pqK49rgXQfAAjT",
      "vacant focus country eye wine where lady doll boat sort ticket grab",
      "GobzzzFQsFAHPvmwT42rLockfUCeV3iutEkK218BxT8K",
      BigInt.from(10000000),
      "HLyQCnxBo5SGmYBv3aRCH9tPqT9TvexHY2JaGnqvfWuw",
      "",
      "9LR6zGAFB3UJcLg9tWBQJxEJCbZh2UTnSU14RBxsK1ZN",
      103);
}
