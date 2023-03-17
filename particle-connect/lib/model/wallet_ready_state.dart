enum WalletReadyState {
  /// User installed the wallet, check by package name
  installed,

  /// User not install the wallet.
  notDetected,

  /// Loadable wallets are always available to you. Since you can load them at any time
  loadable,

  /// The wallet is not support current chain
  unsupported,

  /// Can't detect if user install the wallet, maybe the wallet doesn't has a scheme.
  undetectable,
}
