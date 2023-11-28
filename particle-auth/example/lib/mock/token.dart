class Token {
  final String address;
  final BigInt amount;
  final String symbol;
  final String image;
  final String name;
  final int decimals;

  Token(
      {required this.address,
      required this.amount,
      required this.symbol,
      required this.image,
      required this.name,
      required this.decimals});

  factory Token.fromJson(Map<String, dynamic> json) {
    final amountJson = json['amount'];
    BigInt amount;
    if (amountJson is String) {
      amount = BigInt.tryParse(amountJson, radix: 10) ?? BigInt.from(0);
    } else if (amountJson is int) {
      amount = BigInt.from(amountJson);
    } else {
      amount = BigInt.from(0);
    }

    return Token(
      address: json['address'] as String,
      amount: amount,
      symbol: json['symbol'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
      decimals: json['decimals'] as int,
    );
  }
}
