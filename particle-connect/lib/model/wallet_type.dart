enum WalletType {
  authCore,
  metaMask,
  rainbow,
  trust,
  imToken,
  bitKeep,
  walletConnect,
  phantom,
  okx,
}

WalletType parseWalletType(String? value) {
  switch (value) {
    case 'authCore':
      return WalletType.authCore;
    case 'metaMask':
      return WalletType.metaMask;
    case 'rainbow':
      return WalletType.rainbow;
    case 'trust':
      return WalletType.trust;
    case 'imToken':
      return WalletType.imToken;
    case 'bitKeep':
      return WalletType.bitKeep;
    case 'walletConnect':
      return WalletType.walletConnect;
    case 'phantom':
      return WalletType.phantom;
    case 'okx':
      return WalletType.okx;
    default:
      throw ArgumentError('Invalid WalletType value: $value');
  }
}