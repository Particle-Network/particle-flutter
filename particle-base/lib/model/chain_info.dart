class ChainInfoNativeCurrency {
  late String name;
  late String symbol;
  late int decimals;

  ChainInfoNativeCurrency(this.name, this.symbol, this.decimals);
}

class ChainInfoFeature {
  late String name;

  ChainInfoFeature(this.name);
}

class ChainInfo {
  late int id;
  late String name;
  late String chainType;
  late String icon;
  late String fullname;
  late String network;
  late String website;
  late ChainInfoNativeCurrency nativeCurrency;
  late String rpcUrl;
  late String faucetUrl;
  late String blockExplorerUrl;
  late List<ChainInfoFeature> features;

  ChainInfo(
    this.id,
    this.name,
    this.chainType,
    this.icon,
    this.fullname,
    this.network,
    this.website,
    this.nativeCurrency,
    this.rpcUrl,
    this.faucetUrl,
    this.blockExplorerUrl,
    this.features,
  );

  // template code start
  static ChainInfo Ethereum = ChainInfo(
        1,
        'Ethereum',
        'evm',
        'https://static.particle.network/token-list/ethereum/native.png',
        'Ethereum Mainnet',
        'Mainnet',
        'https://ethereum.org',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://ethereum.publicnode.com',
        '',
        'https://etherscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo Optimism = ChainInfo(
        10,
        'Optimism',
        'evm',
        'https://static.particle.network/token-list/optimism/native.png',
        'Optimism Mainnet',
        'Mainnet',
        'https://optimism.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://mainnet.optimism.io',
        '',
        'https://optimistic.etherscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo ThunderCoreTestnet = ChainInfo(
        18,
        'ThunderCore',
        'evm',
        'https://static.particle.network/token-list/thundercore/native.png',
        'ThunderCore Testnet',
        'Testnet',
        'https://thundercore.com',
        ChainInfoNativeCurrency('ThunderCore Token', 'TT', 18),
        'https://testnet-rpc.thundercore.com',
        'https://faucet-testnet.thundercore.com',
        'https://explorer-testnet.thundercore.com',
        [],
      );
    

    static ChainInfo Elastos = ChainInfo(
        20,
        'Elastos',
        'evm',
        'https://static.particle.network/token-list/elastos/native.png',
        'Elastos Mainnet',
        'Mainnet',
        'https://elastos.org',
        ChainInfoNativeCurrency('ELA', 'ELA', 18),
        'https://api.elastos.io/esc',
        '',
        'https://esc.elastos.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Cronos = ChainInfo(
        25,
        'Cronos',
        'evm',
        'https://static.particle.network/token-list/cronos/native.png',
        'Cronos Mainnet',
        'Mainnet',
        'https://cronos.org',
        ChainInfoNativeCurrency('Cronos', 'CRO', 18),
        'https://evm.cronos.org',
        '',
        'https://cronoscan.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo BNBChain = ChainInfo(
        56,
        'BSC',
        'evm',
        'https://static.particle.network/token-list/bsc/native.png',
        'BNB Chain',
        'Mainnet',
        'https://www.bnbchain.org/en',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://bsc-dataseed1.binance.org',
        '',
        'https://bscscan.com',
        [ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo OKTCTestnet = ChainInfo(
        65,
        'OKC',
        'evm',
        'https://static.particle.network/token-list/okc/native.png',
        'OKTC Testnet',
        'Testnet',
        'https://www.okex.com/okexchain',
        ChainInfoNativeCurrency('OKT', 'OKT', 18),
        'https://exchaintestrpc.okex.org',
        'https://docs.oxdex.com/v/en/help/gitter',
        'https://www.oklink.com/okc-test',
        [],
      );
    

    static ChainInfo OKTC = ChainInfo(
        66,
        'OKC',
        'evm',
        'https://static.particle.network/token-list/okc/native.png',
        'OKTC Mainnet',
        'Mainnet',
        'https://www.okex.com/okc',
        ChainInfoNativeCurrency('OKT', 'OKT', 18),
        'https://exchainrpc.okex.org',
        '',
        'https://www.oklink.com/okc',
        [ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo ConfluxeSpaceTestnet = ChainInfo(
        71,
        'ConfluxESpace',
        'evm',
        'https://static.particle.network/token-list/confluxespace/native.png',
        'Conflux eSpace Testnet',
        'Testnet',
        'https://confluxnetwork.org',
        ChainInfoNativeCurrency('CFX', 'CFX', 18),
        'https://evmtestnet.confluxrpc.com',
        'https://efaucet.confluxnetwork.org',
        'https://evmtestnet.confluxscan.net',
        [],
      );
    

    static ChainInfo Viction = ChainInfo(
        88,
        'Viction',
        'evm',
        'https://static.particle.network/token-list/viction/native.png',
        'Viction Mainnet',
        'Mainnet',
        'https://tomochain.com',
        ChainInfoNativeCurrency('Viction', 'VIC', 18),
        'https://rpc.viction.xyz',
        '',
        'https://vicscan.xyz',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo VictionTestnet = ChainInfo(
        89,
        'Viction',
        'evm',
        'https://static.particle.network/token-list/viction/native.png',
        'Viction Testnet',
        'Testnet',
        'https://tomochain.com',
        ChainInfoNativeCurrency('Viction', 'VIC', 18),
        'https://rpc-testnet.viction.xyz',
        '',
        'https://testnet.vicscan.xyz',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BNBChainTestnet = ChainInfo(
        97,
        'BSC',
        'evm',
        'https://static.particle.network/token-list/bsc/native.png',
        'BNB Chain Testnet',
        'Testnet',
        'https://www.bnbchain.org/en',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://data-seed-prebsc-1-s1.binance.org:8545',
        'https://testnet.bnbchain.org/faucet-smart',
        'https://testnet.bscscan.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Gnosis = ChainInfo(
        100,
        'Gnosis',
        'evm',
        'https://static.particle.network/token-list/gnosis/native.png',
        'Gnosis Mainnet',
        'Mainnet',
        'https://docs.gnosischain.com',
        ChainInfoNativeCurrency('Gnosis', 'XDAI', 18),
        'https://rpc.ankr.com/gnosis',
        '',
        'https://gnosisscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo Solana = ChainInfo(
        101,
        'Solana',
        'solana',
        'https://static.particle.network/token-list/solana/native.png',
        'Solana Mainnet',
        'Mainnet',
        'https://solana.com',
        ChainInfoNativeCurrency('SOL', 'SOL', 9),
        'https://api.mainnet-beta.solana.com',
        '',
        'https://solscan.io',
        [ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo SolanaTestnet = ChainInfo(
        102,
        'Solana',
        'solana',
        'https://static.particle.network/token-list/solana/native.png',
        'Solana Testnet',
        'Testnet',
        'https://solana.com',
        ChainInfoNativeCurrency('SOL', 'SOL', 9),
        'https://api.testnet.solana.com',
        'https://solfaucet.com',
        'https://solscan.io',
        [],
      );
    

    static ChainInfo SolanaDevnet = ChainInfo(
        103,
        'Solana',
        'solana',
        'https://static.particle.network/token-list/solana/native.png',
        'Solana Devnet',
        'Devnet',
        'https://solana.com',
        ChainInfoNativeCurrency('SOL', 'SOL', 9),
        'https://api.devnet.solana.com',
        'https://solfaucet.com',
        'https://solscan.io',
        [],
      );
    

    static ChainInfo ThunderCore = ChainInfo(
        108,
        'ThunderCore',
        'evm',
        'https://static.particle.network/token-list/thundercore/native.png',
        'ThunderCore Mainnet',
        'Mainnet',
        'https://thundercore.com',
        ChainInfoNativeCurrency('ThunderCore Token', 'TT', 18),
        'https://mainnet-rpc.thundercore.com',
        '',
        'https://viewblock.io/thundercore',
        [],
      );
    

    static ChainInfo BOBTestnet = ChainInfo(
        111,
        'BOB',
        'evm',
        'https://static.particle.network/token-list/bob/native.png',
        'BOB Testnet',
        'Testnet',
        'https://www.gobob.xyz',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://testnet.rpc.gobob.xyz',
        '',
        'https://testnet-explorer.gobob.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Fuse = ChainInfo(
        122,
        'fuse',
        'evm',
        'https://static.particle.network/token-list/fuse/native.png',
        'Fuse Mainnet',
        'Mainnet',
        'https://www.fuse.io',
        ChainInfoNativeCurrency('FUSE', 'FUSE', 18),
        'https://rpc.fuse.io',
        '',
        'https://explorer.fuse.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo FuseTestnet = ChainInfo(
        123,
        'fuse',
        'evm',
        'https://static.particle.network/token-list/fuse/native.png',
        'Fuse Testnet',
        'Testnet',
        'https://www.fuse.io',
        ChainInfoNativeCurrency('FUSE', 'FUSE', 18),
        'https://rpc.fusespark.io',
        '',
        'https://explorer.fusespark.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Polygon = ChainInfo(
        137,
        'Polygon',
        'evm',
        'https://static.particle.network/token-list/polygon/native.png',
        'Polygon Mainnet',
        'Mainnet',
        'https://polygon.technology',
        ChainInfoNativeCurrency('MATIC', 'MATIC', 18),
        'https://polygon-rpc.com',
        '',
        'https://polygonscan.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo Manta = ChainInfo(
        169,
        'Manta',
        'evm',
        'https://static.particle.network/token-list/manta/native.png',
        'Manta Mainnet',
        'Mainnet',
        'https://manta.network',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://pacific-rpc.manta.network/http',
        '',
        'https://pacific-explorer.manta.network',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo XLayerTestnet = ChainInfo(
        195,
        'OKBC',
        'evm',
        'https://static.particle.network/token-list/okc/native.png',
        'X Layer Testnet',
        'Testnet',
        'https://www.okx.com',
        ChainInfoNativeCurrency('OKB', 'OKB', 18),
        'https://testrpc.xlayer.tech',
        '',
        'https://www.okx.com/explorer/xlayer-test',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo XLayer = ChainInfo(
        196,
        'OKBC',
        'evm',
        'https://static.particle.network/token-list/okc/native.png',
        'X Layer Mainnet',
        'Mainnet',
        'https://www.okx.com',
        ChainInfoNativeCurrency('OKB', 'OKB', 18),
        'https://rpc.xlayer.tech',
        '',
        'https://www.okx.com/zh-hans/explorer/xlayer',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo opBNB = ChainInfo(
        204,
        'opBNB',
        'evm',
        'https://static.particle.network/token-list/opbnb/native.png',
        'opBNB Mainnet',
        'Mainnet',
        'https://opbnb.bnbchain.org',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://opbnb-mainnet-rpc.bnbchain.org',
        '',
        'https://mainnet.opbnbscan.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo MAPProtocolTestnet = ChainInfo(
        212,
        'MAPProtocol',
        'evm',
        'https://static.particle.network/token-list/mapprotocol/native.png',
        'MAP Protocol Testnet',
        'Testnet',
        'https://maplabs.io',
        ChainInfoNativeCurrency('MAPO', 'MAPO', 18),
        'https://testnet-rpc.maplabs.io',
        'https://faucet.mapprotocol.io',
        'https://testnet.maposcan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BSquared = ChainInfo(
        223,
        'BSquared',
        'evm',
        'https://static.particle.network/token-list/bsquared/native.png',
        'B² Network Mainnet',
        'Mainnet',
        'https://www.bsquared.network',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://rpc.bsquared.network',
        '',
        'https://explorer.bsquared.network',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Fantom = ChainInfo(
        250,
        'Fantom',
        'evm',
        'https://static.particle.network/token-list/fantom/native.png',
        'Fantom Mainnet',
        'Mainnet',
        'https://fantom.foundation',
        ChainInfoNativeCurrency('FTM', 'FTM', 18),
        'https://rpc.ftm.tools',
        '',
        'https://ftmscan.com',
        [ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo zkSyncEraSepolia = ChainInfo(
        300,
        'zkSync',
        'evm',
        'https://static.particle.network/token-list/zksync/native.png',
        'zkSync Era Sepolia',
        'Sepolia',
        'https://era.zksync.io',
        ChainInfoNativeCurrency('zkSync', 'ETH', 18),
        'https://sepolia.era.zksync.dev',
        'https://portal.zksync.io/faucet',
        'https://sepolia.explorer.zksync.io',
        [ChainInfoFeature('EIP1559')],
      );
    

    static ChainInfo KCC = ChainInfo(
        321,
        'KCC',
        'evm',
        'https://static.particle.network/token-list/kcc/native.png',
        'KCC Mainnet',
        'Mainnet',
        'https://kcc.io',
        ChainInfoNativeCurrency('KCS', 'KCS', 18),
        'https://rpc-mainnet.kcc.network',
        '',
        'https://explorer.kcc.io/en',
        [],
      );
    

    static ChainInfo KCCTestnet = ChainInfo(
        322,
        'KCC',
        'evm',
        'https://static.particle.network/token-list/kcc/native.png',
        'KCC Testnet',
        'Testnet',
        'https://scan-testnet.kcc.network',
        ChainInfoNativeCurrency('KCS', 'KCS', 18),
        'https://rpc-testnet.kcc.network',
        'https://faucet-testnet.kcc.network',
        'https://scan-testnet.kcc.network',
        [],
      );
    

    static ChainInfo zkSyncEra = ChainInfo(
        324,
        'zkSync',
        'evm',
        'https://static.particle.network/token-list/zksync/native.png',
        'zkSync Era',
        'Mainnet',
        'https://zksync.io',
        ChainInfoNativeCurrency('zkSync', 'ETH', 18),
        'https://zksync2-mainnet.zksync.io',
        '',
        'https://explorer.zksync.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo CronosTestnet = ChainInfo(
        338,
        'Cronos',
        'evm',
        'https://static.particle.network/token-list/cronos/native.png',
        'Cronos Testnet',
        'Testnet',
        'https://cronos.org',
        ChainInfoNativeCurrency('Cronos', 'CRO', 18),
        'https://evm-t3.cronos.org',
        'https://cronos.org/faucet',
        'https://testnet.cronoscan.com',
        [ChainInfoFeature('EIP1559')],
      );
    

    static ChainInfo ModeTestnet = ChainInfo(
        919,
        'Mode',
        'evm',
        'https://static.particle.network/token-list/mode/native.png',
        'Mode Testnet',
        'Testnet',
        'https://www.mode.network',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://sepolia.mode.network',
        '',
        'https://sepolia.explorer.mode.network',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo fiveire = ChainInfo(
        995,
        'fiveire',
        'evm',
        'https://static.particle.network/token-list/fiveire/native.png',
        '5ire Mainnet',
        'Mainnet',
        'https://www.5ire.org',
        ChainInfoNativeCurrency('5IRE', '5IRE', 18),
        'https://rpc.5ire.network',
        '',
        'https://5irescan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo fiveireTestnet = ChainInfo(
        997,
        'fiveire',
        'evm',
        'https://static.particle.network/token-list/fiveire/native.png',
        '5ire Testnet',
        'Testnet',
        'https://www.5ire.org',
        ChainInfoNativeCurrency('5IRE', '5IRE', 18),
        'https://rpc.qa.5ire.network',
        '',
        'https://scan.qa.5ire.network',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo KlaytnTestnet = ChainInfo(
        1001,
        'Klaytn',
        'evm',
        'https://static.particle.network/token-list/klaytn/native.png',
        'Klaytn Testnet',
        'Testnet',
        'https://www.klaytn.com',
        ChainInfoNativeCurrency('Klaytn', 'KLAY', 18),
        'https://api.baobab.klaytn.net:8651',
        'https://baobab.wallet.klaytn.foundation/faucet',
        'https://baobab.scope.klaytn.com',
        [],
      );
    

    static ChainInfo ConfluxeSpace = ChainInfo(
        1030,
        'ConfluxESpace',
        'evm',
        'https://static.particle.network/token-list/confluxespace/native.png',
        'Conflux eSpace',
        'Mainnet',
        'https://confluxnetwork.org',
        ChainInfoNativeCurrency('CFX', 'CFX', 18),
        'https://evm.confluxrpc.com',
        '',
        'https://evm.confluxscan.net',
        [],
      );
    

    static ChainInfo Metis = ChainInfo(
        1088,
        'Metis',
        'evm',
        'https://static.particle.network/token-list/metis/native.png',
        'Metis Mainnet',
        'Mainnet',
        'https://www.metis.io',
        ChainInfoNativeCurrency('Metis', 'METIS', 18),
        'https://andromeda.metis.io/?owner=1088',
        '',
        'https://andromeda-explorer.metis.io',
        [],
      );
    

    static ChainInfo PolygonzkEVM = ChainInfo(
        1101,
        'PolygonZkEVM',
        'evm',
        'https://static.particle.network/token-list/polygonzkevm/native.png',
        'Polygon zkEVM',
        'Mainnet',
        'https://polygon.technology/polygon-zkevm',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://zkevm-rpc.com',
        '',
        'https://zkevm.polygonscan.com',
        [ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo CoreTestnet = ChainInfo(
        1115,
        'Core',
        'evm',
        'https://static.particle.network/token-list/core/native.png',
        'Core Testnet',
        'Testnet',
        'https://coredao.org',
        ChainInfoNativeCurrency('CORE', 'CORE', 18),
        'https://rpc.test.btcs.network',
        '',
        'https://scan.test.btcs.network',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Core = ChainInfo(
        1116,
        'Core',
        'evm',
        'https://static.particle.network/token-list/core/native.png',
        'Core Mainnet',
        'Mainnet',
        'https://coredao.org',
        ChainInfoNativeCurrency('CORE', 'CORE', 18),
        'https://rpc.coredao.org',
        '',
        'https://scan.coredao.org',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BSquaredTestnet = ChainInfo(
        1123,
        'BSquared',
        'evm',
        'https://static.particle.network/token-list/bsquared/native.png',
        'B² Network Testnet',
        'Testnet',
        'https://www.bsquared.network',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://b2-testnet.alt.technology',
        '',
        'https://testnet-explorer.bsquared.network',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo HybridTestnet = ChainInfo(
        1225,
        'Hybrid',
        'evm',
        'https://static.particle.network/token-list/hybrid/native.png',
        'Hybrid Testnet',
        'Testnet',
        'https://buildonhybrid.com',
        ChainInfoNativeCurrency('HYB', 'HYB', 18),
        'https://hybrid-testnet.rpc.caldera.xyz/http',
        '',
        'https://explorer.buildonhybrid.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Moonbeam = ChainInfo(
        1284,
        'Moonbeam',
        'evm',
        'https://static.particle.network/token-list/moonbeam/native.png',
        'Moonbeam Mainnet',
        'Mainnet',
        'https://moonbeam.network/networks/moonbeam',
        ChainInfoNativeCurrency('GLMR', 'GLMR', 18),
        'https://rpc.api.moonbeam.network',
        '',
        'https://moonbeam.moonscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo Moonriver = ChainInfo(
        1285,
        'Moonriver',
        'evm',
        'https://static.particle.network/token-list/moonriver/native.png',
        'Moonriver Mainnet',
        'Mainnet',
        'https://moonbeam.network/networks/moonriver',
        ChainInfoNativeCurrency('MOVR', 'MOVR', 18),
        'https://rpc.api.moonriver.moonbeam.network',
        '',
        'https://moonriver.moonscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo MoonbeamTestnet = ChainInfo(
        1287,
        'Moonbeam',
        'evm',
        'https://static.particle.network/token-list/moonbeam/native.png',
        'Moonbeam Testnet',
        'Testnet',
        'https://docs.moonbeam.network/networks/testnet',
        ChainInfoNativeCurrency('Dev', 'DEV', 18),
        'https://rpc.api.moonbase.moonbeam.network',
        'https://apps.moonbeam.network/moonbase-alpha/faucet',
        'https://moonbase.moonscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo SeiTestnet = ChainInfo(
        1328,
        'Sei',
        'evm',
        'https://static.particle.network/token-list/sei/native.png',
        'Sei Testnet',
        'Testnet',
        'https://www.sei.io',
        ChainInfoNativeCurrency('SEI', 'SEI', 18),
        'https://evm-rpc-testnet.sei-apis.com',
        '',
        'https://testnet.seistream.app',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Sei = ChainInfo(
        1329,
        'Sei',
        'evm',
        'https://static.particle.network/token-list/sei/native.png',
        'Sei Mainnet',
        'Mainnet',
        'https://www.sei.io',
        ChainInfoNativeCurrency('SEI', 'SEI', 18),
        'https://evm-rpc.sei-apis.com',
        '',
        'https://seistream.app',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BEVMCanary = ChainInfo(
        1501,
        'BEVM',
        'evm',
        'https://static.particle.network/token-list/bevm/native.png',
        'BEVM Canary Mainnet',
        'Mainnet',
        'https://www.bevm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://rpc-canary-1.bevm.io',
        '',
        'https://scan-canary.bevm.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BEVMCanaryTestnet = ChainInfo(
        1502,
        'BEVM',
        'evm',
        'https://static.particle.network/token-list/bevm/native.png',
        'BEVM Canary Testnet',
        'Testnet',
        'https://www.bevm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://canary-testnet.bevm.io',
        '',
        'https://scan-canary-testnet.bevm.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo StoryNetworkTestnet = ChainInfo(
        1513,
        'StoryNetwork',
        'evm',
        'https://static.particle.network/token-list/storynetwork/native.png',
        'Story Network Testnet',
        'Testnet',
        'https://explorer.testnet.storyprotocol.net',
        ChainInfoNativeCurrency('IP', 'IP', 18),
        'https://testnet.storyrpc.io',
        '',
        'https://testnet.storyscan.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Gravity = ChainInfo(
        1625,
        'Gravity',
        'evm',
        'https://static.particle.network/token-list/gravity/native.png',
        'Gravity Mainnet',
        'Mainnet',
        'https://gravity.xyz',
        ChainInfoNativeCurrency('G', 'G', 18),
        'https://rpc.gravity.xyz',
        '',
        'https://gscan.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ComboTestnet = ChainInfo(
        1715,
        'Combo',
        'evm',
        'https://static.particle.network/token-list/combo/native.png',
        'Combo Testnet',
        'Testnet',
        'https://docs.combonetwork.io',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://test-rpc.combonetwork.io',
        '',
        'https://combotrace-testnet.nodereal.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo SoneiumMinatoTestnet = ChainInfo(
        1946,
        'Soneium',
        'evm',
        'https://static.particle.network/token-list/soneium/native.png',
        'Soneium Minato Testnet',
        'Testnet',
        'https://soneium.org',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.minato.soneium.org',
        '',
        'https://explorer-testnet.soneium.org',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo KavaTestnet = ChainInfo(
        2221,
        'Kava',
        'evm',
        'https://static.particle.network/token-list/kava/native.png',
        'Kava Testnet',
        'Testnet',
        'https://www.kava.io',
        ChainInfoNativeCurrency('KAVA', 'KAVA', 18),
        'https://evm.testnet.kava.io',
        'https://faucet.kava.io',
        'https://testnet.kavascan.com',
        [],
      );
    

    static ChainInfo Kava = ChainInfo(
        2222,
        'Kava',
        'evm',
        'https://static.particle.network/token-list/kava/native.png',
        'Kava Mainnet',
        'Mainnet',
        'https://www.kava.io',
        ChainInfoNativeCurrency('KAVA', 'KAVA', 18),
        'https://evm.kava.io',
        '',
        'https://kavascan.com',
        [],
      );
    

    static ChainInfo PeaqKrest = ChainInfo(
        2241,
        'peaq',
        'evm',
        'https://static.particle.network/token-list/peaq/native.png',
        'Peaq Krest Mainnet',
        'Mainnet',
        'https://www.peaq.network',
        ChainInfoNativeCurrency('KRST', 'KRST', 18),
        'https://erpc-krest.peaq.network',
        '',
        'https://krest.subscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo PolygonzkEVMCardona = ChainInfo(
        2442,
        'PolygonZkEVM',
        'evm',
        'https://static.particle.network/token-list/polygonzkevm/native.png',
        'Polygon zkEVM Cardona',
        'Cardona',
        'https://polygon.technology',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.cardona.zkevm-rpc.com',
        '',
        'https://cardona-zkevm.polygonscan.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo AILayerTestnet = ChainInfo(
        2648,
        'ainn',
        'evm',
        'https://static.particle.network/token-list/ainn/native.png',
        'AILayer Testnet',
        'Testnet',
        'https://anvm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://rpc.anvm.io',
        '',
        'https://explorer.anvm.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo AILayer = ChainInfo(
        2649,
        'ainn',
        'evm',
        'https://static.particle.network/token-list/ainn/native.png',
        'AILayer Mainnet',
        'Mainnet',
        'https://anvm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://mainnet-rpc.ailayer.xyz',
        '',
        'https://mainnet-explorer.ailayer.xyz',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo GMNetwork = ChainInfo(
        2777,
        'GMNetwork',
        'evm',
        'https://static.particle.network/token-list/gmnetwork/native.png',
        'GM Network Mainnet',
        'Mainnet',
        'https://gmnetwork.ai',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://rpc.gmnetwork.ai',
        '',
        'https://scan.gmnetwork.ai',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo SatoshiVMAlpha = ChainInfo(
        3109,
        'satoshivm',
        'evm',
        'https://static.particle.network/token-list/satoshivm/native.png',
        'SatoshiVM Alpha',
        'Mainnet',
        'https://www.satoshivm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://alpha-rpc-node-http.svmscan.io',
        '',
        'https://svmscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo SatoshiVMTestnet = ChainInfo(
        3110,
        'SatoshiVM',
        'evm',
        'https://static.particle.network/token-list/satoshivm/native.png',
        'SatoshiVM Testnet',
        'Testnet',
        'https://www.satoshivm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://test-rpc-node-http.svmscan.io',
        '',
        'https://testnet.svmscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Peaq = ChainInfo(
        3338,
        'Peaq Network',
        'evm',
        'https://static.particle.network/token-list/peaq/native.png',
        'Peaq Mainnet',
        'Mainnet',
        'https://peaq.subscan.io',
        ChainInfoNativeCurrency('PEAQ', 'PEAQ', 18),
        ' https://evm.peaq.network',
        '',
        'https://peaq.subscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BotanixTestnet = ChainInfo(
        3636,
        'Botanix',
        'evm',
        'https://static.particle.network/token-list/botanix/native.png',
        'Botanix Testnet',
        'Testnet',
        'https://botanixlabs.xyz',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://node.botanixlabs.dev',
        '',
        'https://blockscout.botanixlabs.dev',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo AstarzkEVMMainet = ChainInfo(
        3776,
        'AstarZkEVM',
        'evm',
        'https://static.particle.network/token-list/astarzkevm/native.png',
        'Astar zkEVM Mainet',
        'Mainnet',
        'https://astar.network',
        ChainInfoNativeCurrency('Sepolia Ether', 'ETH', 18),
        'https://rpc.startale.com/astar-zkevm',
        '',
        'https://astar-zkevm.explorer.startale.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo FantomTestnet = ChainInfo(
        4002,
        'Fantom',
        'evm',
        'https://static.particle.network/token-list/fantom/native.png',
        'Fantom Testnet',
        'Testnet',
        'https://docs.fantom.foundation/quick-start/short-guide#fantom-testnet',
        ChainInfoNativeCurrency('FTM', 'FTM', 18),
        'https://rpc.testnet.fantom.network',
        'https://faucet.fantom.network',
        'https://testnet.ftmscan.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Merlin = ChainInfo(
        4200,
        'Merlin',
        'evm',
        'https://static.particle.network/token-list/merlin/native.png',
        'Merlin Mainnet',
        'Mainnet',
        'https://merlinprotocol.org',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://rpc.merlinchain.io',
        '',
        'https://scan.merlinchain.io',
        [ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo IoTeX = ChainInfo(
        4689,
        'iotex',
        'evm',
        'https://static.particle.network/token-list/iotex/native.png',
        'IoTeX Mainnet',
        'Mainnet',
        'https://iotex.io',
        ChainInfoNativeCurrency('IOTX', 'IOTX', 18),
        'https://babel-api.mainnet.iotex.io',
        '',
        'https://iotexscan.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo IoTeXTestnet = ChainInfo(
        4690,
        'iotex',
        'evm',
        'https://static.particle.network/token-list/iotex/native.png',
        'IoTeX Testnet',
        'Testnet',
        'https://iotex.io',
        ChainInfoNativeCurrency('IOTX', 'IOTX', 18),
        'https://babel-api.testnet.iotex.io',
        '',
        'https://testnet.iotexscan.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Mantle = ChainInfo(
        5000,
        'Mantle',
        'evm',
        'https://static.particle.network/token-list/mantle/native.png',
        'Mantle Mainnet',
        'Mainnet',
        'https://mantle.xyz',
        ChainInfoNativeCurrency('MNT', 'MNT', 18),
        'https://rpc.mantle.xyz',
        '',
        'https://explorer.mantle.xyz',
        [ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo MantleSepoliaTestnet = ChainInfo(
        5003,
        'Mantle',
        'evm',
        'https://static.particle.network/token-list/mantle/native.png',
        'Mantle Sepolia Testnet',
        'Testnet',
        'https://mantle.xyz',
        ChainInfoNativeCurrency('MNT', 'MNT', 18),
        'https://rpc.sepolia.mantle.xyz',
        'https://faucet.sepolia.mantle.xyz',
        'https://explorer.sepolia.mantle.xyz',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Duckchain = ChainInfo(
        5545,
        'Duckchain',
        'evm',
        'https://static.particle.network/token-list/duckchain/native.png',
        'Duckchain Mainnet',
        'Mainnet',
        'https://duckchain.io',
        ChainInfoNativeCurrency('TON', 'TON', 18),
        'https://rpc.duckchain.io',
        '',
        'https://scan.duckchain.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo opBNBTestnet = ChainInfo(
        5611,
        'opBNB',
        'evm',
        'https://static.particle.network/token-list/opbnb/native.png',
        'opBNB Testnet',
        'Testnet',
        'https://opbnb.bnbchain.org',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://opbnb-testnet-rpc.bnbchain.org',
        '',
        'https://opbnb-testnet.bscscan.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo AuraTestnet = ChainInfo(
        6321,
        'aura',
        'evm',
        'https://static.particle.network/token-list/aura/native.png',
        'Aura Testnet',
        'Testnet',
        'https://aura.network',
        ChainInfoNativeCurrency('AURA', 'AURA', 18),
        'https://jsonrpc.euphoria.aura.network',
        '',
        'https://euphoria.aurascan.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Aura = ChainInfo(
        6322,
        'aura',
        'evm',
        'https://static.particle.network/token-list/aura/native.png',
        'Aura Mainnet',
        'Mainnet',
        'https://aura.network',
        ChainInfoNativeCurrency('AURA', 'AURA', 18),
        'https://jsonrpc.aura.network',
        '',
        'https://aurascan.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ZetaChain = ChainInfo(
        7000,
        'ZetaChain',
        'evm',
        'https://static.particle.network/token-list/zetachain/native.png',
        'ZetaChain Mainnet',
        'Mainnet',
        'https://zetachain.com',
        ChainInfoNativeCurrency('ZETA', 'ZETA', 18),
        'https://zetachain-evm.blockpi.network/v1/rpc/public',
        '',
        'https://zetachain.blockscout.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ZetaChainTestnet = ChainInfo(
        7001,
        'ZetaChain',
        'evm',
        'https://static.particle.network/token-list/zetachain/native.png',
        'ZetaChain Testnet',
        'Testnet',
        'https://zetachain.com',
        ChainInfoNativeCurrency('ZETA', 'ZETA', 18),
        'https://zetachain-athens-evm.blockpi.network/v1/rpc/public',
        'https://labs.zetachain.com/get-zeta',
        'https://zetachain-athens-3.blockscout.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Cyber = ChainInfo(
        7560,
        'Cyber',
        'evm',
        'https://static.particle.network/token-list/cyber/native.png',
        'Cyber Mainnet',
        'Mainnet',
        'https://cyber-explorer.alt.technology',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://cyber.alt.technology',
        '',
        'https://cyberscan.co',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Klaytn = ChainInfo(
        8217,
        'Klaytn',
        'evm',
        'https://static.particle.network/token-list/klaytn/native.png',
        'Klaytn Mainnet',
        'Mainnet',
        'https://www.klaytn.com',
        ChainInfoNativeCurrency('Klaytn', 'KLAY', 18),
        'https://cypress.fandom.finance/archive',
        '',
        'https://scope.klaytn.com',
        [ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo Lorenzo = ChainInfo(
        8329,
        'lorenzo',
        'evm',
        'https://static.particle.network/token-list/lorenzo/native.png',
        'Lorenzo Mainnet',
        'Mainnet',
        'https://lorenzo-protocol.xyz',
        ChainInfoNativeCurrency('stBTC', 'stBTC', 18),
        'https://rpc.lorenzo-protocol.xyz',
        '',
        'https://scan.lorenzo-protocol.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Base = ChainInfo(
        8453,
        'Base',
        'evm',
        'https://static.particle.network/token-list/base/native.png',
        'Base Mainnet',
        'Mainnet',
        'https://base.org',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://developer-access-mainnet.base.org',
        '',
        'https://basescan.org',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo Combo = ChainInfo(
        9980,
        'Combo',
        'evm',
        'https://static.particle.network/token-list/combo/native.png',
        'Combo Mainnet',
        'Mainnet',
        'https://docs.combonetwork.io',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://rpc.combonetwork.io',
        '',
        'https://combotrace.nodereal.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo PeaqAgungTestnet = ChainInfo(
        9990,
        'peaq',
        'evm',
        'https://static.particle.network/token-list/peaq/native.png',
        'Peaq Agung Testnet',
        'Testnet',
        'https://www.peaq.network',
        ChainInfoNativeCurrency('AGUNG', 'AGUNG', 18),
        'https://rpcpc1-qa.agung.peaq.network',
        '',
        'https://agung-testnet.subscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo GnosisTestnet = ChainInfo(
        10200,
        'Gnosis',
        'evm',
        'https://static.particle.network/token-list/gnosis/native.png',
        'Gnosis Testnet',
        'Testnet',
        'https://docs.gnosischain.com',
        ChainInfoNativeCurrency('Gnosis', 'XDAI', 18),
        'https://optimism.gnosischain.com',
        'https://gnosisfaucet.com',
        'https://blockscout.com/gnosis/chiado',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BEVM = ChainInfo(
        11501,
        'BEVM',
        'evm',
        'https://static.particle.network/token-list/bevm/native.png',
        'BEVM Mainnet',
        'Mainnet',
        'https://www.bevm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://rpc-mainnet-1.bevm.io',
        '',
        'https://scan-mainnet.bevm.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BEVMTestnet = ChainInfo(
        11503,
        'BEVM',
        'evm',
        'https://static.particle.network/token-list/bevm/native.png',
        'BEVM Testnet',
        'Testnet',
        'https://www.bevm.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://testnet.bevm.io',
        '',
        'https://scan-testnet.bevm.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ReadONTestnet = ChainInfo(
        12015,
        'ReadON',
        'evm',
        'https://static.particle.network/token-list/readon/native.png',
        'ReadON Testnet',
        'Testnet',
        'https://opside.network',
        ChainInfoNativeCurrency('READ', 'READ', 18),
        'https://pre-alpha-zkrollup-rpc.opside.network/readon-content-test-chain',
        '',
        'https://readon-content-test-chain.zkevm.opside.info',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ImmutablezkEVMTestnet = ChainInfo(
        13473,
        'Immutable',
        'evm',
        'https://static.particle.network/token-list/immutable/native.png',
        'Immutable zkEVM Testnet',
        'Testnet',
        'https://www.immutable.com',
        ChainInfoNativeCurrency('IMX', 'IMX', 18),
        'https://rpc.testnet.immutable.com',
        '',
        'https://explorer.testnet.immutable.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo GravityTestnet = ChainInfo(
        13505,
        'Gravity',
        'evm',
        'https://static.particle.network/token-list/gravity/native.png',
        'Gravity Testnet',
        'Testnet',
        'https://gravity.xyz',
        ChainInfoNativeCurrency('G', 'G', 18),
        'https://rpc-sepolia.gravity.xyz',
        '',
        ' https://explorer-sepolia.gravity.xyz',
        [ChainInfoFeature('EIP1559')],
      );
    

    static ChainInfo EOSEVMTestnet = ChainInfo(
        15557,
        'Eosevm',
        'evm',
        'https://static.particle.network/token-list/eosevm/native.png',
        'EOS EVM Testnet',
        'Testnet',
        'https://eosnetwork.com',
        ChainInfoNativeCurrency('EOS', 'EOS', 18),
        'https://api.testnet.evm.eosnetwork.com',
        'https://bridge.testnet.evm.eosnetwork.com',
        'https://explorer.testnet.evm.eosnetwork.com',
        [],
      );
    

    static ChainInfo EthereumHolesky = ChainInfo(
        17000,
        'Ethereum',
        'evm',
        'https://static.particle.network/token-list/ethereum/native.png',
        'Ethereum Holesky',
        'Holesky',
        'https://holesky.ethpandaops.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://ethereum-holesky.blockpi.network/v1/rpc/public',
        'https://faucet.quicknode.com/drip',
        'https://holesky.etherscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo EOSEVM = ChainInfo(
        17777,
        'Eosevm',
        'evm',
        'https://static.particle.network/token-list/eosevm/native.png',
        'EOS EVM',
        'Mainnet',
        'https://eosnetwork.com',
        ChainInfoNativeCurrency('EOS', 'EOS', 18),
        'https://api.evm.eosnetwork.com',
        '',
        'https://explorer.evm.eosnetwork.com',
        [],
      );
    

    static ChainInfo MAPProtocol = ChainInfo(
        22776,
        'MAPProtocol',
        'evm',
        'https://static.particle.network/token-list/mapprotocol/native.png',
        'MAP Protocol',
        'Mainnet',
        'https://maplabs.io',
        ChainInfoNativeCurrency('MAPO', 'MAPO', 18),
        'https://rpc.maplabs.io',
        '',
        'https://mapscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Zeroone = ChainInfo(
        27827,
        'Zeroone',
        'evm',
        'https://static.particle.network/token-list/zeroone/native.png',
        'Zeroone Mainnet',
        'Mainnet',
        'https://zeroone.art',
        ChainInfoNativeCurrency('ZERO', 'ZERO', 18),
        'https://subnets.avax.network/zeroonemai/mainnet/rpc',
        '',
        'https://subnets.avax.network/zeroonemai',
        [ChainInfoFeature('EIP1559')],
      );
    

    static ChainInfo MovementDevnet = ChainInfo(
        30732,
        'Movement',
        'evm',
        'https://static.particle.network/token-list/movement/native.png',
        'Movement Devnet',
        'Devnet',
        'https://movementlabs.xyz',
        ChainInfoNativeCurrency('MOVE', 'MOVE', 18),
        'https://mevm.devnet.imola.movementnetwork.xyz',
        '',
        'https://explorer.devnet.imola.movementnetwork.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Mode = ChainInfo(
        34443,
        'Mode',
        'evm',
        'https://static.particle.network/token-list/mode/native.png',
        'Mode Mainnet',
        'Mainnet',
        'https://www.mode.network',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://mainnet.mode.network',
        '',
        'https://explorer.mode.network',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ArbitrumOne = ChainInfo(
        42161,
        'Arbitrum',
        'evm',
        'https://static.particle.network/token-list/arbitrum/native.png',
        'Arbitrum One',
        'Mainnet',
        'https://arbitrum.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://arb1.arbitrum.io/rpc',
        '',
        'https://arbiscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo ArbitrumNova = ChainInfo(
        42170,
        'Arbitrum',
        'evm',
        'https://static.particle.network/token-list/arbitrum/native.png',
        'Arbitrum Nova',
        'Mainnet',
        'https://arbitrum.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://nova.arbitrum.io/rpc',
        '',
        'https://nova.arbiscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Celo = ChainInfo(
        42220,
        'Celo',
        'evm',
        'https://static.particle.network/token-list/celo/native.png',
        'Celo Mainnet',
        'Mainnet',
        'https://docs.celo.org',
        ChainInfoNativeCurrency('Celo', 'CELO', 18),
        'https://rpc.ankr.com/celo',
        '',
        'https://explorer.celo.org/mainnet',
        [ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo OasisEmeraldTestnet = ChainInfo(
        42261,
        'OasisEmerald',
        'evm',
        'https://static.particle.network/token-list/oasisemerald/native.png',
        'OasisEmerald Testnet',
        'Testnet',
        'https://docs.oasis.io/dapp/emerald',
        ChainInfoNativeCurrency('OasisEmerald', 'ROSE', 18),
        'https://testnet.emerald.oasis.dev',
        'https://faucet.testnet.oasis.dev',
        'https://testnet.explorer.emerald.oasis.dev',
        [],
      );
    

    static ChainInfo OasisEmerald = ChainInfo(
        42262,
        'OasisEmerald',
        'evm',
        'https://static.particle.network/token-list/oasisemerald/native.png',
        'OasisEmerald Mainnet',
        'Mainnet',
        'https://docs.oasis.io/dapp/emerald',
        ChainInfoNativeCurrency('OasisEmerald', 'ROSE', 18),
        'https://emerald.oasis.dev',
        '',
        'https://explorer.emerald.oasis.dev',
        [],
      );
    

    static ChainInfo ZKFair = ChainInfo(
        42766,
        'ZKFair',
        'evm',
        'https://static.particle.network/token-list/zkfair/native.png',
        'ZKFair Mainnet',
        'Mainnet',
        'https://zkfair.io',
        ChainInfoNativeCurrency('ZKF', 'USDC', 18),
        'https://rpc.zkfair.io',
        '',
        'https://scan.zkfair.io',
        [ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo AvalancheTestnet = ChainInfo(
        43113,
        'Avalanche',
        'evm',
        'https://static.particle.network/token-list/avalanche/native.png',
        'Avalanche Testnet',
        'Testnet',
        'https://cchain.explorer.avax-test.network',
        ChainInfoNativeCurrency('AVAX', 'AVAX', 18),
        'https://api.avax-test.network/ext/bc/C/rpc',
        'https://faucet.avax.network',
        'https://testnet.snowtrace.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Avalanche = ChainInfo(
        43114,
        'Avalanche',
        'evm',
        'https://static.particle.network/token-list/avalanche/native.png',
        'Avalanche Mainnet',
        'Mainnet',
        'https://www.avax.network',
        ChainInfoNativeCurrency('AVAX', 'AVAX', 18),
        'https://api.avax.network/ext/bc/C/rpc',
        '',
        'https://snowtrace.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo ZKFairTestnet = ChainInfo(
        43851,
        'ZKFair',
        'evm',
        'https://static.particle.network/token-list/zkfair/native.png',
        'ZKFair Testnet',
        'Testnet',
        'https://zkfair.io',
        ChainInfoNativeCurrency('ZKF', 'USDC', 18),
        'https://testnet-rpc.zkfair.io',
        '',
        'https://testnet-scan.zkfair.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo CeloTestnet = ChainInfo(
        44787,
        'Celo',
        'evm',
        'https://static.particle.network/token-list/celo/native.png',
        'Celo Testnet',
        'Testnet',
        'https://docs.celo.org',
        ChainInfoNativeCurrency('Celo', 'CELO', 18),
        'https://alfajores-forno.celo-testnet.org',
        'https://celo.org/developers/faucet',
        'https://explorer.celo.org/alfajores',
        [],
      );
    

    static ChainInfo ZircuitTestnet = ChainInfo(
        48899,
        'Zircuit',
        'evm',
        'https://static.particle.network/token-list/zircuit/native.png',
        'Zircuit Testnet',
        'Testnet',
        'https://www.zircuit.com',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://zircuit1.p2pify.com',
        '',
        'https://explorer.testnet.zircuit.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo DODOChainTestnet = ChainInfo(
        53457,
        'DODOChain',
        'evm',
        'https://static.particle.network/token-list/dodochain/native.png',
        'DODOChain Testnet',
        'Testnet',
        'https://www.dodochain.com',
        ChainInfoNativeCurrency('DODO', 'DODO', 18),
        'https://dodochain-testnet.alt.technology',
        '',
        'https://testnet-scan.dodochain.com',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ZerooneTestnet = ChainInfo(
        56400,
        'Zeroone',
        'evm',
        'https://static.particle.network/token-list/zeroone/native.png',
        'Zeroone Testnet',
        'Testnet',
        'https://zeroone.art',
        ChainInfoNativeCurrency('ZERO', 'ZERO', 18),
        'https://subnets.avax.network/testnetzer/testnet/rpc',
        '',
        'https://subnets-test.avax.network/testnetzer',
        [ChainInfoFeature('EIP1559')],
      );
    

    static ChainInfo LineaSepolia = ChainInfo(
        59141,
        'Linea',
        'evm',
        'https://static.particle.network/token-list/linea/native.png',
        'Linea Sepolia',
        'Sepolia',
        'https://linea.build',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.sepolia.linea.build',
        'https://faucet.goerli.linea.build',
        'https://sepolia.lineascan.build',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Linea = ChainInfo(
        59144,
        'Linea',
        'evm',
        'https://static.particle.network/token-list/linea/native.png',
        'Linea Mainnet',
        'Mainnet',
        'https://linea.build',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.linea.build',
        '',
        'https://lineascan.build',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP'),ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo BOB = ChainInfo(
        60808,
        'BOB',
        'evm',
        'https://static.particle.network/token-list/bob/native.png',
        'BOB Mainnet',
        'Mainnet',
        'https://www.gobob.xyz',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.gobob.xyz',
        '',
        'https://explorer.gobob.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo PolygonAmoy = ChainInfo(
        80002,
        'Polygon',
        'evm',
        'https://static.particle.network/token-list/polygon/native.png',
        'Polygon Amoy',
        'Amoy',
        'https://polygon.technology',
        ChainInfoNativeCurrency('MATIC', 'MATIC', 18),
        'https://rpc-amoy.polygon.technology',
        '',
        'https://www.oklink.com/amoy',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BerachainbArtio = ChainInfo(
        80084,
        'Berachain',
        'evm',
        'https://static.particle.network/token-list/berachain/native.png',
        'Berachain bArtio',
        'bArtio',
        'https://www.berachain.com',
        ChainInfoNativeCurrency('BERA', 'BERA', 18),
        'https://bartio.rpc.berachain.com',
        'https://bartio.faucet.berachain.com',
        'https://bartio.beratrail.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Blast = ChainInfo(
        81457,
        'Blast',
        'evm',
        'https://static.particle.network/token-list/blast/native.png',
        'Blast Mainnet',
        'Mainnet',
        'https://blastblockchain.com',
        ChainInfoNativeCurrency('Blast Ether', 'ETH', 18),
        'https://rpc.blast.io',
        '',
        'https://blastscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo LorenzoTestnet = ChainInfo(
        83291,
        'lorenzo',
        'evm',
        'https://static.particle.network/token-list/lorenzo/native.png',
        'Lorenzo Testnet',
        'Testnet',
        'https://lorenzo-protocol.xyz',
        ChainInfoNativeCurrency('stBTC', 'stBTC', 18),
        'https://rpc-testnet.lorenzo-protocol.xyz',
        '',
        'https://scan-testnet.lorenzo-protocol.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BaseSepolia = ChainInfo(
        84532,
        'Base',
        'evm',
        'https://static.particle.network/token-list/base/native.png',
        'Base Sepolia',
        'Sepolia',
        'https://base.org',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://sepolia.base.org',
        'https://bridge.base.org/deposit',
        'https://sepolia.basescan.org',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo TUNATestnet = ChainInfo(
        89682,
        'TUNA',
        'evm',
        'https://static.particle.network/token-list/tuna/native.png',
        'TUNA Testnet',
        'Testnet',
        'https://tunachain.io',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://babytuna.rpc.tunachain.io',
        '',
        'https://babytuna.explorer.tunachain.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo XterioBNB = ChainInfo(
        112358,
        'xterio',
        'evm',
        'https://static.particle.network/token-list/xterio/native.png',
        'Xterio(BNB) Mainnet',
        'Mainnet',
        'https://xter.io',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://xterio.alt.technology',
        '',
        'https://xterscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Taiko = ChainInfo(
        167000,
        'Taiko',
        'evm',
        'https://static.particle.network/token-list/taiko/native.png',
        'Taiko Mainnet',
        'Mainnet',
        'https://taiko.xyz',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://rpc.mainnet.taiko.xyz',
        '',
        'https://taikoscan.network',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo TaikoHekla = ChainInfo(
        167009,
        'Taiko',
        'evm',
        'https://static.particle.network/token-list/taiko/native.png',
        'Taiko Hekla',
        'Hekla',
        'https://taiko.xyz',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://rpc.hekla.taiko.xyz',
        '',
        'https://explorer.hekla.taiko.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BitlayerTestnet = ChainInfo(
        200810,
        'Bitlayer',
        'evm',
        'https://static.particle.network/token-list/bitlayer/native.png',
        'Bitlayer Testnet',
        'Testnet',
        'https://www.bitlayer.org',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://testnet-rpc.bitlayer.org',
        '',
        'https://testnet-scan.bitlayer.org',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Bitlayer = ChainInfo(
        200901,
        'Bitlayer',
        'evm',
        'https://static.particle.network/token-list/bitlayer/native.png',
        'Bitlayer Mainnet',
        'Mainnet',
        'https://www.bitlayer.org',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://rpc.bitlayer.org',
        '',
        'https://www.btrscan.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo DuckchainTestnet = ChainInfo(
        202105,
        'Duckchain',
        'evm',
        'https://static.particle.network/token-list/duckchain/native.png',
        'Duckchain Testnet',
        'Testnet',
        'https://testnet-scan.duckchain.io',
        ChainInfoNativeCurrency('TON', 'TON', 18),
        'https://testnet-rpc.duckchain.io',
        '',
        'https://testnet-scan.duckchain.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo PlatON = ChainInfo(
        210425,
        'PlatON',
        'evm',
        'https://static.particle.network/token-list/platon/native.png',
        'PlatON Mainnet',
        'Mainnet',
        'https://www.platon.network',
        ChainInfoNativeCurrency('LAT', 'LAT', 18),
        'https://openapi2.platon.network/rpc',
        '',
        'https://scan.platon.network',
        [],
      );
    

    static ChainInfo ArbitrumSepolia = ChainInfo(
        421614,
        'Arbitrum',
        'evm',
        'https://static.particle.network/token-list/arbitrum/native.png',
        'Arbitrum Sepolia',
        'Sepolia',
        'https://arbitrum.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://sepolia-rollup.arbitrum.io/rpc',
        '',
        'https://sepolia.arbiscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo ScrollSepolia = ChainInfo(
        534351,
        'Scroll',
        'evm',
        'https://static.particle.network/token-list/scroll/native.png',
        'Scroll Sepolia',
        'Sepolia',
        'https://scroll.io',
        ChainInfoNativeCurrency('Scroll', 'ETH', 18),
        'https://sepolia-rpc.scroll.io',
        '',
        'https://sepolia.scrollscan.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Scroll = ChainInfo(
        534352,
        'Scroll',
        'evm',
        'https://static.particle.network/token-list/scroll/native.png',
        'Scroll Mainnet',
        'Mainnet',
        'https://scroll.io',
        ChainInfoNativeCurrency('Scroll', 'ETH', 18),
        'https://rpc.scroll.io',
        '',
        'https://scrollscan.com',
        [ChainInfoFeature('ERC4337'),ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo MerlinTestnet = ChainInfo(
        686868,
        'Merlin',
        'evm',
        'https://static.particle.network/token-list/merlin/native.png',
        'Merlin Testnet',
        'Testnet',
        'https://merlinprotocol.org',
        ChainInfoNativeCurrency('BTC', 'BTC', 18),
        'https://testnet-rpc.merlinchain.io',
        '',
        'https://testnet-scan.merlinchain.io',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo SeiDevnet = ChainInfo(
        713715,
        'Sei',
        'evm',
        'https://static.particle.network/token-list/sei/native.png',
        'Sei Devnet',
        'Devnet',
        'https://www.sei.io',
        ChainInfoNativeCurrency('SEI', 'SEI', 18),
        'https://evm-rpc-arctic-1.sei-apis.com',
        '',
        'https://devnet.seistream.app',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo zkLinkNova = ChainInfo(
        810180,
        'zkLink',
        'evm',
        'https://static.particle.network/token-list/zklink/native.png',
        'zkLink Nova Mainnet',
        'Mainnet',
        'https://zklink.io',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.zklink.io',
        '',
        'https://explorer.zklink.io',
        [],
      );
    

    static ChainInfo XterioBNBTestnet = ChainInfo(
        1637450,
        'xterio',
        'evm',
        'https://static.particle.network/token-list/xterio/native.png',
        'Xterio(BNB) Testnet',
        'Testnet',
        'https://xter.io',
        ChainInfoNativeCurrency('BNB', 'BNB', 18),
        'https://xterio-testnet.alt.technology',
        '',
        'https://testnet.xterscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo PlatONTestnet = ChainInfo(
        2206132,
        'PlatON',
        'evm',
        'https://static.particle.network/token-list/platon/native.png',
        'PlatON Testnet',
        'Testnet',
        'https://www.platon.network',
        ChainInfoNativeCurrency('LAT', 'LAT', 18),
        'https://devnetopenapi2.platon.network/rpc',
        'https://devnet2faucet.platon.network/faucet',
        'https://devnet2scan.platon.network',
        [],
      );
    

    static ChainInfo XterioETH = ChainInfo(
        2702128,
        'xterioeth',
        'evm',
        'https://static.particle.network/token-list/xterioeth/native.png',
        'Xterio(ETH) Mainnet',
        'Mainnet',
        'https://xterscan.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://xterio-eth.alt.technology',
        '',
        'https://eth.xterscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo MantaSepolia = ChainInfo(
        3441006,
        'Manta',
        'evm',
        'https://static.particle.network/token-list/manta/native.png',
        'Manta Sepolia',
        'Sepolia',
        'https://manta.network',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://pacific-rpc.sepolia-testnet.manta.network/http',
        'https://pacific-info.manta.network',
        'https://pacific-explorer.sepolia-testnet.manta.network',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo AstarzkEVMTestnet = ChainInfo(
        6038361,
        'AstarZkEVM',
        'evm',
        'https://static.particle.network/token-list/astarzkevm/native.png',
        'Astar zkEVM Testnet',
        'Testnet',
        'https://astar.network',
        ChainInfoNativeCurrency('Sepolia Ether', 'ETH', 18),
        'https://rpc.startale.com/zkyoto',
        '',
        'https://zkyoto.explorer.startale.com',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Zora = ChainInfo(
        7777777,
        'Zora',
        'evm',
        'https://static.particle.network/token-list/zora/native.png',
        'Zora Mainnet',
        'Mainnet',
        'https://zora.energy',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.zora.energy',
        '',
        'https://explorer.zora.energy',
        [ChainInfoFeature('EIP1559')],
      );
    

    static ChainInfo EthereumSepolia = ChainInfo(
        11155111,
        'Ethereum',
        'evm',
        'https://static.particle.network/token-list/ethereum/native.png',
        'Ethereum Sepolia',
        'Sepolia',
        'https://sepolia.otterscan.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://rpc.sepolia.org',
        'https://faucet.quicknode.com/drip',
        'https://sepolia.etherscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo OptimismSepolia = ChainInfo(
        11155420,
        'Optimism',
        'evm',
        'https://static.particle.network/token-list/optimism/native.png',
        'Optimism Sepolia',
        'Sepolia',
        'https://optimism.io',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://sepolia.optimism.io',
        '',
        'https://sepolia-optimism.etherscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Ancient8Testnet = ChainInfo(
        28122024,
        'ancient8',
        'evm',
        'https://static.particle.network/token-list/ancient8/native.png',
        'Ancient8 Testnet',
        'Testnet',
        'https://ancient8.gg',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpcv2-testnet.ancient8.gg',
        '',
        'https://scanv2-testnet.ancient8.gg',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo CyberTestnet = ChainInfo(
        111557560,
        'Cyber',
        'evm',
        'https://static.particle.network/token-list/cyber/native.png',
        'Cyber Testnet',
        'Testnet',
        'https://testnet.cyberscan.co',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://cyber-testnet.alt.technology',
        '',
        'https://testnet.cyberscan.co',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo PlumeTestnet = ChainInfo(
        161221135,
        'Plume',
        'evm',
        'https://static.particle.network/token-list/plume/native.png',
        'Plume Testnet',
        'Testnet',
        'https://testnet-explorer.plumenetwork.xyz',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://testnet-rpc.plumenetwork.xyz/infra-partner-http',
        '',
        'https://testnet-explorer.plumenetwork.xyz',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo BlastSepolia = ChainInfo(
        168587773,
        'Blast',
        'evm',
        'https://static.particle.network/token-list/blast/native.png',
        'Blast Sepolia',
        'Sepolia',
        'https://blastblockchain.com',
        ChainInfoNativeCurrency('Blast Ether', 'ETH', 18),
        'https://sepolia.blast.io',
        '',
        'https://testnet.blastscan.io',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Tron = ChainInfo(
        728126428,
        'Tron',
        'evm',
        'https://static.particle.network/token-list/tron/native.png',
        'Tron Mainnet',
        'Mainnet',
        'https://tron.network',
        ChainInfoNativeCurrency('TRX', 'TRX', 6),
        'https://api.trongrid.io',
        '',
        'https://tronscan.io',
        [ChainInfoFeature('ON-RAMP')],
      );
    

    static ChainInfo Ancient8 = ChainInfo(
        888888888,
        'ancient8',
        'evm',
        'https://static.particle.network/token-list/ancient8/native.png',
        'Ancient8 Mainnet',
        'Mainnet',
        'https://ancient8.gg',
        ChainInfoNativeCurrency('ETH', 'ETH', 18),
        'https://rpc.ancient8.gg',
        '',
        'https://scan.ancient8.gg',
        [ChainInfoFeature('EIP1559'),ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo Aurora = ChainInfo(
        1313161554,
        'Aurora',
        'evm',
        'https://static.particle.network/token-list/aurora/native.png',
        'Aurora Mainnet',
        'Mainnet',
        'https://aurora.dev',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://mainnet.aurora.dev',
        '',
        'https://explorer.aurora.dev',
        [ChainInfoFeature('SWAP')],
      );
    

    static ChainInfo AuroraTestnet = ChainInfo(
        1313161555,
        'Aurora',
        'evm',
        'https://static.particle.network/token-list/aurora/native.png',
        'Aurora Testnet',
        'Testnet',
        'https://aurora.dev',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://testnet.aurora.dev',
        'https://aurora.dev/faucet',
        'https://explorer.testnet.aurora.dev',
        [],
      );
    

    static ChainInfo SKALENebula = ChainInfo(
        1482601649,
        'Nebula',
        'evm',
        'https://static.particle.network/token-list/nebula/native.png',
        'SKALE Nebula',
        'Mainnet',
        'https://mainnet.skalenodes.com',
        ChainInfoNativeCurrency('sFUEL', 'sFUEL', 18),
        'https://mainnet.skalenodes.com/v1/green-giddy-denebola',
        '',
        'https://green-giddy-denebola.explorer.mainnet.skalenodes.com',
        [],
      );
    

    static ChainInfo Harmony = ChainInfo(
        1666600000,
        'Harmony',
        'evm',
        'https://static.particle.network/token-list/harmony/native.png',
        'Harmony Mainnet',
        'Mainnet',
        'https://www.harmony.one',
        ChainInfoNativeCurrency('ONE', 'ONE', 18),
        'https://api.harmony.one',
        '',
        'https://explorer.harmony.one',
        [],
      );
    

    static ChainInfo HarmonyTestnet = ChainInfo(
        1666700000,
        'Harmony',
        'evm',
        'https://static.particle.network/token-list/harmony/native.png',
        'Harmony Testnet',
        'Testnet',
        'https://www.harmony.one',
        ChainInfoNativeCurrency('ONE', 'ONE', 18),
        'https://api.s0.b.hmny.io',
        'https://faucet.pops.one',
        'https://explorer.pops.one',
        [],
      );
    

    static ChainInfo KakarotSepolia = ChainInfo(
        1802203764,
        'Kakarot',
        'evm',
        'https://static.particle.network/token-list/kakarot/native.png',
        'Kakarot Sepolia',
        'Sepolia',
        'https://www.kakarot.org',
        ChainInfoNativeCurrency('Ether', 'ETH', 18),
        'https://sepolia-rpc.kakarot.org',
        '',
        'https://sepolia.kakarotscan.org',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo LumiaTestnet = ChainInfo(
        1952959480,
        'Lumia',
        'evm',
        'https://static.particle.network/token-list/lumia/native.png',
        'Lumia Testnet',
        'Testnet',
        'https://www.lumia.org',
        ChainInfoNativeCurrency('LUMIA', 'LUMIA', 18),
        'https://testnet-rpc.lumia.org',
        '',
        'https://testnet-explorer.lumia.org',
        [ChainInfoFeature('ERC4337')],
      );
    

    static ChainInfo TronShasta = ChainInfo(
        2494104990,
        'Tron',
        'evm',
        'https://static.particle.network/token-list/tron/native.png',
        'Tron Shasta',
        'Shasta',
        'https://www.trongrid.io/shasta',
        ChainInfoNativeCurrency('TRX', 'TRX', 6),
        'https://api.shasta.trongrid.io',
        '',
        'https://shasta.tronscan.org',
        [],
      );
    

    static ChainInfo TronNile = ChainInfo(
        3448148188,
        'Tron',
        'evm',
        'https://static.particle.network/token-list/tron/native.png',
        'Tron Nile',
        'Nile',
        'https://nileex.io',
        ChainInfoNativeCurrency('TRX', 'TRX', 6),
        'https://nile.trongrid.io',
        'https://nileex.io/join/getJoinPage',
        'https://nile.tronscan.org',
        [],
      );

    static Map<String, ChainInfo> ParticleChains = {'ethereum-1':ChainInfo.Ethereum,'optimism-10':ChainInfo.Optimism,'thundercore-18':ChainInfo.ThunderCoreTestnet,'elastos-20':ChainInfo.Elastos,'cronos-25':ChainInfo.Cronos,'bsc-56':ChainInfo.BNBChain,'okc-65':ChainInfo.OKTCTestnet,'okc-66':ChainInfo.OKTC,'confluxespace-71':ChainInfo.ConfluxeSpaceTestnet,'viction-88':ChainInfo.Viction,'viction-89':ChainInfo.VictionTestnet,'bsc-97':ChainInfo.BNBChainTestnet,'gnosis-100':ChainInfo.Gnosis,'solana-101':ChainInfo.Solana,'solana-102':ChainInfo.SolanaTestnet,'solana-103':ChainInfo.SolanaDevnet,'thundercore-108':ChainInfo.ThunderCore,'bob-111':ChainInfo.BOBTestnet,'fuse-122':ChainInfo.Fuse,'fuse-123':ChainInfo.FuseTestnet,'polygon-137':ChainInfo.Polygon,'manta-169':ChainInfo.Manta,'okbc-195':ChainInfo.XLayerTestnet,'okbc-196':ChainInfo.XLayer,'opbnb-204':ChainInfo.opBNB,'mapprotocol-212':ChainInfo.MAPProtocolTestnet,'bsquared-223':ChainInfo.BSquared,'fantom-250':ChainInfo.Fantom,'zksync-300':ChainInfo.zkSyncEraSepolia,'kcc-321':ChainInfo.KCC,'kcc-322':ChainInfo.KCCTestnet,'zksync-324':ChainInfo.zkSyncEra,'cronos-338':ChainInfo.CronosTestnet,'mode-919':ChainInfo.ModeTestnet,'fiveire-995':ChainInfo.fiveire,'fiveire-997':ChainInfo.fiveireTestnet,'klaytn-1001':ChainInfo.KlaytnTestnet,'confluxespace-1030':ChainInfo.ConfluxeSpace,'metis-1088':ChainInfo.Metis,'polygonzkevm-1101':ChainInfo.PolygonzkEVM,'core-1115':ChainInfo.CoreTestnet,'core-1116':ChainInfo.Core,'bsquared-1123':ChainInfo.BSquaredTestnet,'hybrid-1225':ChainInfo.HybridTestnet,'moonbeam-1284':ChainInfo.Moonbeam,'moonriver-1285':ChainInfo.Moonriver,'moonbeam-1287':ChainInfo.MoonbeamTestnet,'sei-1328':ChainInfo.SeiTestnet,'sei-1329':ChainInfo.Sei,'bevm-1501':ChainInfo.BEVMCanary,'bevm-1502':ChainInfo.BEVMCanaryTestnet,'storynetwork-1513':ChainInfo.StoryNetworkTestnet,'gravity-1625':ChainInfo.Gravity,'combo-1715':ChainInfo.ComboTestnet,'soneium-1946':ChainInfo.SoneiumMinatoTestnet,'kava-2221':ChainInfo.KavaTestnet,'kava-2222':ChainInfo.Kava,'peaq-2241':ChainInfo.PeaqKrest,'polygonzkevm-2442':ChainInfo.PolygonzkEVMCardona,'ainn-2648':ChainInfo.AILayerTestnet,'ainn-2649':ChainInfo.AILayer,'gmnetwork-2777':ChainInfo.GMNetwork,'satoshivm-3109':ChainInfo.SatoshiVMAlpha,'satoshivm-3110':ChainInfo.SatoshiVMTestnet,'peaq network-3338':ChainInfo.Peaq,'botanix-3636':ChainInfo.BotanixTestnet,'astarzkevm-3776':ChainInfo.AstarzkEVMMainet,'fantom-4002':ChainInfo.FantomTestnet,'merlin-4200':ChainInfo.Merlin,'iotex-4689':ChainInfo.IoTeX,'iotex-4690':ChainInfo.IoTeXTestnet,'mantle-5000':ChainInfo.Mantle,'mantle-5003':ChainInfo.MantleSepoliaTestnet,'duckchain-5545':ChainInfo.Duckchain,'opbnb-5611':ChainInfo.opBNBTestnet,'aura-6321':ChainInfo.AuraTestnet,'aura-6322':ChainInfo.Aura,'zetachain-7000':ChainInfo.ZetaChain,'zetachain-7001':ChainInfo.ZetaChainTestnet,'cyber-7560':ChainInfo.Cyber,'klaytn-8217':ChainInfo.Klaytn,'lorenzo-8329':ChainInfo.Lorenzo,'base-8453':ChainInfo.Base,'combo-9980':ChainInfo.Combo,'peaq-9990':ChainInfo.PeaqAgungTestnet,'gnosis-10200':ChainInfo.GnosisTestnet,'bevm-11501':ChainInfo.BEVM,'bevm-11503':ChainInfo.BEVMTestnet,'readon-12015':ChainInfo.ReadONTestnet,'immutable-13473':ChainInfo.ImmutablezkEVMTestnet,'gravity-13505':ChainInfo.GravityTestnet,'eosevm-15557':ChainInfo.EOSEVMTestnet,'ethereum-17000':ChainInfo.EthereumHolesky,'eosevm-17777':ChainInfo.EOSEVM,'mapprotocol-22776':ChainInfo.MAPProtocol,'zeroone-27827':ChainInfo.Zeroone,'movement-30732':ChainInfo.MovementDevnet,'mode-34443':ChainInfo.Mode,'arbitrum-42161':ChainInfo.ArbitrumOne,'arbitrum-42170':ChainInfo.ArbitrumNova,'celo-42220':ChainInfo.Celo,'oasisemerald-42261':ChainInfo.OasisEmeraldTestnet,'oasisemerald-42262':ChainInfo.OasisEmerald,'zkfair-42766':ChainInfo.ZKFair,'avalanche-43113':ChainInfo.AvalancheTestnet,'avalanche-43114':ChainInfo.Avalanche,'zkfair-43851':ChainInfo.ZKFairTestnet,'celo-44787':ChainInfo.CeloTestnet,'zircuit-48899':ChainInfo.ZircuitTestnet,'dodochain-53457':ChainInfo.DODOChainTestnet,'zeroone-56400':ChainInfo.ZerooneTestnet,'linea-59141':ChainInfo.LineaSepolia,'linea-59144':ChainInfo.Linea,'bob-60808':ChainInfo.BOB,'polygon-80002':ChainInfo.PolygonAmoy,'berachain-80084':ChainInfo.BerachainbArtio,'blast-81457':ChainInfo.Blast,'lorenzo-83291':ChainInfo.LorenzoTestnet,'base-84532':ChainInfo.BaseSepolia,'tuna-89682':ChainInfo.TUNATestnet,'xterio-112358':ChainInfo.XterioBNB,'taiko-167000':ChainInfo.Taiko,'taiko-167009':ChainInfo.TaikoHekla,'bitlayer-200810':ChainInfo.BitlayerTestnet,'bitlayer-200901':ChainInfo.Bitlayer,'duckchain-202105':ChainInfo.DuckchainTestnet,'platon-210425':ChainInfo.PlatON,'arbitrum-421614':ChainInfo.ArbitrumSepolia,'scroll-534351':ChainInfo.ScrollSepolia,'scroll-534352':ChainInfo.Scroll,'merlin-686868':ChainInfo.MerlinTestnet,'sei-713715':ChainInfo.SeiDevnet,'zklink-810180':ChainInfo.zkLinkNova,'xterio-1637450':ChainInfo.XterioBNBTestnet,'platon-2206132':ChainInfo.PlatONTestnet,'xterioeth-2702128':ChainInfo.XterioETH,'manta-3441006':ChainInfo.MantaSepolia,'astarzkevm-6038361':ChainInfo.AstarzkEVMTestnet,'zora-7777777':ChainInfo.Zora,'ethereum-11155111':ChainInfo.EthereumSepolia,'optimism-11155420':ChainInfo.OptimismSepolia,'ancient8-28122024':ChainInfo.Ancient8Testnet,'cyber-111557560':ChainInfo.CyberTestnet,'plume-161221135':ChainInfo.PlumeTestnet,'blast-168587773':ChainInfo.BlastSepolia,'tron-728126428':ChainInfo.Tron,'ancient8-888888888':ChainInfo.Ancient8,'aurora-1313161554':ChainInfo.Aurora,'aurora-1313161555':ChainInfo.AuroraTestnet,'nebula-1482601649':ChainInfo.SKALENebula,'harmony-1666600000':ChainInfo.Harmony,'harmony-1666700000':ChainInfo.HarmonyTestnet,'kakarot-1802203764':ChainInfo.KakarotSepolia,'lumia-1952959480':ChainInfo.LumiaTestnet,'tron-2494104990':ChainInfo.TronShasta,'tron-3448148188':ChainInfo.TronNile};
    // template code end

  static List<ChainInfo> getAllChains(
      [int Function(ChainInfo, ChainInfo)? comparator]) {
    List<ChainInfo> list = ParticleChains.values.toList();

    List<String> sortKeys = [
      'Solana',
      'Ethereum',
      'BSC',
      'opBNB',
      'Polygon',
      'Avalanche',
      'Moonbeam',
      'Moonriver',
      'Heco',
      'Fantom',
      'Arbitrum',
      'Harmony',
      'Aurora',
      'Optimism',
      'KCC',
      'PlatON',
      'Tron',
    ];

    if (comparator != null) {
      list.sort(comparator);
      return list;
    }

    list.sort((ChainInfo a, ChainInfo b) {
      if (sortKeys.contains(a.name) && sortKeys.contains(b.name)) {
        if (a.name == b.name) {
          if (a.network == 'Mainnet') {
            return -1;
          } else if (b.network == 'Mainnet') {
            return 1;
          }
          return 0;
        } else if (sortKeys.indexOf(a.name) > sortKeys.indexOf(b.name)) {
          return 1;
        }
        return -1;
      } else if (sortKeys.contains(a.name)) {
        return -1;
      } else if (sortKeys.contains(b.name)) {
        return 1;
      } else if (a.name == b.name) {
        if (a.network == 'Mainnet') {
          return -1;
        } else if (b.network == 'Mainnet') {
          return 1;
        }
        return a.fullname.compareTo(b.fullname);
      } else {
        return a.name.compareTo(b.name);
      }
    });

    return list;
  }

  static ChainInfo? getChain(int chainId, String chainName) {
    String key = [chainName.toLowerCase(), chainId].join('-');
    if (!ParticleChains.containsKey(key)) {
      return null;
    }
    return ParticleChains[key];
  }

  static ChainInfo? getEvmChain(int chainId) {
    try {
      return ParticleChains.values.firstWhere(
          (element) => element.chainType == 'evm' && element.id == chainId);
    } catch (e) {
      return null;
    }
  }

  static ChainInfo? getSolanaChain(int chainId) {
    try {
      return ParticleChains.values.firstWhere(
          (element) => element.chainType == 'solana' && element.id == chainId);
    } catch (e) {
      return null;
    }
  }

  static String getParticleNode(int id, String projectId, String projectKey) {
    return Uri(
        scheme: 'https',
        host: 'rpc.particle.network',
        path: 'evm-chain',
        queryParameters: {
          'chainId': id.toString(),
          'projectUuid': projectId,
          'projectKey': projectKey,
        }).toString();
  }

  bool isEvmChain() {
    return chainType == 'evm';
  }

  bool isSolanaChain() {
    return chainType == 'solana';
  }

  bool isMainnet() {
    return network == 'Mainnet';
  }

  bool isEIP1559Supported() {
    return features.map((e) => e.name).contains('EIP1559');
  }

  bool isSupportWalletConnect() {
    return isEvmChain() && name != 'Tron';
  }
}
