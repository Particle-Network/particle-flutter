enum Env { dev, staging, production }

class ChainInfo {
  late int id;
  late String name;
  late String chainType;
  late String icon;
  late String fullname;
  late String network;
  late String website;
  late ({String name, String symbol, int decimals}) nativeCurrency;
  late String rpcUrl;
  late String faucetUrl;
  late String blockExplorerUrl;
  late List<({String name})> features;

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
    (name: 'Ether', symbol: 'ETH', decimals: 18),
    'https://ethereum.publicnode.com',
    '',
    'https://etherscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo EthereumGoerli = ChainInfo(
    5,
    'Ethereum',
    'evm',
    'https://static.particle.network/token-list/ethereum/native.png',
    'Ethereum Goerli',
    'Goerli',
    'https://goerli.net/#about',
    (name: 'Ether', symbol: 'ETH', decimals: 18),
    'https://ethereum-goerli.publicnode.com',
    'https://goerlifaucet.com',
    'https://goerli.etherscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo Optimism = ChainInfo(
    10,
    'Optimism',
    'evm',
    'https://static.particle.network/token-list/optimism/native.png',
    'Optimism Mainnet',
    'Mainnet',
    'https://optimism.io',
    (name: 'Ether', symbol: 'ETH', decimals: 18),
    'https://mainnet.optimism.io',
    '',
    'https://optimistic.etherscan.io',
    [],
  );

  static ChainInfo ThunderCoreTestnet = ChainInfo(
    18,
    'ThunderCore',
    'evm',
    'https://static.particle.network/token-list/thundercore/native.png',
    'ThunderCore Testnet',
    'Testnet',
    'https://thundercore.com',
    (name: 'ThunderCore Token', symbol: 'TT', decimals: 18),
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
    (name: 'Cronos', symbol: 'CRO', decimals: 18),
    'https://evm.cronos.org',
    '',
    'https://cronoscan.com',
    [(name: 'EIP1559')],
  );

  static ChainInfo BNBChain = ChainInfo(
    56,
    'BSC',
    'evm',
    'https://static.particle.network/token-list/bsc/native.png',
    'BNB Chain',
    'Mainnet',
    'https://www.bnbchain.org/en',
    (name: 'BNB', symbol: 'BNB', decimals: 18),
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
    (name: 'OKT', symbol: 'OKT', decimals: 18),
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
    (name: 'OKT', symbol: 'OKT', decimals: 18),
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
    (name: 'CFX', symbol: 'CFX', decimals: 18),
    'https://evmtestnet.confluxrpc.com',
    'https://efaucet.confluxnetwork.org',
    'https://evmtestnet.confluxscan.net',
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
    (name: 'BNB', symbol: 'BNB', decimals: 18),
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
    (name: 'Gnosis', symbol: 'XDAI', decimals: 18),
    'https://rpc.ankr.com/gnosis',
    '',
    'https://gnosisscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo Solana = ChainInfo(
    101,
    'Solana',
    'solana',
    'https://static.particle.network/token-list/solana/native.png',
    'Solana Mainnet',
    'Mainnet',
    'https://solana.com',
    (name: 'SOL', symbol: 'SOL', decimals: 9),
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
    (name: 'SOL', symbol: 'SOL', decimals: 9),
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
    (name: 'SOL', symbol: 'SOL', decimals: 9),
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
    (name: 'ThunderCore Token', symbol: 'TT', decimals: 18),
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
    (name: 'HT', symbol: 'HT', decimals: 18),
    'https://http-mainnet.hecochain.com',
    '',
    'https://hecoinfo.com',
    [(name: 'EIP1559')],
  );

  static ChainInfo Polygon = ChainInfo(
    137,
    'Polygon',
    'evm',
    'https://static.particle.network/token-list/polygon/native.png',
    'Polygon Mainnet',
    'Mainnet',
    'https://polygon.technology',
    (name: 'MATIC', symbol: 'MATIC', decimals: 18),
    'https://polygon-rpc.com',
    '',
    'https://polygonscan.com',
    [(name: 'EIP1559')],
  );

  static ChainInfo OKBCTestnet = ChainInfo(
    195,
    'OKBC',
    'evm',
    'https://static.particle.network/token-list/okc/native.png',
    'OKBC Testnet',
    'Testnet',
    'https://www.okx.com/okbc/docs/dev/quick-start/introduction/introduction-to-okbchain',
    (name: 'OKB', symbol: 'OKB', decimals: 18),
    'https://okbtestrpc.okbchain.org',
    'https://www.okx.com/cn/okbc/faucet',
    'https://www.oklink.com/cn/okbc-test',
    [],
  );

  static ChainInfo opBNB = ChainInfo(
    204,
    'opBNB',
    'evm',
    'https://static.particle.network/token-list/bsc/native.png',
    'opBNB Mainnet',
    'Mainnet',
    'https://opbnb.bnbchain.org',
    (name: 'BNB', symbol: 'BNB', decimals: 18),
    'https://opbnb-mainnet-rpc.bnbchain.org',
    '',
    'https://mainnet.opbnbscan.com',
    [(name: 'EIP1559')],
  );

  static ChainInfo MAPProtocolTestnet = ChainInfo(
    212,
    'MAPProtocol',
    'evm',
    'https://static.particle.network/token-list/mapprotocol/native.png',
    'MAP Protocol Testnet',
    'Testnet',
    'https://maplabs.io',
    (name: 'MAPO', symbol: 'MAPO', decimals: 18),
    'https://testnet-rpc.maplabs.io',
    'https://faucet.mapprotocol.io',
    'https://testnet.mapscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo Fantom = ChainInfo(
    250,
    'Fantom',
    'evm',
    'https://static.particle.network/token-list/fantom/native.png',
    'Fantom Mainnet',
    'Mainnet',
    'https://fantom.foundation',
    (name: 'FTM', symbol: 'FTM', decimals: 18),
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
    (name: 'zkSync', symbol: 'ETH', decimals: 18),
    'https://zksync2-testnet.zksync.dev',
    'https://portal.zksync.io/faucet',
    'https://goerli.explorer.zksync.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo KCC = ChainInfo(
    321,
    'KCC',
    'evm',
    'https://static.particle.network/token-list/kcc/native.png',
    'KCC Mainnet',
    'Mainnet',
    'https://kcc.io',
    (name: 'KCS', symbol: 'KCS', decimals: 18),
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
    (name: 'KCS', symbol: 'KCS', decimals: 18),
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
    (name: 'zkSync', symbol: 'ETH', decimals: 18),
    'https://zksync2-mainnet.zksync.io',
    '',
    'https://explorer.zksync.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo CronosTestnet = ChainInfo(
    338,
    'Cronos',
    'evm',
    'https://static.particle.network/token-list/cronos/native.png',
    'Cronos Testnet',
    'Testnet',
    'https://cronos.org',
    (name: 'Cronos', symbol: 'CRO', decimals: 18),
    'https://evm-t3.cronos.org',
    'https://cronos.org/faucet',
    'https://testnet.cronoscan.com',
    [(name: 'EIP1559')],
  );

  static ChainInfo OptimismGoerli = ChainInfo(
    420,
    'Optimism',
    'evm',
    'https://static.particle.network/token-list/optimism/native.png',
    'Optimism Goerli',
    'Testnet',
    'https://optimism.io',
    (name: 'Ether', symbol: 'ETH', decimals: 18),
    'https://goerli.optimism.io',
    'https://faucet.triangleplatform.com/optimism/goerli',
    'https://goerli-optimism.etherscan.io',
    [],
  );

  static ChainInfo PGN = ChainInfo(
    424,
    'PGN',
    'evm',
    'https://static.particle.network/token-list/pgn/native.png',
    'PGN Mainnet',
    'Mainnet',
    'https://publicgoods.network',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://sepolia.publicgoods.network',
    '',
    'https://explorer.publicgoods.network',
    [(name: 'EIP1559')],
  );

  static ChainInfo MetisGoerli = ChainInfo(
    599,
    'Metis',
    'evm',
    'https://static.particle.network/token-list/metis/native.png',
    'Metis Goerli',
    'Goerli',
    'https://www.metis.io',
    (name: 'Metis', symbol: 'METIS', decimals: 18),
    'https://goerli.gateway.metisdevops.link',
    'https://goerli.faucet.metisdevops.link',
    'https://goerli.explorer.metisdevops.link',
    [],
  );

  static ChainInfo ZoraGoerli = ChainInfo(
    999,
    'Zora',
    'evm',
    'https://static.particle.network/token-list/zora/native.png',
    'Zora Goerli',
    'Goerli',
    'https://testnet.wanscan.org',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://testnet.rpc.zora.energy',
    '',
    'https://testnet.explorer.zora.energy',
    [(name: 'EIP1559')],
  );

  static ChainInfo KlaytnTestnet = ChainInfo(
    1001,
    'Klaytn',
    'evm',
    'https://static.particle.network/token-list/klaytn/native.png',
    'Klaytn Testnet',
    'Testnet',
    'https://www.klaytn.com',
    (name: 'Klaytn', symbol: 'KLAY', decimals: 18),
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
    (name: 'CFX', symbol: 'CFX', decimals: 18),
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
    (name: 'Metis', symbol: 'METIS', decimals: 18),
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
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://zkevm-rpc.com',
    '',
    'https://zkevm.polygonscan.com',
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
    (name: 'GLMR', symbol: 'GLMR', decimals: 18),
    'https://rpc.api.moonbeam.network',
    '',
    'https://moonbeam.moonscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo Moonriver = ChainInfo(
    1285,
    'Moonriver',
    'evm',
    'https://static.particle.network/token-list/moonriver/native.png',
    'Moonriver Mainnet',
    'Mainnet',
    'https://moonbeam.network/networks/moonriver',
    (name: 'MOVR', symbol: 'MOVR', decimals: 18),
    'https://rpc.api.moonriver.moonbeam.network',
    '',
    'https://moonriver.moonscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo MoonbeamTestnet = ChainInfo(
    1287,
    'Moonbeam',
    'evm',
    'https://static.particle.network/token-list/moonbeam/native.png',
    'Moonbeam Testnet',
    'Testnet',
    'https://docs.moonbeam.network/networks/testnet',
    (name: 'Dev', symbol: 'DEV', decimals: 18),
    'https://rpc.api.moonbase.moonbeam.network',
    'https://apps.moonbeam.network/moonbase-alpha/faucet',
    'https://moonbase.moonscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo PolygonzkEVMTestnet = ChainInfo(
    1442,
    'PolygonZkEVM',
    'evm',
    'https://static.particle.network/token-list/polygonzkevm/native.png',
    'Polygon zkEVM Testnet',
    'Testnet',
    'https://polygon.technology/solutions/polygon-zkevm',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://rpc.public.zkevm-test.net',
    'https://public.zkevm-test.net',
    'https://testnet-zkevm.polygonscan.com',
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
    (name: 'FTM', symbol: 'FTM', decimals: 18),
    'https://rpc.testnet.fantom.network',
    'https://faucet.fantom.network',
    'https://testnet.ftmscan.com',
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
    (name: 'MNT', symbol: 'MNT', decimals: 18),
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
    (name: 'MNT', symbol: 'MNT', decimals: 18),
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
    (name: 'BNB', symbol: 'BNB', decimals: 18),
    'https://opbnb-testnet-rpc.bnbchain.org',
    '',
    'https://opbnb-testnet.bscscan.com',
    [(name: 'EIP1559')],
  );

  static ChainInfo Klaytn = ChainInfo(
    8217,
    'Klaytn',
    'evm',
    'https://static.particle.network/token-list/klaytn/native.png',
    'Klaytn Mainnet',
    'Mainnet',
    'https://www.klaytn.com',
    (name: 'Klaytn', symbol: 'KLAY', decimals: 18),
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
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://developer-access-mainnet.base.org',
    '',
    'https://basescan.org',
    [(name: 'EIP1559')],
  );

  static ChainInfo GnosisTestnet = ChainInfo(
    10200,
    'Gnosis',
    'evm',
    'https://static.particle.network/token-list/gnosis/native.png',
    'Gnosis Testnet',
    'Testnet',
    'https://docs.gnosischain.com',
    (name: 'Gnosis', symbol: 'XDAI', decimals: 18),
    'https://optimism.gnosischain.com',
    'https://gnosisfaucet.com',
    'https://blockscout.com/gnosis/chiado',
    [(name: 'EIP1559')],
  );

  static ChainInfo zkMetaTestnet = ChainInfo(
    12009,
    'zkMeta',
    'evm',
    'https://static.particle.network/token-list/zkmeta/native.png',
    'zkMeta Testnet',
    'Testnet',
    'https://satoshichain.net',
    (name: 'IDE', symbol: 'IDE', decimals: 18),
    'https://pre-alpha-zkrollup-rpc.opside.network/era7',
    '',
    'https://era7.zkevm.opside.info',
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
    (name: 'READ', symbol: 'READ', decimals: 18),
    'https://pre-alpha-zkrollup-rpc.opside.network/readon-content-test-chain',
    '',
    'https://readon-content-test-chain.zkevm.opside.info',
    [],
  );

  static ChainInfo GasZeroGoerli = ChainInfo(
    12021,
    'GasZero',
    'evm',
    'https://static.particle.network/token-list/gaszero/native.png',
    'GasZero Goerli',
    'Goerli',
    'https://gaszero.com',
    (name: 'GasZero', symbol: 'GAS0', decimals: 18),
    'https://goerlitest.gaszero.com',
    '',
    'https://scangoerlitest.gaszero.com',
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
    (name: 'MAPO', symbol: 'MAPO', decimals: 18),
    'https://rpc.maplabs.io',
    '',
    'https://mapscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo ArbitrumOne = ChainInfo(
    42161,
    'Arbitrum',
    'evm',
    'https://static.particle.network/token-list/arbitrum/native.png',
    'Arbitrum One',
    'Mainnet',
    'https://arbitrum.io',
    (name: 'Ether', symbol: 'ETH', decimals: 18),
    'https://arb1.arbitrum.io/rpc',
    '',
    'https://arbiscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo ArbitrumNova = ChainInfo(
    42170,
    'Arbitrum',
    'evm',
    'https://static.particle.network/token-list/arbitrum/native.png',
    'Arbitrum Nova',
    'Mainnet',
    'https://arbitrum.io',
    (name: 'Ether', symbol: 'ETH', decimals: 18),
    'https://nova.arbitrum.io/rpc',
    '',
    'https://nova.arbiscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo Celo = ChainInfo(
    42220,
    'Celo',
    'evm',
    'https://static.particle.network/token-list/celo/native.png',
    'Celo Mainnet',
    'Mainnet',
    'https://docs.celo.org',
    (name: 'Celo', symbol: 'CELO', decimals: 18),
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
    (name: 'OasisEmerald', symbol: 'ROSE', decimals: 18),
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
    (name: 'OasisEmerald', symbol: 'ROSE', decimals: 18),
    'https://emerald.oasis.dev',
    '',
    'https://explorer.emerald.oasis.dev',
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
    (name: 'AVAX', symbol: 'AVAX', decimals: 18),
    'https://api.avax-test.network/ext/bc/C/rpc',
    'https://faucet.avax.network',
    'https://testnet.snowtrace.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo Avalanche = ChainInfo(
    43114,
    'Avalanche',
    'evm',
    'https://static.particle.network/token-list/avalanche/native.png',
    'Avalanche Mainnet',
    'Mainnet',
    'https://www.avax.network',
    (name: 'AVAX', symbol: 'AVAX', decimals: 18),
    'https://api.avax.network/ext/bc/C/rpc',
    '',
    'https://snowtrace.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo CeloTestnet = ChainInfo(
    44787,
    'Celo',
    'evm',
    'https://static.particle.network/token-list/celo/native.png',
    'Celo Testnet',
    'Testnet',
    'https://docs.celo.org',
    (name: 'Celo', symbol: 'CELO', decimals: 18),
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
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://sepolia.publicgoods.network',
    '',
    'https://explorer.sepolia.publicgoods.network',
    [(name: 'EIP1559')],
  );

  static ChainInfo LineaGoerli = ChainInfo(
    59140,
    'Linea',
    'evm',
    'https://static.particle.network/token-list/linea/native.png',
    'Linea Goerli',
    'Goerli',
    'https://linea.build',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://rpc.goerli.linea.build',
    'https://faucet.goerli.linea.build',
    'https://goerli.lineascan.build',
    [(name: 'EIP1559')],
  );

  static ChainInfo Linea = ChainInfo(
    59144,
    'Linea',
    'evm',
    'https://static.particle.network/token-list/linea/native.png',
    'Linea Mainnet',
    'Mainnet',
    'https://linea.build',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://linea-mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
    '',
    'https://explorer.linea.build',
    [(name: 'EIP1559')],
  );

  static ChainInfo PolygonMumbai = ChainInfo(
    80001,
    'Polygon',
    'evm',
    'https://static.particle.network/token-list/polygon/native.png',
    'Polygon Mumbai',
    'Mumbai',
    'https://polygon.technology',
    (name: 'MATIC', symbol: 'MATIC', decimals: 18),
    'https://polygon-mumbai.gateway.tenderly.co',
    'https://faucet.polygon.technology',
    'https://mumbai.polygonscan.com',
    [(name: 'EIP1559')],
  );

  static ChainInfo BaseGoerli = ChainInfo(
    84531,
    'Base',
    'evm',
    'https://static.particle.network/token-list/base/native.png',
    'Base Goerli',
    'Goerli',
    'https://base.org',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://base-goerli.public.blastapi.io',
    'https://bridge.base.org/deposit',
    'https://goerli.basescan.org',
    [(name: 'EIP1559')],
  );

  static ChainInfo ComboTestnet = ChainInfo(
    91715,
    'Combo',
    'evm',
    'https://static.particle.network/token-list/combo/native.png',
    'Combo Testnet',
    'Testnet',
    'https://docs.combonetwork.io',
    (name: 'BNB', symbol: 'BNB', decimals: 18),
    'https://test-rpc.combonetwork.io',
    '',
    'https://combotrace-testnet.nodereal.io',
    [],
  );

  static ChainInfo TaikoTestnet = ChainInfo(
    167005,
    'Taiko',
    'evm',
    'https://static.particle.network/token-list/taiko/native.png',
    'Taiko Testnet',
    'Testnet',
    'https://taiko.xyz',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://rpc.test.taiko.xyz',
    'https://bridge.test.taiko.xyz',
    'https://explorer.test.taiko.xyz',
    [(name: 'EIP1559')],
  );

  static ChainInfo PlatON = ChainInfo(
    210425,
    'PlatON',
    'evm',
    'https://static.particle.network/token-list/platon/native.png',
    'PlatON Mainnet',
    'Mainnet',
    'https://www.platon.network',
    (name: 'LAT', symbol: 'LAT', decimals: 18),
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
    (name: 'Arbitrum Gorli Ether', symbol: 'AGOR', decimals: 18),
    'https://goerli-rollup.arbitrum.io/rpc',
    'https://faucet.triangleplatform.com/arbitrum/goerli',
    'https://goerli.arbiscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo ScrollSepolia = ChainInfo(
    534351,
    'Scroll',
    'evm',
    'https://static.particle.network/token-list/scroll/native.png',
    'Scroll Sepolia',
    'Sepolia',
    'https://scroll.io',
    (name: 'Scroll', symbol: 'ETH', decimals: 18),
    'https://sepolia-rpc.scroll.io',
    '',
    'https://sepolia-blockscout.scroll.io',
    [],
  );

  static ChainInfo ScrollAlphaTestnet = ChainInfo(
    534353,
    'Scroll',
    'evm',
    'https://static.particle.network/token-list/scroll/native.png',
    'Scroll Alpha Testnet',
    'Testnet',
    'https://scroll.io',
    (name: 'Scroll', symbol: 'ETH', decimals: 18),
    'https://alpha-rpc.scroll.io/l2',
    '',
    'https://blockscout.scroll.io',
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
    (name: 'LAT', symbol: 'LAT', decimals: 18),
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
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://manta-testnet.calderachain.xyz/http',
    'https://pacific-info.manta.network',
    'https://pacific-explorer.manta.network',
    [(name: 'EIP1559')],
  );

  static ChainInfo Zora = ChainInfo(
    7777777,
    'Zora',
    'evm',
    'https://static.particle.network/token-list/zora/native.png',
    'Zora Mainnet',
    'Mainnet',
    'https://zora.energy',
    (name: 'ETH', symbol: 'ETH', decimals: 18),
    'https://rpc.zora.energy',
    '',
    'https://explorer.zora.energy',
    [(name: 'EIP1559')],
  );

  static ChainInfo EthereumSepolia = ChainInfo(
    11155111,
    'Ethereum',
    'evm',
    'https://static.particle.network/token-list/ethereum/native.png',
    'Ethereum Sepolia',
    'Sepolia',
    'https://sepolia.otterscan.io',
    (name: 'Ether', symbol: 'ETH', decimals: 18),
    'https://eth-sepolia.g.alchemy.com/v2/demo',
    'https://faucet.quicknode.com/drip',
    'https://sepolia.etherscan.io',
    [(name: 'EIP1559')],
  );

  static ChainInfo Tron = ChainInfo(
    728126428,
    'Tron',
    'evm',
    'https://static.particle.network/token-list/tron/native.png',
    'Tron Mainnet',
    'Mainnet',
    'https://tron.network',
    (name: 'TRX', symbol: 'TRX', decimals: 6),
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
    (name: 'Ether', symbol: 'ETH', decimals: 18),
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
    (name: 'Ether', symbol: 'ETH', decimals: 18),
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
    (name: 'sFUEL', symbol: 'sFUEL', decimals: 18),
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
    (name: 'ONE', symbol: 'ONE', decimals: 18),
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
    (name: 'ONE', symbol: 'ONE', decimals: 18),
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
    (name: 'TRX', symbol: 'TRX', decimals: 6),
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
    (name: 'TRX', symbol: 'TRX', decimals: 6),
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
    'bsc-97': ChainInfo.BNBChainTestnet,
    'gnosis-100': ChainInfo.Gnosis,
    'solana-101': ChainInfo.Solana,
    'solana-102': ChainInfo.SolanaTestnet,
    'solana-103': ChainInfo.SolanaDevnet,
    'thundercore-108': ChainInfo.ThunderCore,
    'heco-128': ChainInfo.Heco,
    'polygon-137': ChainInfo.Polygon,
    'okbc-195': ChainInfo.OKBCTestnet,
    'opbnb-204': ChainInfo.opBNB,
    'mapprotocol-212': ChainInfo.MAPProtocolTestnet,
    'fantom-250': ChainInfo.Fantom,
    'zksync-280': ChainInfo.zkSyncEraTestnet,
    'kcc-321': ChainInfo.KCC,
    'kcc-322': ChainInfo.KCCTestnet,
    'zksync-324': ChainInfo.zkSyncEra,
    'cronos-338': ChainInfo.CronosTestnet,
    'optimism-420': ChainInfo.OptimismGoerli,
    'pgn-424': ChainInfo.PGN,
    'metis-599': ChainInfo.MetisGoerli,
    'zora-999': ChainInfo.ZoraGoerli,
    'klaytn-1001': ChainInfo.KlaytnTestnet,
    'confluxespace-1030': ChainInfo.ConfluxeSpace,
    'metis-1088': ChainInfo.Metis,
    'polygonzkevm-1101': ChainInfo.PolygonzkEVM,
    'moonbeam-1284': ChainInfo.Moonbeam,
    'moonriver-1285': ChainInfo.Moonriver,
    'moonbeam-1287': ChainInfo.MoonbeamTestnet,
    'polygonzkevm-1442': ChainInfo.PolygonzkEVMTestnet,
    'fantom-4002': ChainInfo.FantomTestnet,
    'mantle-5000': ChainInfo.Mantle,
    'mantle-5001': ChainInfo.MantleTestnet,
    'opbnb-5611': ChainInfo.opBNBTestnet,
    'klaytn-8217': ChainInfo.Klaytn,
    'base-8453': ChainInfo.Base,
    'gnosis-10200': ChainInfo.GnosisTestnet,
    'zkmeta-12009': ChainInfo.zkMetaTestnet,
    'readon-12015': ChainInfo.ReadONTestnet,
    'gaszero-12021': ChainInfo.GasZeroGoerli,
    'mapprotocol-22776': ChainInfo.MAPProtocol,
    'arbitrum-42161': ChainInfo.ArbitrumOne,
    'arbitrum-42170': ChainInfo.ArbitrumNova,
    'celo-42220': ChainInfo.Celo,
    'oasisemerald-42261': ChainInfo.OasisEmeraldTestnet,
    'oasisemerald-42262': ChainInfo.OasisEmerald,
    'avalanche-43113': ChainInfo.AvalancheTestnet,
    'avalanche-43114': ChainInfo.Avalanche,
    'celo-44787': ChainInfo.CeloTestnet,
    'pgn-58008': ChainInfo.PGNSepolia,
    'linea-59140': ChainInfo.LineaGoerli,
    'linea-59144': ChainInfo.Linea,
    'polygon-80001': ChainInfo.PolygonMumbai,
    'base-84531': ChainInfo.BaseGoerli,
    'combo-91715': ChainInfo.ComboTestnet,
    'taiko-167005': ChainInfo.TaikoTestnet,
    'platon-210425': ChainInfo.PlatON,
    'arbitrum-421613': ChainInfo.ArbitrumGoerli,
    'scroll-534351': ChainInfo.ScrollSepolia,
    'scroll-534353': ChainInfo.ScrollAlphaTestnet,
    'platon-2206132': ChainInfo.PlatONTestnet,
    'manta-3441005': ChainInfo.MantaTestnet,
    'zora-7777777': ChainInfo.Zora,
    'ethereum-11155111': ChainInfo.EthereumSepolia,
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

  static List<ChainInfo> getAllChainInfos() {
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

    final list = ChainInfo.ParticleChains.values.toList();

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

  static String getParticleNode(int id, String projectId, String projectKey) {
    return new Uri(
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
    return this.chainType == 'evm';
  }

  bool isSolanaChain() {
    return this.chainType == 'solana';
  }

  bool isMainnet() {
    return this.network == 'Mainnet';
  }

  bool isEIP1559Supported() {
    return this.features.contains((name: 'EIP1559'));
  }

  bool isSupportWalletConnect() {
    return this.isEvmChain() && this.name != 'Tron';
  }
}
