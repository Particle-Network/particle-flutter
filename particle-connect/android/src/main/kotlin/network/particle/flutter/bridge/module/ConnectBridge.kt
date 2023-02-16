package network.particle.flutter.bridge.module

import android.app.Activity
import android.text.TextUtils
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.connect.common.*
import com.connect.common.eip4361.Eip4361Message
import com.connect.common.model.Account
import com.connect.common.model.ConnectError
import com.connect.common.model.DAppMetadata
import com.evm.adapter.EVMConnectAdapter
import com.particle.base.ChainInfo
import com.particle.base.ChainName
import com.particle.base.Env
import com.particle.base.ParticleNetwork
import com.particle.connect.ParticleConnect
import com.particle.connect.ParticleConnect.setChain
import com.particle.connect.ParticleConnectAdapter
import com.particle.connect.ParticleConnectConfig
import com.particle.connect.model.AdapterAccount
import com.particle.network.service.LoginPrompt
import com.particle.network.service.LoginType
import com.particle.network.service.SupportAuthType
import com.phantom.adapter.PhantomConnectAdapter
import com.solana.adapter.SolanaConnectAdapter
import com.wallet.connect.adapter.*
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import network.particle.flutter.bridge.model.*
import network.particle.flutter.bridge.utils.BridgeScope
import network.particle.flutter.bridge.utils.EncodeUtils
import org.json.JSONException
import org.json.JSONObject

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
        val chainInfo: ChainInfo = getChainInfo(initData.chainName, initData.chainIdName)
        val (name, icon, url) = initData.metadata
        val rpcUrl: RpcUrl? = initData.rpcUrl
        val dAppMetadata = DAppMetadata(
            name, icon, url
        )
        val adapter: MutableList<IConnectAdapter> = ArrayList()
        initAdapter(adapter, rpcUrl)
        ParticleConnect.init(
            activity, Env.valueOf(initData.env.uppercase()), chainInfo, dAppMetadata
        ) { adapter }
    }

    fun setChainInfo(chainParams: String, result: MethodChannel.Result) {
        val chainData: ChainData = GsonUtils.fromJson(
            chainParams, ChainData::class.java
        )
        try {
            val chainInfo = getChainInfo(
                chainData.chainName, chainData.chainIdName
            )
            setChain(chainInfo)
            result.success(true)
        } catch (e: java.lang.Exception) {
            LogUtils.e("setChainName", e.message)
            result.success(false)
        }
    }

    fun connect(connectJson: String, result: MethodChannel.Result) {
        LogUtils.d("connectJson", connectJson)


        val connectData: ConnectData = GsonUtils.fromJson(
            connectJson, ConnectData::class.java
        )
        val pnConfig = connectData.particleConnectConfig
        var particleConnectConfig: ParticleConnectConfig? = null
        if (pnConfig != null) {
            val account: String = if (TextUtils.isEmpty(pnConfig.account)) {
                ""
            } else {
                pnConfig.account
            }
            var supportAuthType = SupportAuthType.NONE.value
            for (i in 0 until pnConfig.supportAuthTypeValues.size) {
                try {
                    val supportType: String = pnConfig.supportAuthTypeValues.get(i).uppercase()
                    val authType = SupportAuthType.valueOf(supportType)
                    supportAuthType = supportAuthType or authType.value
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
            var loginFormMode = false
            try {
                loginFormMode = pnConfig.loginFormMode
            } catch (e: Exception) {
                e.printStackTrace()
            }
            var prompt: LoginPrompt? = null
            try {
                if (pnConfig.prompt != null)
                    prompt = LoginPrompt.valueOf(pnConfig.prompt!!)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            particleConnectConfig = ParticleConnectConfig(
                LoginType.valueOf(pnConfig.loginType.uppercase()),
                supportAuthType,
                loginFormMode,
                account, prompt
            )
        }

        var connectAdapter: IConnectAdapter? = null
        val adapters = ParticleConnect.getAdapters()
        for (adapter in adapters) {
            if (adapter.name.equals(connectData.walletType, ignoreCase = true)) {
                connectAdapter = adapter
                break
            }
        }
        connectAdapter!!.connect<ConnectConfig>(particleConnectConfig, object : ConnectCallback {
            override fun onConnected(account: Account) {
                LogUtils.d("onConnected", account.toString())
                result.success(FlutterCallBack.success(account).toGson())
            }

            override fun onError(connectError: ConnectError) {
                LogUtils.d("onError", connectError.toString())
                result.success(FlutterCallBack.failed(connectError.message).toGson())
            }
        })
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
            if (adapterAccount.connectAdapter.name.equals(walletType)) {
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
                result.success(
                    FlutterCallBack.failed(
                        FlutterErrorMessage.parseConnectError(
                            ConnectError.Unauthorized()
                        )
                    ).toGson()
                )
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
        val message = if (connectAdapter is ParticleConnectAdapter) {
            EncodeUtils.encode(signData.message)
        } else {
            signData.message
        }
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
        connectAdapter.signAndSendTransaction(signData.publicAddress,
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
        val typedData = if (connectAdapter is ParticleConnectAdapter) {
            EncodeUtils.encode(signData.message)
        } else {
            signData.message
        }
        connectAdapter.signTypedData(signData.publicAddress,
            typedData,
            object : SignCallback {
                override fun onError(error: ConnectError) {
                    LogUtils.d("onError", error.toString())
                    result.success(
                        FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error))
                            .toGson()
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
            signData.domain,
            signData.uri,
            signData.publicAddress
        )

        connectAdapter.login(signData.publicAddress, message, object : SignCallback {

            override fun onError(error: ConnectError) {
                LogUtils.d("onError", error.toString())
                result.success(
                    FlutterCallBack.failed(FlutterErrorMessage.parseConnectError(error))
                        .toGson()
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
                signData.publicAddress,
                signData.signature,
                signData.message
            )
        ) {
            result.success(FlutterCallBack.success("success").toGson())
        } else {
            result.success(FlutterCallBack.failed("failed").toGson())
        }
    }

    //get adapter
    fun getConnectAdapter(publicAddress: String, walletType: String): IConnectAdapter? {
        val adapters = ParticleConnect.getAdapterByAddress(publicAddress)
        var connectAdapter: IConnectAdapter? = null
        if (adapters.isNotEmpty()) {
            connectAdapter = adapters[0]
        }
        return connectAdapter
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


    private fun initAdapter(adapter: MutableList<IConnectAdapter>, rpcUrl: RpcUrl?) {
        try {
            adapter.add(ParticleConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            adapter.add(MetaMaskConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            adapter.add(RainbowConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            adapter.add(TrustConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            adapter.add(PhantomConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            adapter.add(WalletConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            adapter.add(ImTokenConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            adapter.add(BitKeepConnectAdapter())
        } catch (ignored: Exception) {
        }
        try {
            if (rpcUrl != null) {
                adapter.add(EVMConnectAdapter(rpcUrl.evmUrl))
            } else {
                adapter.add(EVMConnectAdapter())
            }
        } catch (ignored: Exception) {
        }
        try {
            if (rpcUrl != null) {
                adapter.add(SolanaConnectAdapter(rpcUrl.solUrl))
            } else {
                adapter.add(SolanaConnectAdapter())
            }
        } catch (ignored: Exception) {
        }
    }

    fun getChainInfo(chainName: String, chainIdName: String?): ChainInfo {
        var chainNameTmp = chainName
        if (ChainName.BSC.toString() == chainName) {
            chainNameTmp = "Bsc"
        }
        return try {
            val clazz1 =
                Class.forName("com.particle.base." + chainNameTmp + "Chain")
            val cons =
                clazz1.getConstructor(String::class.java)
            cons.newInstance(chainIdName) as ChainInfo
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
            throw RuntimeException(e.message)
        }
    }
}