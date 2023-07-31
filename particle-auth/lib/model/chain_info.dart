enum Env { dev, staging, production }

abstract class ChainInfo {
  late String? chainName;
  late int chainId;
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

  static EthereumChain sepolia() {
    return EthereumChain(11155111, "Sepolia");
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

  static ArbitrumChain one() {
    return ArbitrumChain(42161, "One");
  }

  static ArbitrumChain nova() {
    return ArbitrumChain(42170, "Nova");
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
    return PlatONChain(2206132, "Testnet");
  }
}

class TronChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  TronChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Tron.name;
  }

  static TronChain mainnet() {
    return TronChain(728126428, "Mainnet");
  }

  static TronChain shasta() {
    return TronChain(2494104990, "Shasta");
  }

  static TronChain nile() {
    return TronChain(3448148188, "Nile");
  }
}

class OKCChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  OKCChain(this.chainId, this.chainIdName) {
    chainName = ChainName.OKC.name;
  }

  static OKCChain mainnet() {
    return OKCChain(66, "Mainnet");
  }

  static OKCChain testnet() {
    return OKCChain(65, "Testnet");
  }
}

class ThunderCoreChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ThunderCoreChain(this.chainId, this.chainIdName) {
    chainName = ChainName.ThunderCore.name;
  }

  static ThunderCoreChain mainnet() {
    return ThunderCoreChain(108, "Mainnet");
  }

  static ThunderCoreChain testnet() {
    return ThunderCoreChain(18, "Testnet");
  }
}

class CronosChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  CronosChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Cronos.name;
  }

  static CronosChain mainnet() {
    return CronosChain(25, "Mainnet");
  }

  static CronosChain testnet() {
    return CronosChain(338, "Testnet");
  }
}

class OasisEmeraldChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  OasisEmeraldChain(this.chainId, this.chainIdName) {
    chainName = ChainName.OasisEmerald.name;
  }

  static OasisEmeraldChain mainnet() {
    return OasisEmeraldChain(42262, "Mainnet");
  }

  static OasisEmeraldChain testnet() {
    return OasisEmeraldChain(42261, "Testnet");
  }
}

class GnosisChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  GnosisChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Gnosis.name;
  }

  static GnosisChain mainnet() {
    return GnosisChain(102, "Mainnet");
  }

  static GnosisChain testnet() {
    return GnosisChain(10200, "Testnet");
  }
}

class CeloChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  CeloChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Celo.name;
  }

  static CeloChain mainnet() {
    return CeloChain(42220, "Mainnet");
  }

  static CeloChain testnet() {
    return CeloChain(44787, "Testnet");
  }
}

class KlaytnChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  KlaytnChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Klaytn.name;
  }

  static KlaytnChain mainnet() {
    return KlaytnChain(8217, "Mainnet");
  }

  static KlaytnChain testnet() {
    return KlaytnChain(1001, "Testnet");
  }
}

class ScrollChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ScrollChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Scroll.name;
  }

  static ScrollChain testnet() {
    return ScrollChain(534353, "Testnet");
  }
}

class ZkSyncChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ZkSyncChain(this.chainId, this.chainIdName) {
    chainName = ChainName.ZkSync.name;
  }

  static ZkSyncChain mainnet() {
    return ZkSyncChain(324, "Mainnet");
  }

  static ZkSyncChain testnet() {
    return ZkSyncChain(280, "Testnet");
  }
}

class MetisChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  MetisChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Metis.name;
  }

  static MetisChain mainnet() {
    return MetisChain(1088, "Mainnet");
  }

  static MetisChain testnet() {
    return MetisChain(599, "Testnet");
  }
}

class ConfluxESpaceChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ConfluxESpaceChain(this.chainId, this.chainIdName) {
    chainName = ChainName.ConfluxESpace.name;
  }

  static ConfluxESpaceChain mainnet() {
    return ConfluxESpaceChain(1030, "Mainnet");
  }

  static ConfluxESpaceChain testnet() {
    return ConfluxESpaceChain(71, "Testnet");
  }
}

class MapoChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  MapoChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Mapo.name;
  }

  static MapoChain mainnet() {
    return MapoChain(22776, "Mainnet");
  }

  static MapoChain testnet() {
    return MapoChain(212, "Testnet");
  }
}

class PolygonZkEVMChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  PolygonZkEVMChain(this.chainId, this.chainIdName) {
    chainName = ChainName.PolygonZkEVM.name;
  }

  static PolygonZkEVMChain mainnet() {
    return PolygonZkEVMChain(1101, "Mainnet");
  }

  static PolygonZkEVMChain testnet() {
    return PolygonZkEVMChain(1442, "Testnet");
  }
}

class BaseChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  BaseChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Base.name;
  }

  static BaseChain mainnet() {
    return BaseChain(8453, "Mainnet");
  }

  static BaseChain testnet() {
    return BaseChain(84531, "Testnet");
  }
}

class LineaChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  LineaChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Linea.name;
  }

  static LineaChain mainnet() {
    return LineaChain(59144, "Mainnet");
  }

  static LineaChain testnet() {
    return LineaChain(59140, "Goerli");
  }
}

class ComboChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ComboChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Combo.name;
  }

  static ComboChain testnet() {
    return ComboChain(91715, "Testnet");
  }
}

class MantleChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  MantleChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Mantle.name;
  }

  static MantleChain mainnet() {
    return MantleChain(5000, "Mainnet");
  }

  static MantleChain testnet() {
    return MantleChain(5001, "Testnet");
  }
}

class ZkMetaChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ZkMetaChain(this.chainId, this.chainIdName) {
    chainName = ChainName.ZkMeta.name;
  }

  static ZkMetaChain testnet() {
    return ZkMetaChain(12009, "Testnet");
  }
}

class OpBNBChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  OpBNBChain(this.chainId, this.chainIdName) {
    chainName = ChainName.OpBNB.name;
  }

  static OpBNBChain testnet() {
    return OpBNBChain(5611, "Testnet");
  }
}

class OKBCChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  OKBCChain(this.chainId, this.chainIdName) {
    chainName = ChainName.OKBC.name;
  }

  static OKBCChain testnet() {
    return OKBCChain(195, "Testnet");
  }
}

class TaikoChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  TaikoChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Taiko.name;
  }

  static TaikoChain testnet() {
    return TaikoChain(167005, "Testnet");
  }
}

class ReadOnChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ReadOnChain(this.chainId, this.chainIdName) {
    chainName = ChainName.ReadOn.name;
  }

  static ReadOnChain testnet() {
    return ReadOnChain(12015, "Testnet");
  }
}

class ZoraChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  ZoraChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Zora.name;
  }

  static ZoraChain mainnet() {
    return ZoraChain(7777777, "Mainnet");
  }

  static ZoraChain testnet() {
    return ZoraChain(999, "Testnet");
  }
}

class PGNChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  PGNChain(this.chainId, this.chainIdName) {
    chainName = ChainName.PGN.name;
  }

  static PGNChain mainnet() {
    return PGNChain(424, "Mainnet");
  }

  static PGNChain testnet() {
    return PGNChain(58008, "Testnet");
  }
}

class MantaChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  MantaChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Manta.name;
  }

  static MantaChain testnet() {
    return MantaChain(3441005, "Testnet");
  }
}

class NebuleChain implements ChainInfo {
  @override
  int chainId;

  @override
  String chainIdName;

  @override
  String? chainName;

  NebuleChain(this.chainId, this.chainIdName) {
    chainName = ChainName.Nebule.name;
  }

  static NebuleChain mainnet() {
    return NebuleChain(1482601649, "Mainnet");
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
  PlatON,
  Tron,
  OKC,
  ThunderCore,
  Cronos,
  OasisEmerald,
  Gnosis,
  Celo,
  Klaytn,
  Scroll,
  ZkSync,
  Metis,
  ConfluxESpace,
  Mapo,
  PolygonZkEVM,
  Base,
  Linea,
  Combo,
  Mantle,
  ZkMeta,
  OpBNB,
  OKBC,
  Taiko,
  ReadOn,
  Zora,
  PGN,
  Manta,
  Nebule
}
