# Upgrade Guide
Upgrading from version 1.4.x to version 1.5.x - this is an upgrade guide. If you were previously using particle-auth, you can upgrade to particle-auth-core. If you need to connect to other wallet services, such as Metamask, you can directly upgrade to particle-connect. Below is a comparison table of methods before and after the upgrade.

## Quick Methods Comparison
| particle-auth          | particle-auth-core                                | particle-connect                           |
| ---------------------- | ------------------------------------------------- | ------------------------------------------ |
| init                   | init                                              | init                                       |
| login                  | connect                                           | connect(WalleType.authCore, connectConfig)                |
| getUserInfo            | getUserInfo                                       | getAccounts(WalleType.authCore)            |
| logout/fastLogout      | disconnect                                        | disconnect(WalleType.authCore)             |
| signMessage            | evm.personalSign/solana.signMessage               | signMessage(WalleType.authCore)            |
| signTransaction        | solana.signTransaction                            | signTransaction(WalleType.authCore)        |
| signAllTransactions    | solana.signAllTransactions                        | signAllTransactions(WalleType.authCore)    |
| signTypedData          | evm.signTypedData                                 | signTypedData(WalleType.authCore)          |
| signAndSendTransaction | evm.sendTransaction/solana.signAndSendTransaction | signAndSendTransaction(WalleType.authCore) |
| isLogin/isLoginAsync   | isConnected                                       | isConnected(WalleType.authCore)            |
| hasMasterPassword      | hasMasterPassword                                 | -                                          |
| hasPaymentPassword     | hasPaymentPassword                                | -                                          |
| openAccountAndSecurity | openAccountAndSecurity                            | -                                          |
| openWebWallet          | -                                                 | -                                          |
| setChainInfoAsync      | switchChain                                       | -                                          |

## More details
With partice-connect, WalletType.authCore, after connect successfully, you will get an account, that contains publicAddress, if you need more data, such as userInfo, you can retrieve it by calling `particleAuthCore.getUserInfo`, and we can't provide userInfo for other walletTypes.

