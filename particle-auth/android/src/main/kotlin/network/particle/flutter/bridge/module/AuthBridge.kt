package network.particle.flutter.bridge.module

import android.app.Activity
import android.text.TextUtils
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.particle.base.ChainInfo
import com.particle.base.Env
import com.particle.base.ParticleNetwork
import com.particle.network.ParticleNetworkAuth.getAddress
import com.particle.network.ParticleNetworkAuth.getUserInfo
import com.particle.network.ParticleNetworkAuth.isLogin
import com.particle.network.ParticleNetworkAuth.login
import com.particle.network.ParticleNetworkAuth.logout
import com.particle.network.ParticleNetworkAuth.setChainInfo
import com.particle.network.ParticleNetworkAuth.signAllTransactions
import com.particle.network.ParticleNetworkAuth.signAndSendTransaction
import com.particle.network.ParticleNetworkAuth.signMessage
import com.particle.network.ParticleNetworkAuth.signTransaction
import com.particle.network.ParticleNetworkAuth.signTypedData
import com.particle.network.SignTypedDataVersion
import com.particle.network.service.ChainChangeCallBack
import com.particle.network.service.LoginType
import com.particle.network.service.SupportAuthType
import com.particle.network.service.WebServiceCallback
import com.particle.network.service.model.*
import io.flutter.plugin.common.MethodChannel
import network.particle.flutter.bridge.model.*
import network.particle.flutter.bridge.utils.ChainUtils
import network.particle.flutter.bridge.utils.EncodeUtils


object AuthBridge {
    ///////////////////////////////////////////////////////////////////////////
    //////////////////////////// AUTH //////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    /**
     * {
     * "chain": "BscChain",
     * "chain_id": "Testnet",
     * "env": "PRODUCTION"
     * }
     */
    fun init(activity: Activity, initParams: String?) {
        LogUtils.d("init", initParams)
        val initData = GsonUtils.fromJson(initParams, InitData::class.java)
        val chainInfo = ChainUtils.getChainInfo(initData.chainName, initData.chainIdName)
        ParticleNetwork.init(activity, Env.valueOf(initData.env.uppercase()), chainInfo)
    }

    /**
     * {
     * "loginType": "phone",
     * "account": "",
     * "supportAuthTypeValues": ["GOOGLE"]
     * }
     */
    fun login(loginParams: String?, result: MethodChannel.Result) {
        LogUtils.d("login", loginParams)
        val loginData = GsonUtils.fromJson(loginParams, LoginData::class.java)
        val account = if (TextUtils.isEmpty(loginData.account)) {
            ""
        } else {
            loginData.account
        }
        var supportAuthType = SupportAuthType.NONE.value
        if (loginData.supportAuthTypeValues.contains("all")) {
            supportAuthType = SupportAuthType.ALL.value
        } else {
            for (i in 0 until loginData.supportAuthTypeValues.size) {
                try {
                    val supportType = loginData.supportAuthTypeValues[i]
                    val authType = SupportAuthType.valueOf(supportType.uppercase())
                    supportAuthType = supportAuthType or authType.value
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }

        ParticleNetwork.login(LoginType.valueOf(loginData.loginType.uppercase()),
            account,
            supportAuthType, false, object : WebServiceCallback<LoginOutput> {
                override fun success(output: LoginOutput) {
                    result.success(FlutterCallBack.success(output).toGson())
                }

                override fun failure(errMsg: WebServiceError) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }
            })
    }

    fun logout(result: MethodChannel.Result) {
        LogUtils.d("logout")
        ParticleNetwork.logout(object : WebServiceCallback<WebOutput> {
            override fun failure(errMsg: WebServiceError) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success(output: WebOutput) {
                result.success(FlutterCallBack.success(output).toGson())
            }
        })
    }

    fun signMessage(message: String, result: MethodChannel.Result) {
        ParticleNetwork.signMessage(
            EncodeUtils.encode(message),
            object : WebServiceCallback<SignOutput> {

                override fun failure(errMsg: WebServiceError) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }
            })
    }

    fun signTransaction(transaction: String, result: MethodChannel.Result) {
        LogUtils.d("signTransaction", transaction)
        ParticleNetwork.signTransaction(transaction,
            object : WebServiceCallback<SignOutput> {

                override fun failure(errMsg: WebServiceError) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }
            })
    }

    fun signAllTransactions(transactions: String, result: MethodChannel.Result) {
        LogUtils.d("signAllTransactions", transactions)
        val trans = GsonUtils.fromJson<List<String>>(
            transactions,
            object : TypeToken<List<String>>() {}.type
        )
        ParticleNetwork.signAllTransactions(trans, object : WebServiceCallback<SignOutput> {
            override fun failure(errMsg: WebServiceError) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success(output: SignOutput) {
                result.success(FlutterCallBack.success(output.signature).toGson())
            }
        })
    }

    fun signAndSendTransaction(transaction: String, result: MethodChannel.Result) {
        LogUtils.d("signAndSendTransaction", transaction)
        ParticleNetwork.signAndSendTransaction(transaction,
            object : WebServiceCallback<SignOutput> {

                override fun failure(errMsg: WebServiceError) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }
            })
    }

    fun signTypedData(json: String, result: MethodChannel.Result) {
        LogUtils.d("SignTypedData", json)
        val signTypedData = GsonUtils.fromJson(
            json,
            SignTypedData::class.java
        )
        ParticleNetwork.signTypedData(
            EncodeUtils.encode(signTypedData.message),
            SignTypedDataVersion.valueOf(signTypedData.version.uppercase()),
            object : WebServiceCallback<SignOutput> {
                override fun failure(errMsg: WebServiceError) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }
            })
    }


    fun setChainInfo(chainParams: String, result: MethodChannel.Result) {
        LogUtils.d("setChainName", chainParams)
        val chainData: ChainData = GsonUtils.fromJson(
            chainParams,
            ChainData::class.java
        )
        try {
            val chainInfo = ChainUtils.getChainInfo(chainData.chainName, chainData.chainIdName)
            if (!ParticleNetwork.isLogin()) {
                ParticleNetwork.setChainInfo(chainInfo)
                result.success(true)
            } else {
                val wallet = if (chainInfo.chain == "evm") {
                    ParticleNetwork.getUserInfo()?.getWallet(UserInfo.WalletChain.evm);
                } else {
                    ParticleNetwork.getUserInfo()?.getWallet(UserInfo.WalletChain.solana);
                }
                if (wallet == null) {
                    result.success(false)
                    return
                }
                if (TextUtils.isEmpty(wallet.publicAddress)) {
                    result.success(false)
                    return
                }
                ParticleNetwork.setChainInfo(chainInfo)
                result.success(true)
            }
        } catch (e: Exception) {
            LogUtils.e("setChainName", e.message)
            result.success(false)
        }
    }

    fun setChainInfoAsync(chainParams: String, result: MethodChannel.Result) {
        LogUtils.d("setChainName", chainParams)
        val chainData = GsonUtils.fromJson(
            chainParams,
            ChainData::class.java
        )
        val chainInfo = ChainUtils.getChainInfo(chainData.chainName, chainData.chainIdName)
        ParticleNetwork.setChainInfo(chainInfo, object : ChainChangeCallBack {
            override fun success() {
                result.success(true)
            }

            override fun failure() {
                result.success(false)
            }
        })
    }

    fun getAddress(result: MethodChannel.Result) {
        val address = ParticleNetwork.getAddress()
        result.success(address)
    }
 

    fun getChainInfo(result: MethodChannel.Result) {
        val chainInfo: ChainInfo = ParticleNetwork.chainInfo
        val map: MutableMap<String, Any> = HashMap()
        map["chain_name"] = chainInfo.chainName.name
        map["chain_id_name"] = chainInfo.chainId.toString()
        map["chain_id"] = chainInfo.chainId.value()
        result.success(Gson().toJson(map))
    }
//
//    val chainInfo: String
//        get() {
//            val chainInfo = chainInfo
//            LogUtils.d("getChainInfo", chainInfo)
//            return chainInfo
//        }
//    val userInfo: String
//        get() {
//            val userInfo = userInfo
//            LogUtils.d("getUserInfo", userInfo)
//            return userInfo
//        }


//
//    val isLogin: Int
//        get() {
//            val isUserLogin = ParticleNetwork.isLogin()
//            LogUtils.d("isUserLogin", isUserLogin)
//            return if (isUserLogin) 1 else 0
//        }
//

//


//
//    ///////////////////////////////////////////////////////////////////////////
//    //////////////////////////// UI//////////////////////////////////////////
//    ///////////////////////////////////////////////////////////////////////////
//    fun navigatorWallet(display: Int) {
//        LogUtils.d("navigatorWallet", display)
//        UIBridge.navigatorWallet(display)
//    }
//
//    fun navigatorTokenReceive(tokenAddress: String?) {
//        LogUtils.d("navigatorTokenReceive", tokenAddress)
//        UIBridge.navigatorTokenReceive(tokenAddress)
//    }
//
//    fun navigatorTokenSend(json: String?) {
//        LogUtils.d("navigatorTokenSend", json)
//        UIBridge.navigatorTokenSend(json)
//    }
//
//    fun navigatorTokenTransactionRecords(tokenAddress: String?) {
//        LogUtils.d("navigatorTokenTransactionRecords", tokenAddress)
//        UIBridge.navigatorTokenTransactionRecords(tokenAddress)
//    }
//
//    fun navigatorNFTSend(json: String?) {
//        LogUtils.d("navigatorNFTSend", json)
//        UIBridge.navigatorNFTSend(json)
//    }
//
//    fun navigatorNFTDetails(mint: String?) {
//        LogUtils.d("navigatorNFTDetails", mint)
//        UIBridge.navigatorNFTDetails(mint)
//    }
//
//    fun getEnv(): Int {
//        return env.ordinal
//    }
//
//    fun getEnablePay(): Int {
//        return if (ParticleNetwork.getEnablePay()) 1 else 0
//    }
//
//    fun enablePay(enable: Boolean) {
//        ParticleNetwork.enablePay(enable)
//    }
//
//    fun openPay() {
//        ParticleNetwork.openPay()
//    }
//
//    ///////////////////////////////////////////////////////////////////////////
//    //////////////////////////// API//////////////////////////////////////////
//    ///////////////////////////////////////////////////////////////////////////
//    fun evmGetTokenList() {
//        LogUtils.d("evmGetTokenList")
//        ApiBridge.evmGetTokenList()
//    }
//
//    //EvmGetTokensAndNFTs
//    fun evmGetTokensAndNFTs(address: String?) {
//        LogUtils.d("evmGetTokensAndNFTs", address)
//        ApiBridge.evmGetTokensAndNFTs(address)
//    }
//
//    fun evmGetTokensAndNFTsFromDB(address: String?) {
//        LogUtils.d("evmGetTokensAndNFTsFromDB", address)
//        ApiBridge.evmGetTokensAndNFTsFromDB(address)
//    }
//
//    fun evmAddCustomTokens(json: String?) {
//        LogUtils.d("evmAddCustomTokens", json)
//        val addCustomTokenData: AddCustomTokenData =
//            GsonUtils.fromJson(json, AddCustomTokenData::class.java)
//        ApiBridge.evmAddCustomTokens(addCustomTokenData.address, addCustomTokenData.tokenAddress)
//    }
//
//    fun evmGetTransactions(address: String?) {
//        LogUtils.d("evmGetTransactions", address)
//        ApiBridge.evmGetTransactions(address)
//    }
//
//    fun evmGetTransactionsFromDB(address: String?) {
//        LogUtils.d("evmGetTransactionsFromDB", address)
//        ApiBridge.evmGetTransactionsFromDB(address)
//    }
//
//    ///////////////////////////////////////////////////////////////////////////
//    //////////////////////////// SOL//////////////////////////////////////////
//    ///////////////////////////////////////////////////////////////////////////
//    fun solanaGetTokenList() {
//        LogUtils.d("solanaGetTokenList")
//        ApiBridge.solanaGetTokenList()
//    }
//
//    fun solanaGetTokensAndNFTs(address: String?) {
//        LogUtils.d("solanaGetTokensAndNFTs", address)
//        ApiBridge.solanaGetTokensAndNFTs(address)
//    }
//
//    fun solanaGetTokensAndNFTsFromDB(address: String?) {
//        LogUtils.d("solanaGetTokensAndNFTsFromDB", address)
//        ApiBridge.solanaGetTokensAndNFTsFromDB(address)
//    }
//
//    //SolanaAddCustomTokens
//    fun solanaAddCustomTokens(json: String?) {
//        LogUtils.d("solanaAddCustomTokens", json)
//        val addCustomTokenData: AddCustomTokenData =
//            GsonUtils.fromJson(json, AddCustomTokenData::class.java)
//        ApiBridge.solanaAddCustomTokens(addCustomTokenData.address, addCustomTokenData.tokenAddress)
//    }
//
//    //SolanaGetTransactions
//    fun solanaGetTransactions(json: String?) {
//        LogUtils.d("solanaGetTransactions", json)
//        val transReqOptData: TransReqOptData = GsonUtils.fromJson(json, TransReqOptData::class.java)
//        ApiBridge.solanaGetTransactions(
//            transReqOptData.address,
//            transReqOptData.before,
//            transReqOptData.until,
//            transReqOptData.limit
//        )
//    }
//
//    //SolanaGetTransactionsFromDB
//    fun solanaGetTransactionsFromDB(json: String?) {
//        LogUtils.d("solanaGetTransactionsFromDB", json)
//        val transReqOptData: TransReqOptData = GsonUtils.fromJson(json, TransReqOptData::class.java)
//        ApiBridge.solanaGetTransactionsFromDB(transReqOptData.address, transReqOptData.limit)
//    }
//
//    //SolanaGetTokenTransactions
//    fun solanaGetTokenTransactions(json: String?) {
//        LogUtils.d("solanaGetTokenTransactions", json)
//        val transReqOptData: TransReqOptData = GsonUtils.fromJson(json, TransReqOptData::class.java)
//        ApiBridge.solanaGetTokenTransactions(
//            transReqOptData.address,
//            transReqOptData.mint,
//            transReqOptData.before,
//            transReqOptData.until,
//            transReqOptData.limit
//        )
//    }
//
//    //SolanaGetTokenTransactionsFromDB
//    fun solanaGetTokenTransactionsFromDB(json: String?) {
//        LogUtils.d("solanaGetTokenTransactionsFromDB", json)
//        val transReqOptData: TransReqOptData = GsonUtils.fromJson(json, TransReqOptData::class.java)
//        ApiBridge.solanaGetTokenTransactionsFromDB(
//            transReqOptData.address,
//            transReqOptData.mint,
//            transReqOptData.limit
//        )
//    }
//
//    /**
//     * GUI
//     */
//    fun setSupportChain(jsonParams: String?) {
//        val chains: List<InitData> =
//            GsonUtils.fromJson(jsonParams, object : TypeToken<List<InitData?>?>() {}.getType())
//        val supportChains: MutableList<ChainInfo> = ArrayList()
//        for (chain in chains) {
//            val chainInfo = ChainUtils.getChainInfo(chain.chainName, chain.chainIdName)
//            supportChains.add(chainInfo)
//        }
//        setSupportChain(supportChains)
//    }
//
//    fun showTestNetwork(show: Boolean) {
//        showTestNetworks(show)
//    }
//
//    fun showManageWallet(show: Boolean) {
//        showManageWallet(show)
//    }
//
//    fun navigatorLoginList() {
//        UnityPlayer.currentActivity.startActivity(
//            Intent(
//                UnityPlayer.currentActivity,
//                UnityLoginOptActivity::class.java
//            )
//        )
//    }
//
//    /**
//     * @param json from_token_address
//     * to_token_address
//     * amount
//     */
//    fun navigatorSwap(json: String?) {
//        navigatorSwap(UnityPlayer.currentActivity, "native")
//    }
//
//    fun switchWallet(jsonParams: String?) {
//        try {
//            val jsonObject = JSONObject(jsonParams)
//            val walletType = jsonObject.getString("wallet_type")
//            val publicKey = jsonObject.getString("public_address")
//            val type: WalletType = WalletTypeParser.getWalletType(walletType)
//            val adapter = getConnectAdapter(type)
//            createSelectedWallet(publicKey, adapter, object : Continuation<Wallet?>() {
//                override fun resume(wallet: Wallet) {
//                    setWallet(wallet, object : Continuation<Unit>() {
//                        override fun resume(value: Unit) {
//                            JavaCallUnityChannel.getInstance()
//                                .switchWalletCallBack(UnityCallBack.success(value))
//                        }
//
//                        override fun resumeWithException(exception: Throwable) {
//                            JavaCallUnityChannel.getInstance()
//                                .switchWalletCallBack(UnityCallBack.failed(exception.message))
//                        }
//                    })
//                }
//
//                override fun resumeWithException(exception: Throwable) {
//                    JavaCallUnityChannel.getInstance()
//                        .switchWalletCallBack(UnityCallBack.failed(exception.message))
//                }
//            })
//        } catch (e: Exception) {
//            e.printStackTrace()
//            JavaCallUnityChannel.getInstance().switchWalletCallBack(UnityCallBack.failed(e.message))
//        }
//}
}