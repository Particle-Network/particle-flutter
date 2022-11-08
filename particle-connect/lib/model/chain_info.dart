enum Env { dev, staging, production }

abstract class ChainInfo {
  late String? chainName;
  late int chainId;
  late String chainIdName;
}

class SolanaChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  SolanaChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Solana.name;
  }

  static SolanaChain mainnet() {
    return SolanaChain(101, "Mainnet");
  }

  static SolanaChain testnet() {
    return SolanaChain(102, "Testnet");
  }

  static SolanaChain devnet() {
    return SolanaChain(103, "Devnet");
  }
}

class EthereumChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  EthereumChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Ethereum.name;
  }

  static EthereumChain mainnet() {
    return EthereumChain(1, "Mainnet");
  }

  static EthereumChain goerli() {
    return EthereumChain(5, "Goerli");
  }
}

class BSCChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  BSCChain(this.chainId, this.chainIdName) {
    chainName = ChainName.BSC.name;
  }

  static BSCChain mainnet() {
    return BSCChain(56, "Mainnet");
  }

  static BSCChain testnet() {
    return BSCChain(97, "Testnet");
  }
}

class PolygonChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  PolygonChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Polygon.name;
  }

  static PolygonChain mainnet() {
    return PolygonChain(137, "Mainnet");
  }

  static PolygonChain mumbai() {
    return PolygonChain(80001, "Mumbai");
  }
}

class AvalancheChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  AvalancheChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Avalanche.name;
  }

  static AvalancheChain mainnet() {
    return AvalancheChain(43114, "Mainnet");
  }

  static AvalancheChain testnet() {
    return AvalancheChain(43113, "Testnet");
  }
}

class MoonbeamChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  MoonbeamChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Moonbeam.name;
  }

  static MoonbeamChain mainnet() {
    return MoonbeamChain(1287, "Mainnet");
  }

  static MoonbeamChain testnet() {
    return MoonbeamChain(1285, "Testnet");
  }
}

class MoonriverChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  MoonriverChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Moonriver.name;
  }

  static MoonriverChain mainnet() {
    return MoonriverChain(1285, "Mainnet");
  }

  static MoonriverChain testnet() {
    return MoonriverChain(1287, "Testnet");
  }
}

class HecoChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  HecoChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Heco.name;
  }

  static HecoChain mainnet() {
    return HecoChain(128, "Mainnet");
  }

  static HecoChain testnet() {
    return HecoChain(256, "Testnet");
  }
}

class FantomChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  FantomChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Fantom.name;
  }

  static FantomChain mainnet() {
    return FantomChain(250, "Mainnet");
  }

  static FantomChain testnet() {
    return FantomChain(4002, "Testnet");
  }
}

class ArbitrumChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ArbitrumChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Arbitrum.name;
  }

  static ArbitrumChain mainnet() {
    return ArbitrumChain(42161, "Mainnet");
  }

  static ArbitrumChain goerli() {
    return ArbitrumChain(421613, "Goerli");
  }
}

class HarmonyChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  HarmonyChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Harmony.name;
  }

  static HarmonyChain mainnet() {
    return HarmonyChain(1666600000, "Mainnet");
  }

  static HarmonyChain testnet() {
    return HarmonyChain(1666700000, "Testnet");
  }
}

class AuroraChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  AuroraChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Aurora.name;
  }

  static AuroraChain mainnet() {
    return AuroraChain(1313161554, "Mainnet");
  }

  static AuroraChain testnet() {
    return AuroraChain(1313161555, "Testnet");
  }
}

class KccChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  KccChain(this.chainId, this.chainIdName) {
    chainName = ChainName.KCC.name;
  }

  static KccChain mainnet() {
    return KccChain(321, "Mainnet");
  }

  static KccChain testnet() {
    return KccChain(322, "Testnet");
  }
}

class OptimismChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  OptimismChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Optimism.name;
  }

  static OptimismChain mainnet() {
    return OptimismChain(10, "Mainnet");
  }

  static OptimismChain goerli() {
    return OptimismChain(420, "Goerli");
  }
}

class PlatONChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  PlatONChain(this.chainId, this.chainIdName) {
    chainName = ChainName.PlatON.name;
  }

  static PlatONChain mainnet() {
    return PlatONChain(60810, "Mainnet");
  }

  static PlatONChain testnet() {
    return PlatONChain(60801, "Testnet");
  }
}

enum ChainName {
  Solana,
  Ethereum,
  Avalanche,
  Polygon,
  Moonbeam,
  Moonriver,
  Heco,
  BSC,
  Fantom,
  Arbitrum,
  Harmony,
  Aurora,
  KCC,
  Optimism,
  PlatON;
}
