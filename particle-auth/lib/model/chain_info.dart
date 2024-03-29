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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo EthereumGoerli = ChainInfo(
    5,
    'Ethereum',
    'evm',
    'https://static.particle.network/token-list/ethereum/native.png',
    'Ethereum Goerli',
    'Goerli',
    'https://goerli.net/#about',
    ChainInfoNativeCurrency('Ether', 'ETH', 18),
    'https://ethereum-goerli.publicnode.com',
    'https://goerlifaucet.com',
    'https://goerli.etherscan.io',
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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
    [],
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
    [],
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
    [],
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
    [],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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

  static ChainInfo Heco = ChainInfo(
    128,
    'Heco',
    'evm',
    'https://static.particle.network/token-list/heco/native.png',
    'Heco Mainnet',
    'Mainnet',
    'https://www.hecochain.com',
    ChainInfoNativeCurrency('HT', 'HT', 18),
    'https://http-mainnet.hecochain.com',
    '',
    'https://hecoinfo.com',
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo X1Testnet = ChainInfo(
    195,
    'OKBC',
    'evm',
    'https://static.particle.network/token-list/okc/native.png',
    'X1 Testnet',
    'Testnet',
    'https://www.okx.com/okbc/docs/dev/quick-start/introduction/introduction-to-okbchain',
    ChainInfoNativeCurrency('OKB', 'OKB', 18),
    'https://testrpc.x1.tech',
    'https://www.okx.com/cn/okbc/faucet',
    'https://www.oklink.com/x1-test',
    [],
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
    [ChainInfoFeature('EIP1559')],
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
    'https://testnet.mapscan.io',
    [ChainInfoFeature('EIP1559')],
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
    [],
  );

  static ChainInfo zkSyncEraTestnet = ChainInfo(
    280,
    'zkSync',
    'evm',
    'https://static.particle.network/token-list/zksync/native.png',
    'zkSync Era Testnet',
    'Testnet',
    'https://era.zksync.io/docs',
    ChainInfoNativeCurrency('zkSync', 'ETH', 18),
    'https://zksync2-testnet.zksync.dev',
    'https://portal.zksync.io/faucet',
    'https://goerli.explorer.zksync.io',
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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

  static ChainInfo OptimismGoerli = ChainInfo(
    420,
    'Optimism',
    'evm',
    'https://static.particle.network/token-list/optimism/native.png',
    'Optimism Goerli',
    'Testnet',
    'https://optimism.io',
    ChainInfoNativeCurrency('Ether', 'ETH', 18),
    'https://goerli.optimism.io',
    'https://faucet.triangleplatform.com/optimism/goerli',
    'https://goerli-optimism.etherscan.io',
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo PGN = ChainInfo(
    424,
    'PGN',
    'evm',
    'https://static.particle.network/token-list/pgn/native.png',
    'PGN Mainnet',
    'Mainnet',
    'https://publicgoods.network',
    ChainInfoNativeCurrency('ETH', 'ETH', 18),
    'https://sepolia.publicgoods.network',
    '',
    'https://explorer.publicgoods.network',
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo MetisGoerli = ChainInfo(
    599,
    'Metis',
    'evm',
    'https://static.particle.network/token-list/metis/native.png',
    'Metis Goerli',
    'Goerli',
    'https://www.metis.io',
    ChainInfoNativeCurrency('Metis', 'METIS', 18),
    'https://goerli.gateway.metisdevops.link',
    'https://goerli.faucet.metisdevops.link',
    'https://goerli.explorer.metisdevops.link',
    [],
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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo ZoraGoerli = ChainInfo(
    999,
    'Zora',
    'evm',
    'https://static.particle.network/token-list/zora/native.png',
    'Zora Goerli',
    'Goerli',
    'https://testnet.wanscan.org',
    ChainInfoNativeCurrency('ETH', 'ETH', 18),
    'https://testnet.rpc.zora.energy',
    '',
    'https://testnet.explorer.zora.energy',
    [ChainInfoFeature('EIP1559')],
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
    [],
  );

  static ChainInfo BSquaredTestnet = ChainInfo(
    1102,
    'BSquared',
    'evm',
    'https://static.particle.network/token-list/bsquared/native.png',
    'B² Network Testnet',
    'Testnet',
    'https://www.bsquared.network',
    ChainInfoNativeCurrency('BTC', 'BTC', 18),
    'https://haven-rpc.bsquared.network',
    '',
    'https://haven-explorer.bsquared.network',
    [],
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
    [],
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
    [],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo PolygonzkEVMTestnet = ChainInfo(
    1442,
    'PolygonZkEVM',
    'evm',
    'https://static.particle.network/token-list/polygonzkevm/native.png',
    'Polygon zkEVM Testnet',
    'Testnet',
    'https://polygon.technology/solutions/polygon-zkevm',
    ChainInfoNativeCurrency('ETH', 'ETH', 18),
    'https://rpc.public.zkevm-test.net',
    'https://public.zkevm-test.net',
    'https://testnet-zkevm.polygonscan.com',
    [],
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
    [],
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
    [],
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
    '',
    'http://testnet.kavascan.com',
    [ChainInfoFeature('undefined')],
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
    [],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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
    [],
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
    [],
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
    [],
  );

  static ChainInfo MantleTestnet = ChainInfo(
    5001,
    'Mantle',
    'evm',
    'https://static.particle.network/token-list/mantle/native.png',
    'Mantle Testnet',
    'Testnet',
    'https://mantle.xyz',
    ChainInfoNativeCurrency('MNT', 'MNT', 18),
    'https://rpc.testnet.mantle.xyz',
    'https://faucet.testnet.mantle.xyz',
    'https://explorer.testnet.mantle.xyz',
    [],
  );

  static ChainInfo opBNBTestnet = ChainInfo(
    5611,
    'opBNB',
    'evm',
    'https://static.particle.network/token-list/bsc/native.png',
    'opBNB Testnet',
    'Testnet',
    'https://opbnb.bnbchain.org',
    ChainInfoNativeCurrency('BNB', 'BNB', 18),
    'https://opbnb-testnet-rpc.bnbchain.org',
    '',
    'https://opbnb-testnet.bscscan.com',
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
  );

  static ChainInfo LumozzkEVMTestnet = ChainInfo(
    12008,
    'Lumoz',
    'evm',
    'https://static.particle.network/token-list/opside/native.png',
    'Lumoz zkEVM Testnet',
    'Testnet',
    'https://lumoz.org',
    ChainInfoNativeCurrency('Lumoz', 'MOZ', 18),
    'https://alpha-zkrollup-rpc.lumoz.org/public',
    '',
    'https://public.zkevm.lumoz.info',
    [],
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
    [],
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
    '',
    'https://explorer.testnet.evm.eosnetwork.com',
    [ChainInfoFeature('undefined')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo LumiBitTestnet = ChainInfo(
    28206,
    'lumibit',
    'evm',
    'https://static.particle.network/token-list/lumibit/native.png',
    'LumiBit Testnet',
    'Testnet',
    '',
    ChainInfoNativeCurrency('BTC', 'BTC', 18),
    'https://test-rpc.lumibit.org',
    '',
    'https://test-scan.lumibit.org',
    [],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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
    [],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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
    ' https://celo.org/developers/faucet',
    'https://explorer.celo.org/alfajores',
    [],
  );

  static ChainInfo PGNSepolia = ChainInfo(
    58008,
    'PGN',
    'evm',
    'https://static.particle.network/token-list/pgn/native.png',
    'PGN Sepolia',
    'Sepolia',
    'https://publicgoods.network',
    ChainInfoNativeCurrency('ETH', 'ETH', 18),
    'https://sepolia.publicgoods.network',
    '',
    'https://explorer.sepolia.publicgoods.network',
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo LineaGoerli = ChainInfo(
    59140,
    'Linea',
    'evm',
    'https://static.particle.network/token-list/linea/native.png',
    'Linea Goerli',
    'Goerli',
    'https://linea.build',
    ChainInfoNativeCurrency('ETH', 'ETH', 18),
    'https://rpc.goerli.linea.build',
    'https://faucet.goerli.linea.build',
    'https://goerli.lineascan.build',
    [ChainInfoFeature('EIP1559')],
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
    'https://linea-mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
    '',
    'https://lineascan.build',
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo PolygonMumbai = ChainInfo(
    80001,
    'Polygon',
    'evm',
    'https://static.particle.network/token-list/polygon/native.png',
    'Polygon Mumbai',
    'Mumbai',
    'https://polygon.technology',
    ChainInfoNativeCurrency('MATIC', 'MATIC', 18),
    'https://polygon-mumbai.gateway.tenderly.co',
    'https://faucet.polygon.technology',
    'https://mumbai.polygonscan.com',
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo BerachainArtio = ChainInfo(
    80085,
    'Berachain',
    'evm',
    'https://static.particle.network/token-list/berachain/native.png',
    'Berachain Artio',
    'Artio',
    'https://www.berachain.com',
    ChainInfoNativeCurrency('BERA', 'BERA', 18),
    'https://artio.rpc.berachain.com',
    'https://artio.faucet.berachain.com',
    'https://artio.beratrail.io',
    [],
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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo BaseGoerli = ChainInfo(
    84531,
    'Base',
    'evm',
    'https://static.particle.network/token-list/base/native.png',
    'Base Goerli',
    'Goerli',
    'https://base.org',
    ChainInfoNativeCurrency('ETH', 'ETH', 18),
    'https://base-goerli.public.blastapi.io',
    'https://bridge.base.org/deposit',
    'https://goerli.basescan.org',
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo ComboTestnet = ChainInfo(
    91715,
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
    [ChainInfoFeature('EIP1559')],
  );

  static ChainInfo TaikoKatla = ChainInfo(
    167008,
    'Taiko',
    'evm',
    'https://static.particle.network/token-list/taiko/native.png',
    'Taiko Katla',
    'Katla',
    'https://taiko.xyz',
    ChainInfoNativeCurrency('Ether', 'ETH', 18),
    'https://rpc.katla.taiko.xyz',
    '',
    'https://explorer.katla.taiko.xyz',
    [ChainInfoFeature('EIP1559')],
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
    [],
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

  static ChainInfo ArbitrumGoerli = ChainInfo(
    421613,
    'Arbitrum',
    'evm',
    'https://static.particle.network/token-list/arbitrum/native.png',
    'Arbitrum Goerli',
    'Goerli',
    'https://arbitrum.io',
    ChainInfoNativeCurrency('Arbitrum Gorli Ether', 'AGOR', 18),
    'https://goerli-rollup.arbitrum.io/rpc',
    'https://faucet.triangleplatform.com/arbitrum/goerli',
    'https://goerli.arbiscan.io',
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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
    [],
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
    [],
  );

  static ChainInfo AstarzkEVMTestnet = ChainInfo(
    1261120,
    'AstarZkEVM',
    'evm',
    'https://static.particle.network/token-list/astarzkevm/native.png',
    'Astar zkEVM Testnet',
    'Testnet',
    'https://astar.network',
    ChainInfoNativeCurrency('Sepolia Ether', 'ETH', 18),
    'https://rpc.zkatana.gelato.digital',
    '',
    'https://zkatana.blockscout.com',
    [],
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

  static ChainInfo MantaTestnet = ChainInfo(
    3441005,
    'Manta',
    'evm',
    'https://static.particle.network/token-list/manta/native.png',
    'Manta Testnet',
    'Testnet',
    'https://manta.network',
    ChainInfoNativeCurrency('ETH', 'ETH', 18),
    'https://pacific-rpc.testnet.manta.network/http',
    'https://pacific-info.manta.network',
    'https://pacific-explorer.testnet.manta.network',
    [ChainInfoFeature('EIP1559')],
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
    'https://eth-sepolia.g.alchemy.com/v2/demo',
    'https://faucet.quicknode.com/drip',
    'https://sepolia.etherscan.io',
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [ChainInfoFeature('EIP1559')],
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
    [],
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
    [],
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

  static Map<String, ChainInfo> ParticleChains = {
    'ethereum-1': ChainInfo.Ethereum,
    'ethereum-5': ChainInfo.EthereumGoerli,
    'optimism-10': ChainInfo.Optimism,
    'thundercore-18': ChainInfo.ThunderCoreTestnet,
    'cronos-25': ChainInfo.Cronos,
    'bsc-56': ChainInfo.BNBChain,
    'okc-65': ChainInfo.OKTCTestnet,
    'okc-66': ChainInfo.OKTC,
    'confluxespace-71': ChainInfo.ConfluxeSpaceTestnet,
    'viction-88': ChainInfo.Viction,
    'viction-89': ChainInfo.VictionTestnet,
    'bsc-97': ChainInfo.BNBChainTestnet,
    'gnosis-100': ChainInfo.Gnosis,
    'solana-101': ChainInfo.Solana,
    'solana-102': ChainInfo.SolanaTestnet,
    'solana-103': ChainInfo.SolanaDevnet,
    'thundercore-108': ChainInfo.ThunderCore,
    'heco-128': ChainInfo.Heco,
    'polygon-137': ChainInfo.Polygon,
    'manta-169': ChainInfo.Manta,
    'okbc-195': ChainInfo.X1Testnet,
    'opbnb-204': ChainInfo.opBNB,
    'mapprotocol-212': ChainInfo.MAPProtocolTestnet,
    'fantom-250': ChainInfo.Fantom,
    'zksync-280': ChainInfo.zkSyncEraTestnet,
    'zksync-300': ChainInfo.zkSyncEraSepolia,
    'kcc-321': ChainInfo.KCC,
    'kcc-322': ChainInfo.KCCTestnet,
    'zksync-324': ChainInfo.zkSyncEra,
    'cronos-338': ChainInfo.CronosTestnet,
    'optimism-420': ChainInfo.OptimismGoerli,
    'pgn-424': ChainInfo.PGN,
    'metis-599': ChainInfo.MetisGoerli,
    'mode-919': ChainInfo.ModeTestnet,
    'zora-999': ChainInfo.ZoraGoerli,
    'klaytn-1001': ChainInfo.KlaytnTestnet,
    'confluxespace-1030': ChainInfo.ConfluxeSpace,
    'metis-1088': ChainInfo.Metis,
    'polygonzkevm-1101': ChainInfo.PolygonzkEVM,
    'bsquared-1102': ChainInfo.BSquaredTestnet,
    'core-1115': ChainInfo.CoreTestnet,
    'core-1116': ChainInfo.Core,
    'moonbeam-1284': ChainInfo.Moonbeam,
    'moonriver-1285': ChainInfo.Moonriver,
    'moonbeam-1287': ChainInfo.MoonbeamTestnet,
    'polygonzkevm-1442': ChainInfo.PolygonzkEVMTestnet,
    'bevm-1501': ChainInfo.BEVMCanary,
    'bevm-1502': ChainInfo.BEVMCanaryTestnet,
    'kava-2221': ChainInfo.KavaTestnet,
    'kava-2222': ChainInfo.Kava,
    'polygonzkevm-2442': ChainInfo.PolygonzkEVMCardona,
    'satoshivm-3110': ChainInfo.SatoshiVMTestnet,
    'botanix-3636': ChainInfo.BotanixTestnet,
    'fantom-4002': ChainInfo.FantomTestnet,
    'merlin-4200': ChainInfo.Merlin,
    'mantle-5000': ChainInfo.Mantle,
    'mantle-5001': ChainInfo.MantleTestnet,
    'opbnb-5611': ChainInfo.opBNBTestnet,
    'zetachain-7000': ChainInfo.ZetaChain,
    'zetachain-7001': ChainInfo.ZetaChainTestnet,
    'klaytn-8217': ChainInfo.Klaytn,
    'base-8453': ChainInfo.Base,
    'combo-9980': ChainInfo.Combo,
    'gnosis-10200': ChainInfo.GnosisTestnet,
    'bevm-11503': ChainInfo.BEVMTestnet,
    'lumoz-12008': ChainInfo.LumozzkEVMTestnet,
    'readon-12015': ChainInfo.ReadONTestnet,
    'eosevm-15557': ChainInfo.EOSEVMTestnet,
    'ethereum-17000': ChainInfo.EthereumHolesky,
    'eosevm-17777': ChainInfo.EOSEVM,
    'mapprotocol-22776': ChainInfo.MAPProtocol,
    'lumibit-28206': ChainInfo.LumiBitTestnet,
    'mode-34443': ChainInfo.Mode,
    'arbitrum-42161': ChainInfo.ArbitrumOne,
    'arbitrum-42170': ChainInfo.ArbitrumNova,
    'celo-42220': ChainInfo.Celo,
    'oasisemerald-42261': ChainInfo.OasisEmeraldTestnet,
    'oasisemerald-42262': ChainInfo.OasisEmerald,
    'zkfair-42766': ChainInfo.ZKFair,
    'avalanche-43113': ChainInfo.AvalancheTestnet,
    'avalanche-43114': ChainInfo.Avalanche,
    'zkfair-43851': ChainInfo.ZKFairTestnet,
    'celo-44787': ChainInfo.CeloTestnet,
    'pgn-58008': ChainInfo.PGNSepolia,
    'linea-59140': ChainInfo.LineaGoerli,
    'linea-59144': ChainInfo.Linea,
    'polygon-80001': ChainInfo.PolygonMumbai,
    'berachain-80085': ChainInfo.BerachainArtio,
    'blast-81457': ChainInfo.Blast,
    'base-84531': ChainInfo.BaseGoerli,
    'base-84532': ChainInfo.BaseSepolia,
    'combo-91715': ChainInfo.ComboTestnet,
    'taiko-167008': ChainInfo.TaikoKatla,
    'bitlayer-200810': ChainInfo.BitlayerTestnet,
    'platon-210425': ChainInfo.PlatON,
    'arbitrum-421613': ChainInfo.ArbitrumGoerli,
    'arbitrum-421614': ChainInfo.ArbitrumSepolia,
    'scroll-534351': ChainInfo.ScrollSepolia,
    'scroll-534352': ChainInfo.Scroll,
    'merlin-686868': ChainInfo.MerlinTestnet,
    'astarzkevm-1261120': ChainInfo.AstarzkEVMTestnet,
    'platon-2206132': ChainInfo.PlatONTestnet,
    'manta-3441005': ChainInfo.MantaTestnet,
    'zora-7777777': ChainInfo.Zora,
    'ethereum-11155111': ChainInfo.EthereumSepolia,
    'optimism-11155420': ChainInfo.OptimismSepolia,
    'ancient8-28122024': ChainInfo.Ancient8Testnet,
    'blast-168587773': ChainInfo.BlastSepolia,
    'tron-728126428': ChainInfo.Tron,
    'aurora-1313161554': ChainInfo.Aurora,
    'aurora-1313161555': ChainInfo.AuroraTestnet,
    'nebula-1482601649': ChainInfo.SKALENebula,
    'harmony-1666600000': ChainInfo.Harmony,
    'harmony-1666700000': ChainInfo.HarmonyTestnet,
    'tron-2494104990': ChainInfo.TronShasta,
    'tron-3448148188': ChainInfo.TronNile
  };
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
