class BiconomyFeeMode {
  final String option;
  final dynamic feeQuote;
  final String? tokenPaymasterAddress;
  final dynamic wholeFeeQuote;

  /// select native for fee
  /// There are two use cases.
  /// pass null as wholeFeeQuote, to send a user paid transaction, use native as gas fee.
  /// specify wholeFeeQuote, that you can get from particle_biconomy rpcGetFeeQuotes, to send a user paid transaction, use native as gas fee.
  BiconomyFeeMode.native(this.wholeFeeQuote)
      : option = 'native',
        feeQuote = null,
        tokenPaymasterAddress = null;

  /// gasless
  /// There are two use cases.
  /// pass null as wholeFeeQuote, to send a gasless transaction.
  /// specify wholeFeeQuote, that you can get from particle_biconomy rpcGetFeeQuotes, to send a gasless transaction
  BiconomyFeeMode.gasless(this.wholeFeeQuote)
      : option = 'gasless',
        feeQuote = null,
        tokenPaymasterAddress = null;

  /// select token for fee
  /// specify feeQuote and tokenPaymasterAddress, that you can get from particle_biconomy rpcGetFeeQuotes, to send a user paid transaction, use token as gas fee.
  BiconomyFeeMode.token(this.feeQuote, this.tokenPaymasterAddress)
      : option = 'token',
        wholeFeeQuote = null;

  // toJson
  Map<String, dynamic> toJson() => {
        'option': option,
        'fee_quote': feeQuote,
        'token_paymaster_address': tokenPaymasterAddress,
        'whole_fee_quote': wholeFeeQuote,
      };

  // fromJson
  BiconomyFeeMode.fromJson(Map<String, dynamic> json)
      : option = json['option'],
        feeQuote = json['fee_quote'],
        tokenPaymasterAddress = json['token_paymaster_address'],
        wholeFeeQuote = json['whole_fee_quote'];
}
