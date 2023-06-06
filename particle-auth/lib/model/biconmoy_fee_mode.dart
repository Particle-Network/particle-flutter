
class BiconomyFeeMode {
  final String option;
  final String? feeQuote;

  /// select native for fee
  BiconomyFeeMode.auto() : option = 'auto', feeQuote = null;
  /// gasless fee
  BiconomyFeeMode.gasless() : option = 'gasless', feeQuote = null;
  /// pick a feeQuote for fee, get feeQuote list from particle_biconomy rpcGetFeeQuotes
  BiconomyFeeMode.custom(this.feeQuote) : option = 'custom';

  // toJson
  Map<String, dynamic> toJson() => {
        'option': option,
        'feeQuote': feeQuote,
      };

  // fromJson
  BiconomyFeeMode.fromJson(Map<String, dynamic> json)
      : option = json['option'],
        feeQuote = json['feeQuote'];

}

