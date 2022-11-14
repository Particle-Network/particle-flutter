class RpcUrlConfig {
  String evmUrl;
  String solUrl;

  RpcUrlConfig(this.evmUrl, this.solUrl);

  RpcUrlConfig.fromJson(Map<String, dynamic> json)
      : evmUrl = json['evm_url'],
        solUrl = json['sol_url'];

  Map<String, dynamic> toJson() =>
      {'evm_url': evmUrl, 'sol_url': solUrl};
}
