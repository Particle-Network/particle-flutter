package network.particle.connect_plugin.module;

import android.app.Activity
import auth.core.adapter.AuthCoreAdapter
import auth.core.adapter.ConnectConfigEmail
import auth.core.adapter.ConnectConfigJWT
import auth.core.adapter.ConnectConfigPhone
import auth.core.adapter.ConnectConfigSocialLogin
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.google.gson.Gson
import com.connect.common.*
import com.connect.common.eip4361.Eip4361Message
import com.connect.common.model.*
import com.connect.common.utils.AppUtils
import com.evm.adapter.EVMConnectAdapter
import com.google.gson.reflect.TypeToken
import com.particle.base.Env
import com.particle.base.ParticleNetwork
import com.particle.base.data.ErrorInfo
import com.particle.base.data.SignOutput
import com.particle.base.data.WebServiceCallback
import com.particle.base.iaa.FeeMode
import com.particle.base.iaa.FeeModeGasless
import com.particle.base.iaa.FeeModeNative
import com.particle.base.iaa.FeeModeToken
import com.particle.base.iaa.MessageSigner
import com.particle.base.model.ChainType
import com.particle.base.model.LoginPrompt
import com.particle.base.model.LoginType
import com.particle.base.model.MobileWCWallet
import com.particle.base.model.MobileWCWalletName
import com.particle.base.model.SocialLoginType
import com.particle.base.model.SupportAuthType
import com.particle.base.model.SupportLoginType
import com.particle.base.utils.ChainUtils
import com.particle.base.utils.PnModuleUtils
import com.particle.connect.ParticleConnect
import com.particle.connect.ParticleConnect.setChain
import com.particle.connect.model.AdapterAccount
import com.particle.connectkit.ConnectKitConfig
import com.particle.connectkit.ParticleConnectKit
import com.phantom.adapter.PhantomConnectAdapter
import com.solana.adapter.SolanaConnectAdapter
import com.wallet.connect.adapter.*
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import network.particle.connect_plugin.model.InitData
import network.particle.connect_plugin.model.RpcUrl
import network.particle.chains.ChainInfo
import network.particle.connect_plugin.model.AccountNew
import network.particle.connect_plugin.model.ChainData
import network.particle.connect_plugin.model.ConnectData
import network.particle.connect_plugin.model.ConnectSignData
import network.particle.connect_plugin.model.FlutterCallBack
import network.particle.connect_plugin.model.FlutterErrorMessage
import network.particle.connect_plugin.utils.BridgeScope
import network.particle.connect_plugin.utils.MessageProcess
import org.json.JSONException
import org.json.JSONObject
import particle.auth.adapter.ParticleConnectAdapter
import particle.auth.adapter.ParticleConnectConfig
import java.lang.RuntimeException
import java.util.Locale

object ConnectBridge {
    /**
     * {
     * "chain": "BscChain",
     * "chain_id": "Testnet",
     * "env": "PRODUCTION"
     * }
     */
    fun init(activity: Activity, initParams: String?) {
        LogUtils.d("init", initParams)
        val initData: InitData = GsonUtils.fromJson(initParams, InitData::class.java)
        val chainInfo: ChainInfo = ChainUtils.getChainInfo(initData.chainId)
        val rpcUrl: RpcUrl? = initData.rpcUrl
        val dAppMetadata = initData.metadata
        ParticleConnect.init(
            activity.application, Env.valueOf(initData.env.uppercase()), chainInfo, dAppMetadata
        ) {
            initAdapter(rpcUrl)
        }
    }

    fun setChainInfo(chainParams: String, result: MethodChannel.Result) {
        val chainData: ChainData = GsonUtils.fromJson(
            chainParams, ChainData::class.java
        )
        try {
            val chainInfo = ChainUtils.getChainInfo(chainData.chainId)
            setChain(chainInfo)
            result.success(true)
        } catch (e: java.lang.Exception) {
            LogUtils.e("setChainName", e.message)
            result.success(false)
        }
    }

    fun setWalletConnectProjectId(walletConnectProjectId: String) {
        ParticleNetwork.setWalletConnectProjectId(walletConnectProjectId)
    }

    var connectAdapter: IConnectAdapter? = null
    fun qrCodeUri(result: MethodChannel.Result) {
        var url: String? = null
        if (connectAdapter is WalletConnectAdapter) {
            url = (connectAdapter as WalletConnectAdapter)?.qrCodeUri()
        }
        result.success(url ?: "")
    }

    fun connect(
        connectJson: String, result: MethodChannel.Result, events: EventChannel.EventSink?
    ) {
        LogUtils.d("connectJson", connectJson)
        val connectData: ConnectData = GsonUtils.fromJson(
            connectJson, ConnectData::class.java
        )
        val walletType = connectData.walletType
        val particleConnectData = connectData.particleConnectData
        var config: ConnectConfig? = null

        try {
            if (particleConnectData != null) {
                val account: String = particleConnectData.account ?: ""
                if (walletType.equals(MobileWCWalletName.Particle.name, true)) {
                    var supportAuthType = SupportAuthType.NONE.value
                    for (i in particleConnectData.supportAuthTypeValues.indices) {
                        try {
                            val supportType =
                                particleConnectData.supportAuthTypeValues[i].uppercase(Locale.getDefault())
                            val authType = SupportAuthType.valueOf(supportType)
                            supportAuthType = supportAuthType or authType.value
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                    config = ParticleConnectConfig(
                        LoginType.valueOf(
                            particleConnectData.loginType.uppercase(
                                Locale.getDefault()
                            )
                        ), supportAuthType, account, null
                    )
                    val configJson = Gson().toJson(config)
                    LogUtils.d("Connect connect config", configJson)
                } else if (walletType.equals(MobileWCWalletName.AuthCore.name, true)) {
                    val loginType =
                        LoginType.valueOf(particleConnectData.loginType.uppercase(Locale.ENGLISH))
                    if (loginType == LoginType.JWT) {
                        config = ConnectConfigJWT(account)
                    } else if (loginType == LoginType.PHONE) {
                        val supportLoginTypes: List<SupportLoginType> =
                            particleConnectData.supportAuthTypeValues.map {
                                SupportLoginType.valueOf(it.uppercase())
                            }
                        val prompt = LoginPrompt.parse(particleConnectData.prompt)
                        config = ConnectConfigPhone(
                            account,
                            particleConnectData.code ?: "",
                            supportLoginTypes,
                            prompt,
                            particleConnectData.loginPageConfig
                        )
                    } else if (loginType == LoginType.EMAIL) {
                        val supportLoginTypes: List<SupportLoginType> =
                            particleConnectData.supportAuthTypeValues.map {
                                SupportLoginType.valueOf(it.uppercase())
                            }
                        val prompt = LoginPrompt.parse(particleConnectData.prompt)
                        config = ConnectConfigEmail(
                            account,
                            particleConnectData.code ?: "",
                            supportLoginTypes,
                            prompt,
                            particleConnectData.loginPageConfig
                        )

                    } else {
                        val socialLoginType = SocialLoginType.valueOf(
                            particleConnectData.loginType.uppercase(
                                Locale.ENGLISH
                            )
                        )
                        val prompt = LoginPrompt.parse(particleConnectData.prompt)
                        config = ConnectConfigSocialLogin(socialLoginType, prompt)
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        var connectAdapter: IConnectAdapter? = null
        val adapters = ParticleConnect.getAdapters()
        for (adapter in adapters) {
            if (adapter.name.equals(walletType, ignoreCase = true)) {
                connectAdapter = adapter
                break
            }
        }
        connectAdapter!!.connect<ConnectConfig>(config, object : ConnectCallback {
            override fun onConnected(account: Account) {
                LogUtils.d("onConnected", account.toString())
                try {
                    result.success(FlutterCallBack.success(account).toGson())
                } catch (_: Exception) {

                }
            }

            override fun onError(connectError: ConnectError) {
                LogUtils.d("onError", connectError.toString())
                try {
                    result.success(
                        FlutterCallBack.failed(
                            FlutterErrorMessage.parseConnectError(
                                connectError
                            )
                        ).toGson()
                    )
                } catch (_: Exception) {

                }
            }
        })
        if (connectAdapter is WalletConnectAdapter) {
            events?.success((connectAdapter as WalletConnectAdapter).qrCodeUri())
        }
    }

    fun connectWithConnectKitConfig(
        connectJson: String, result: MethodChannel.Result, events: EventChannel.EventSink?
    ) {
        LogUtils.d("connectWithConnectKitConfig", connectJson)
        val connectKitConfig: ConnectKitConfig = GsonUtils.fromJson(
            connectJson, ConnectKitConfig::class.java
        )
        LogUtils.d("connectKitConfig", connectKitConfig)
        ParticleConnectKit.connect(connectKitConfig, object : ConnectKitCallback {
            override fun onConnected(walletName: String, account: Account) {
                LogUtils.d("onConnected", account.toString())
                try {
                    result.success(
                        FlutterCallBack.success(
                            AccountNew(
                                account.publicAddress,
                                walletName
                            )
                        ).toGson()
                    )
                } catch (_: Exception) {

                }
            }

            override fun onError(error: ConnectError) {
                try {
                    result.success(
                        FlutterCallBack.failed(
                            FlutterErrorMessage.parseConnectError(
                                error
                            )
                        ).toGson()
                    )
                } catch (_: Exception) {

                }
            }

        })
    }

    fun connectWalletConnect(result: MethodChannel.Result, events: EventChannel.EventSink?) {
        val connectAdapter = ParticleConnect.getAdapters()
            .first { it is WalletConnectAdapter } as WalletConnectAdapter
        connectAdapter.connect<ConnectConfig>(null, object : ConnectCallback {
            override fun onConnected(account: Account) {
                LogUtils.d("onConnected", account.toString())
                result.success(FlutterCallBack.success(account).toGson())
            }

            override fun onError(connectError: ConnectError) {
                LogUtils.d("onError", connectError.toString())
                result.success(
                    FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(connectError))
                        .toGson()
                )
            }
        })
        events?.success(connectAdapter.qrCodeUri())
    }


    fun isConnect(jsonParams: String, result: MethodChannel.Result) {
        LogUtils.d("isConnect", jsonParams)
        try {
            val jsonObject = JSONObject(jsonParams)
            val walletType = jsonObject.getString("wallet_type")
            val publicKey = jsonObject.getString("public_address")
            val connectAdapter = getConnectAdapter(publicKey, walletType)
            var isConnect: Boolean = false
            if (connectAdapter != null) {
                isConnect = connectAdapter.connected(publicKey)
            }
            LogUtils.d("isConnect", isConnect)
            result.success(isConnect)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun getAccounts(walletType: String, result: MethodChannel.Result) {
        LogUtils.d("getAccounts", walletType)
        val adapterAccounts: List<AdapterAccount> = ParticleConnect.getAccounts()
        var accounts: List<Account> = ArrayList()
        for (adapterAccount in adapterAccounts) {
            if (adapterAccount.connectAdapter.name.equals(walletType, true)) {
                accounts = adapterAccount.accounts
                break
            }
        }
        return result.success(FlutterCallBack.success(accounts).toGson())
    }

    fun disconnect(jsonParams: String, result: MethodChannel.Result) {
        LogUtils.d("disconnect", jsonParams)
        try {
            val jsonObject = JSONObject(jsonParams)
            val walletType = jsonObject.getString("wallet_type")
            val publicAddress = jsonObject.getString("public_address")
            val connectAdapter = getConnectAdapter(publicAddress, walletType)
            if (connectAdapter == null) {
                result.success(FlutterCallBack.success(publicAddress).toGson())
                return
            }
            connectAdapter.disconnect(publicAddress, object : DisconnectCallback {
                override fun onDisconnected() {
                    LogUtils.d("onDisconnected", publicAddress)
                    result.success(FlutterCallBack.success(publicAddress).toGson())
                }

                override fun onError(error: ConnectError) {
                    LogUtils.d("onError", error.toString())
                    result.success(
                        FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error))
                            .toGson()
                    )
                }
            })
        } catch (e: JSONException) {
            e.printStackTrace();
            result.success(FlutterCallBack.failed(e.message).toGson())
        }
    }

    fun signMessage(jsonParams: String, result: MethodChannel.Result) {
        LogUtils.d("signMessage", jsonParams)
        val signData = GsonUtils.fromJson(
            jsonParams, ConnectSignData::class.java
        )

        val connectAdapter = getConnectAdapter(signData.publicAddress, signData.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        val message = MessageProcess.start(signData.message)
        connectAdapter.signMessage(signData.publicAddress, message, object : SignCallback {
            override fun onError(error: ConnectError) {
                LogUtils.d("onError", error.toString())
                result.success(
                    FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error)).toGson()
                )
            }

            override fun onSigned(signature: String) {
                LogUtils.d("onSigned", signature)
                result.success(FlutterCallBack.success(signature).toGson())
            }
        })
    }

    fun signAndSendTransaction(jsonParams: String, result: MethodChannel.Result) {
        LogUtils.d("signAndSendTransaction", jsonParams)
        val transParams = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val transaction = transParams.transaction
        val connectAdapter = getConnectAdapter(transParams.publicAddress, transParams.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }

        if (ParticleNetwork.isAAModeEnable()) {
            var feeMode: FeeMode = FeeModeNative()
            if (transParams.feeMode != null) {
                val option = transParams.feeMode.option
                if (option == "token") {
                    val tokenPaymasterAddress = transParams.feeMode.tokenPaymasterAddress
                    val feeQuote = transParams.feeMode.feeQuote!!
                    feeMode = FeeModeToken(feeQuote, tokenPaymasterAddress!!)
                } else if (option == "gasless") {
                    val verifyingPaymasterGasless =
                        transParams.feeMode.wholeFeeQuote.verifyingPaymasterGasless
                    feeMode = FeeModeGasless(verifyingPaymasterGasless)
                } else if (option == "native") {
                    val verifyingPaymasterNative =
                        transParams.feeMode.wholeFeeQuote.verifyingPaymasterNative
                    feeMode = FeeModeNative(verifyingPaymasterNative)
                }
            }
            connectAdapter.signAndSendTransaction(transParams.publicAddress,
                transaction,
                feeMode,
                object : TransactionCallback {
                    override fun onError(error: ConnectError) {
                        LogUtils.d("onError", error.toString())
                        result.success(
                            FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error))
                                .toGson()
                        )
                    }

                    override fun onTransaction(transactionId: String?) {
                        LogUtils.d("onTransaction", transactionId)
                        result.success(FlutterCallBack.success(transactionId).toGson())
                    }
                })
        } else {
            connectAdapter.signAndSendTransaction(transParams.publicAddress,
                transaction,
                object : TransactionCallback {
                    override fun onError(error: ConnectError) {
                        LogUtils.d("onError", error.toString())
                        result.success(
                            FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error))
                                .toGson()
                        )
                    }

                    override fun onTransaction(transactionId: String?) {
                        LogUtils.d("onTransaction", transactionId)
                        result.success(FlutterCallBack.success(transactionId).toGson())
                    }
                })
        }


    }

    fun signTransaction(jsonParams: String, result: MethodChannel.Result) {
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val transaction = signData.transaction
        val connectAdapter = getConnectAdapter(signData.publicAddress, signData.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        connectAdapter.signTransaction(signData.publicAddress, transaction, object : SignCallback {

            override fun onError(error: ConnectError) {
                LogUtils.d("onError", error.toString())
                result.success(
                    FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error)).toGson()
                )
            }

            override fun onSigned(signature: String) {
                LogUtils.d("onSigned", signature)
                result.success(FlutterCallBack.success(signature).toGson())
            }
        })

    }

    fun signAllTransactions(jsonParams: String, result: MethodChannel.Result) {
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)

        val connectAdapter = getConnectAdapter(signData.publicAddress, signData.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        connectAdapter.signAllTransactions(signData.publicAddress,
            signData.transactions.toTypedArray(),
            object : SignAllCallback {

                override fun onError(error: ConnectError) {
                    LogUtils.d("onError", error.toString())
                    result.success(
                        FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error))
                            .toGson()
                    )
                }

                override fun onSigned(signatures: List<String>) {
                    LogUtils.d("onSigned", signatures.toString())
                    result.success(FlutterCallBack.success(signatures).toGson())
                }
            })

    }

    fun signTypedData(jsonParams: String, result: MethodChannel.Result) {
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val connectAdapter = getConnectAdapter(signData.publicAddress, signData.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        val typedData = MessageProcess.processTypedData(signData.message)
        val escapedJson = typedData.replace("\"", "\\\"")
        connectAdapter.signTypedData(signData.publicAddress, escapedJson, object : SignCallback {
            override fun onError(error: ConnectError) {
                LogUtils.d("onError", error.toString())
                result.success(
                    FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error)).toGson()
                )
            }

            override fun onSigned(signature: String) {
                LogUtils.d("onSigned", signature)
                result.success(FlutterCallBack.success(signature).toGson())
            }
        })
    }

    fun importMnemonic(jsonParams: String, result: MethodChannel.Result) {
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val connectAdapter = getPrivateKeyAdapter()
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        BridgeScope.launch {
            try {
                val account = connectAdapter.importWalletFromMnemonic(
                    signData.mnemonic
                )
                result.success(FlutterCallBack.success(account).toGson())
            } catch (e: Exception) {
                e.printStackTrace()
                result.success(FlutterCallBack.failed(e.message).toGson())
            }
        }
    }

    fun importPrivateKey(jsonParams: String, result: MethodChannel.Result) {
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val connectAdapter = getPrivateKeyAdapter()
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        BridgeScope.launch {
            try {
                val account = connectAdapter.importWalletFromPrivateKey(
                    signData.privateKey
                )
                result.success(FlutterCallBack.success(account).toGson())
            } catch (e: Exception) {
                e.printStackTrace()
                result.success(FlutterCallBack.failed(e.message).toGson())
            }
        }
    }

    fun exportPrivateKey(jsonParams: String, result: MethodChannel.Result) {
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val connectAdapter = getPrivateKeyAdapter()
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        BridgeScope.launch {
            try {
                val pk = connectAdapter.exportWalletPrivateKey(
                    signData.publicAddress
                )
                result.success(FlutterCallBack.success(pk).toGson())

            } catch (e: Exception) {
                e.printStackTrace()
                result.success(FlutterCallBack.failed(e.message).toGson())
            }
        }
    }


    fun login(jsonParams: String, result: MethodChannel.Result) {
        LogUtils.d("login", jsonParams)
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val connectAdapter = getConnectAdapter(signData.publicAddress, signData.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        val message = Eip4361Message.createWithRequiredParameter(
            signData.domain, signData.uri, signData.publicAddress
        )

        connectAdapter.login(signData.publicAddress, message, object : SignCallback {

            override fun onError(error: ConnectError) {
                LogUtils.d("onError", error.toString())
                result.success(
                    FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error)).toGson()
                )
            }

            override fun onSigned(signature: String) {
                LogUtils.d("onSigned", signature)
                val map = mapOf("signature" to signature, "message" to message.toString())
                result.success(FlutterCallBack.success(map).toGson())
            }
        })
    }

    fun verify(jsonParams: String, result: MethodChannel.Result) {
        LogUtils.d("verify", jsonParams)
        val signData = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val connectAdapter = getConnectAdapter(signData.publicAddress, signData.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        if (connectAdapter.verify(
                signData.publicAddress, signData.signature, signData.message
            )
        ) {
            result.success(FlutterCallBack.success("success").toGson())
        } else {
            result.success(FlutterCallBack.failed("failed").toGson())
        }
    }

    fun addEthereumChain(jsonParams: String, result: MethodChannel.Result) {
        throw RuntimeException("not support")
    }

    fun switchEthereumChain(jsonParams: String, result: MethodChannel.Result) {
        throw RuntimeException("not support")
    }

    val supportChains: List<ChainType> = listOf(ChainType.EVM)
    fun walletReadyState(jsonParams: String, result: MethodChannel.Result) {
        LogUtils.d("walletReadyState", jsonParams)
        val data = GsonUtils.fromJson(jsonParams, ConnectSignData::class.java)
        val walletType = data.walletType

        val allWallets = listOf<MobileWCWallet>(
            MobileWCWallet.MetaMask,
            MobileWCWallet.Rainbow,
            MobileWCWallet.Trust,
            MobileWCWallet.ImToken,
            MobileWCWallet.BitKeep,
            MobileWCWallet.MathWallet,
            MobileWCWallet.TokenPocket,
            MobileWCWallet.Zerion,
            MobileWCWallet.Coin98,
            MobileWCWallet.Bitpie,
            MobileWCWallet.ZenGo,
            MobileWCWallet.Alpha,
            MobileWCWallet.TTWallet,
        )
        val firstWallet = allWallets.first {
            it.name.lowercase() == walletType.lowercase() || it.name.lowercase()
                .contains(walletType.lowercase()) || walletType.lowercase()
                .contains(it.name.lowercase())
        }
        if (firstWallet == null) {
            result.success("notDetected")
        }
        if (supportChains.contains(ConnectManager.chainType)) {

            if (AppUtils.isAppInstalled(ConnectManager.context, firstWallet.packageName)) {
                result.success("installed")
            } else {
                result.success("notDetected")
            }
        } else {
            result.success("unsupported")
        }

    }

    //get adapter
    fun getConnectAdapter(publicAddress: String, walletType: String): IConnectAdapter? {
        try {
            val allAdapters = ParticleConnect.getAdapters().filter {
                it.name.equals(walletType, true)
            }
            val adapters = allAdapters.filter {
                val accounts = it.getAccounts()
                accounts.any { account -> account.publicAddress.equals(publicAddress, true) }
            }
            var connectAdapter: IConnectAdapter? = null
            if (adapters.isNotEmpty()) {
                connectAdapter = adapters[0]
            }
            return connectAdapter
        } catch (e: Exception) {
            return null
        }

    }

    fun getPrivateKeyAdapter(): ILocalAdapter? {
        val allAdapters = ParticleConnect.getAdapters()
        if (ParticleNetwork.isEvmChain()) {
            for (adapter in allAdapters) {
                if (adapter is EVMConnectAdapter) {
                    return adapter as ILocalAdapter
                }
            }
        } else {
            for (adapter in allAdapters) {
                if (adapter is SolanaConnectAdapter) {
                    return adapter as ILocalAdapter
                }
            }
        }
        return null
    }


    private fun initAdapter(rpcUrl: RpcUrl?): List<IConnectAdapter> {
        val adapters = mutableListOf<IConnectAdapter>(
            ParticleConnectAdapter(),
            MetaMaskConnectAdapter(),
            RainbowConnectAdapter(),
            TrustConnectAdapter(),
            ImTokenConnectAdapter(),
            BitGetConnectAdapter(),
            OKXConnectAdapter(),
            WalletConnectAdapter(),
            PhantomConnectAdapter(),
        )
        if (rpcUrl != null) {
            adapters.add(EVMConnectAdapter(rpcUrl.evmUrl))
        } else {
            adapters.add(EVMConnectAdapter())
        }

        if (rpcUrl != null) {
            adapters.add(SolanaConnectAdapter(rpcUrl.solUrl))
        } else {
            adapters.add(SolanaConnectAdapter())
        }
        if (PnModuleUtils.isAuthCoreAdapterImplementation()) {
            adapters.add(AuthCoreAdapter())
        }
        return adapters;
    }

    fun getChainInfo(result: MethodChannel.Result) {
        val chainInfo: ChainInfo = ParticleNetwork.chainInfo
        val map: MutableMap<String, Any> = HashMap()
        map["chain_name"] = chainInfo.name
        map["chain_id"] = chainInfo.id
        result.success(Gson().toJson(map))
    }

    fun setWalletConnectV2SupportChainInfos(
        chainsString: String?, result: MethodChannel.Result
    ) {
        LogUtils.d("setWalletConnectV2SupportChainInfos", chainsString)
        val initData: List<InitData> =
            GsonUtils.fromJson(chainsString, object : TypeToken<List<InitData>>() {}.type)
//        val initData: InitData = GsonUtils.fromJson(initParams, InitData::class.java)
        val chainInfos = mutableListOf<ChainInfo>()
        initData.forEach {
            chainInfos.add(ChainUtils.getChainInfo(it.chainId))
        }
        ParticleConnect.setWalletConnectV2SupportChainInfos(chainInfos)
    }


    fun batchSendTransactions(transactions: String, result: MethodChannel.Result) {
        LogUtils.d("batchSendTransactions", transactions)
        val transParams =
            GsonUtils.fromJson<ConnectSignData>(transactions, ConnectSignData::class.java)
        val connectAdapter = getConnectAdapter(transParams.publicAddress, transParams.walletType)
        if (connectAdapter == null) {
            result.success(
                FlutterCallBack.failed(
                    FlutterErrorMessage.parseConnectError(
                        ConnectError.Unauthorized()
                    )
                ).toGson()
            )
            return
        }
        var feeMode: FeeMode = FeeModeNative()
        if (transParams.feeMode != null) {
            val option = transParams.feeMode.option
            if (option == "token") {
                val tokenPaymasterAddress = transParams.feeMode.tokenPaymasterAddress
                val feeQuote = transParams.feeMode.feeQuote!!
                feeMode = FeeModeToken(feeQuote, tokenPaymasterAddress!!)
            } else if (option == "gasless") {
                val verifyingPaymasterGasless =
                    transParams.feeMode.wholeFeeQuote.verifyingPaymasterGasless
                feeMode = FeeModeGasless(verifyingPaymasterGasless)
            } else if (option == "native") {
                val verifyingPaymasterNative =
                    transParams.feeMode.wholeFeeQuote.verifyingPaymasterNative
                feeMode = FeeModeNative(verifyingPaymasterNative)
            }
        }
        CoroutineScope(Dispatchers.IO).launch {
            try {
                ParticleNetwork.getAAService().quickSendTransaction(transParams.transactions,
                    feeMode,
                    object : MessageSigner {
                        override fun signMessage(
                            message: String,
                            callback: WebServiceCallback<SignOutput>,
                            chainId: Long?
                        ) {
                            connectAdapter.signMessage(transParams.publicAddress,
                                message,
                                object : SignCallback {
                                    override fun onError(error: ConnectError) {
                                        callback.failure(
                                            ErrorInfo(
                                                error.message, error.code
                                            )
                                        )
                                    }

                                    override fun onSigned(signature: String) {
                                        callback.success(SignOutput(signature))
                                    }

                                })

                        }

                        override fun eoaAddress(): String {
                            return connectAdapter.getAccounts()[0].publicAddress
                        }

                    },
                    object : WebServiceCallback<SignOutput> {
                        override fun success(output: SignOutput) {
                            result.success(
                                FlutterCallBack.success(output.signature!!).toGson()
                            )
                        }

                        override fun failure(errMsg: ErrorInfo) {
                            result.success(FlutterCallBack.failed(errMsg).toGson())
                        }
                    })
            } catch (e: Exception) {
                e.printStackTrace()
                result.success(
                    FlutterCallBack.failed("failed")
                        .toGson()
                )
            }
        }
    }


}
