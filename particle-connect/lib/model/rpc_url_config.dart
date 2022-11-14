class RpcUrlConfig {
  String evmUrl;
  String solUrl;
  
  RpcUrlConfig(this.evmUrl, this.solUrl);

  RpcUrlConfig.fromJson(Map<String, dynamic> json)
      : evmUrl = json['evm_url'],
        solUrl = json['sol_url'];

  static Map<String, dynamic> toJson(RpcUrlConfig value) => {
        'evm_url': value.evmUrl,
        'sol_url': value.solUrl
      };
}