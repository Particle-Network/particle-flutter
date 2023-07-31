package network.particle.auth_flutter.bridge.module

import android.app.Activity
import android.text.TextUtils
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.reflect.TypeToken
import com.particle.base.CurrencyEnum
import com.particle.base.Env
import com.particle.base.LanguageEnum
import com.particle.base.ParticleNetwork
import com.particle.base.ParticleNetwork.setFiatCoin
import com.particle.base.ThemeEnum
import com.particle.base.data.ErrorInfo
import com.particle.base.data.SignOutput
import com.particle.base.data.WebOutput
import com.particle.base.data.WebServiceCallback
import com.particle.base.ibiconomy.FeeMode
import com.particle.base.ibiconomy.FeeModeAuto
import com.particle.base.ibiconomy.FeeModeCustom
import com.particle.base.ibiconomy.FeeModeGasless
import com.particle.base.ibiconomy.MessageSigner
import com.particle.base.model.LoginType
import com.particle.base.model.ResultCallback
import com.particle.base.model.SecurityAccountConfig
import com.particle.base.model.SupportAuthType
import com.particle.base.model.UserInfo
import com.particle.network.ParticleNetworkAuth.fastLogout
import com.particle.network.ParticleNetworkAuth.getAddress
import com.particle.network.ParticleNetworkAuth.getSecurityAccount
import com.particle.network.ParticleNetworkAuth.getUserInfo
import com.particle.network.ParticleNetworkAuth.isLogin
import com.particle.network.ParticleNetworkAuth.isLoginAsync
import com.particle.network.ParticleNetworkAuth.login
import com.particle.network.ParticleNetworkAuth.logout
import com.particle.network.ParticleNetworkAuth.openAccountAndSecurity
import com.particle.network.ParticleNetworkAuth.openWebWallet
import com.particle.network.ParticleNetworkAuth.setWebAuthConfig
import com.particle.network.ParticleNetworkAuth.signAllTransactions
import com.particle.network.ParticleNetworkAuth.signAndSendTransaction
import com.particle.network.ParticleNetworkAuth.signMessage
import com.particle.network.ParticleNetworkAuth.signMessageUnique
import com.particle.network.ParticleNetworkAuth.signTransaction
import com.particle.network.ParticleNetworkAuth.signTypedData
import com.particle.network.SignTypedDataVersion
import com.particle.network.service.*
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import network.particle.auth_flutter.bridge.model.*
import network.particle.auth_flutter.bridge.utils.ChainUtils
import network.particle.auth_flutter.bridge.utils.EncodeUtils
import network.particle.chains.ChainInfo
import org.json.JSONObject


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
        val chainInfo = ChainUtils.getChainInfo(initData.chainId)
        ParticleNetwork.init(activity, Env.valueOf(initData.env!!.uppercase()), chainInfo)
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
        if (loginData.supportAuthTypeValues!!.contains("all")) {
            supportAuthType = SupportAuthType.ALL.value
        } else {
            for (i in 0 until loginData.supportAuthTypeValues!!.size) {
                try {
                    val supportType = loginData.supportAuthTypeValues!![i]
                    val authType = SupportAuthType.valueOf(supportType.uppercase())
                    supportAuthType = supportAuthType or authType.value
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
        var prompt: LoginPrompt? = null
        try {
            if (loginData.prompt != null) prompt = LoginPrompt.valueOf(loginData.prompt!!)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        ParticleNetwork.login(
            LoginType.valueOf(loginData.loginType!!.uppercase()),
            account!!,
            supportAuthType,
            prompt,
            object : WebServiceCallback<UserInfo> {
                override fun success(output: UserInfo) {
                    result.success(FlutterCallBack.success(output).toGson())
                }

                override fun failure(errMsg: ErrorInfo) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

            }, loginData.authorization
        )
    }

    fun logout(result: MethodChannel.Result) {
        LogUtils.d("logout")
        ParticleNetwork.logout(object : WebServiceCallback<WebOutput> {

            override fun success(output: WebOutput) {
                result.success(FlutterCallBack.success(output).toGson())
            }

            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }
        })
    }

    fun fastLogout(result: MethodChannel.Result) {
        LogUtils.d("fastLogout")
        ParticleNetwork.fastLogout(object : ResultCallback {
            override fun failure() {
                result.success(FlutterCallBack.failed("failed").toGson())
            }

            override fun success() {
                result.success(FlutterCallBack.success("success").toGson())
            }

        })
    }

    fun signMessage(message: String, result: MethodChannel.Result) {
        ParticleNetwork.signMessage(message,
            object : WebServiceCallback<SignOutput> {

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }

                override fun failure(errMsg: ErrorInfo) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }
            })
    }

    fun signMessageUnique(message: String, result: MethodChannel.Result) {
        ParticleNetwork.signMessageUnique(message,
            object : WebServiceCallback<SignOutput> {

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }

                override fun failure(errMsg: ErrorInfo) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }
            })
    }

    fun signTransaction(transaction: String, result: MethodChannel.Result) {
        LogUtils.d("signTransaction", transaction)
        ParticleNetwork.signTransaction(transaction, object : WebServiceCallback<SignOutput> {

            override fun success(output: SignOutput) {
                result.success(FlutterCallBack.success(output.signature).toGson())
            }

            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }
        })
    }

    fun signAllTransactions(transactions: String, result: MethodChannel.Result) {
        LogUtils.d("signAllTransactions", transactions)
        val trans = GsonUtils.fromJson<List<String>>(
            transactions, object : TypeToken<List<String>>() {}.type
        )
        ParticleNetwork.signAllTransactions(trans, object : WebServiceCallback<SignOutput> {

            override fun success(output: SignOutput) {
                result.success(FlutterCallBack.success(output.signature).toGson())
            }

            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }
        })
    }

    fun batchSendTransactions(transactions: String, result: MethodChannel.Result) {
        LogUtils.d("batchSendTransactions", transactions)
        val transParams =
            GsonUtils.fromJson<TransactionsParams>(transactions, TransactionsParams::class.java)

        var feeMode: FeeMode = FeeModeAuto()
        if (transParams.feeMode != null) {
            val option = transParams.feeMode.option
            if (option == "custom") {
                val feeQuote = transParams.feeMode.feeQuote!!
                feeMode = FeeModeCustom(feeQuote)
            } else if (option == "gasless") {
                feeMode = FeeModeGasless()
            } else {
                feeMode = FeeModeAuto()
            }
        }
        CoroutineScope(Dispatchers.IO).launch {
            try {
                ParticleNetwork.getBiconomyService().quickSendTransaction(
                    transParams.transactions,
                    feeMode,
                    object : MessageSigner {
                        override fun signTypedData(
                            message: String,
                            callback: WebServiceCallback<SignOutput>
                        ) {

                            ParticleNetwork.signTypedData(
                                message,
                                SignTypedDataVersion.V4,
                                object : WebServiceCallback<SignOutput> {
                                    override fun success(output: SignOutput) {
                                        callback.success(output)
                                    }

                                    override fun failure(errMsg: ErrorInfo) {
                                        callback.failure(errMsg)
                                    }
                                })
                        }

                        override fun signMessage(
                            message: String,
                            callback: WebServiceCallback<SignOutput>
                        ) {
                            ParticleNetwork.signMessage(
                                message,
                                object : WebServiceCallback<SignOutput> {
                                    override fun success(output: SignOutput) {
                                        callback.success(output)
                                    }

                                    override fun failure(errMsg: ErrorInfo) {
                                        callback.failure(errMsg)
                                    }
                                })
                        }

                        override fun eoaAddress(): String {
                            return ParticleNetwork.getAddress()
                        }

                    },
                    object : WebServiceCallback<SignOutput> {
                        override fun success(output: SignOutput) {
                            result.success(FlutterCallBack.success(output.signature!!).toGson())
                        }

                        override fun failure(errMsg: ErrorInfo) {
                            result.success(FlutterCallBack.failed(errMsg).toGson())
                        }

                    })
            } catch (e: Exception) {
                e.printStackTrace()
                result.success(FlutterCallBack.failed("failed").toGson())
            }
        }
    }

    fun signAndSendTransaction(transactionParams: String, result: MethodChannel.Result) {
        LogUtils.d("signAndSendTransaction", transactionParams)
        val transParams =
            GsonUtils.fromJson<TransactionParams>(transactionParams, TransactionParams::class.java)
        var feeMode: FeeMode = FeeModeAuto()
        if (transParams.feeMode != null) {
            val option = transParams.feeMode.option
            if (option == "custom") {
                val feeQuote = transParams.feeMode.feeQuote!!
                feeMode = FeeModeCustom(feeQuote)
            } else if (option == "gasless") {
                feeMode = FeeModeGasless()
            } else {
                feeMode = FeeModeAuto()
            }
        }
        try {
            ParticleNetwork.signAndSendTransaction(
                transParams.transaction,
                object : WebServiceCallback<SignOutput> {

                    override fun success(output: SignOutput) {
                        result.success(FlutterCallBack.success(output.signature).toGson())
                    }

                    override fun failure(errMsg: ErrorInfo) {
                        result.success(FlutterCallBack.failed(errMsg).toGson())
                    }

                },
                feeMode
            )
        } catch (e: Exception) {
            result.success(FlutterCallBack.failed(e.message).toGson())
        }
    }

    fun signTypedData(json: String, result: MethodChannel.Result) {
        LogUtils.d("SignTypedData", json)
        val signTypedData = GsonUtils.fromJson(
            json, SignTypedData::class.java
        )
        val typedDataVersion =
            if (signTypedData.version.equals("v4Unique")) SignTypedDataVersion.V4Unique
            else SignTypedDataVersion.valueOf(signTypedData.version!!.uppercase())
        ParticleNetwork.signTypedData(signTypedData.message!!,
            typedDataVersion,
            object : WebServiceCallback<SignOutput> {

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }

                override fun failure(errMsg: ErrorInfo) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }
            })
    }


    fun setChainInfo(chainParams: String, result: MethodChannel.Result) {
        LogUtils.d("setChainName", chainParams)
        val chainData: ChainData = GsonUtils.fromJson(
            chainParams, ChainData::class.java
        )
        try {
            val chainInfo = ChainUtils.getChainInfo(chainData.chainId)
            ParticleNetwork.setChainInfo(chainInfo)
            result.success(true)
        } catch (e: Exception) {
            LogUtils.e("setChainName", e.message)
            result.success(false)
        }
    }

    fun setChainInfoAsync(chainParams: String, result: MethodChannel.Result) {
        LogUtils.d("setChainName", chainParams)
        val chainData = GsonUtils.fromJson(
            chainParams, ChainData::class.java
        )
        val chainInfo = ChainUtils.getChainInfo(chainData.chainId)
        ParticleNetwork.setChainInfo(chainInfo)
    }

    fun getAddress(result: MethodChannel.Result) {
        val address = ParticleNetwork.getAddress()
        result.success(address)
    }

    fun getUserInfo(result: MethodChannel.Result) {
        val address = ParticleNetwork.getUserInfo()
        result.success(Gson().toJson(address))
    }

    fun getChainInfo(result: MethodChannel.Result) {
        val chainInfo: ChainInfo = ParticleNetwork.chainInfo
        val map: MutableMap<String, Any> = HashMap()
        map["chain_name"] = chainInfo.name
        map["chain_id"] = chainInfo.id
        result.success(Gson().toJson(map))
    }

    fun setSecurityAccountConfig(configJson: String) {
        LogUtils.d("setSecurityAccountConfig", configJson)
        try {
            val jobj = JSONObject(configJson)
            val promptSettingWhenSign = jobj.getInt("prompt_setting_when_sign")
            val promptMasterPasswordSettingWhenLogin =
                jobj.getInt("prompt_master_password_setting_when_login")
            val config = SecurityAccountConfig(
                promptSettingWhenSign, promptMasterPasswordSettingWhenLogin
            )
            ParticleNetwork.setSecurityAccountConfig(config)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun setLanguage(language: String) {
        LogUtils.d("setLanguage", language)
        if (language.isEmpty()) {
            return
        }
        if (language.equals("zh_hans")) {
            ParticleNetwork.setLanguage(LanguageEnum.ZH_CN)
        } else if (language.equals("zh_hant")) {
            ParticleNetwork.setLanguage(LanguageEnum.ZH_TW)
        } else if (language.equals("ja")) {
            ParticleNetwork.setLanguage(LanguageEnum.JA)
        } else if (language.equals("ko")) {
            ParticleNetwork.setLanguage(LanguageEnum.KO)
        } else {
            ParticleNetwork.setLanguage(LanguageEnum.EN)
        }
    }

    fun openAccountAndSecurity() {
        ParticleNetwork.openAccountAndSecurity(object : WebServiceCallback<WebOutput> {
            override fun failure(errMsg: ErrorInfo) {
            }

            override fun success(output: WebOutput) {
            }

        })
    }

    fun isLogin(result: MethodChannel.Result) {
        result.success(
            ParticleNetwork.isLogin()
        )
    }

    fun getSecurityAccount(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            val securityAccount = ParticleNetwork.getSecurityAccount()
            result.success(FlutterCallBack.success(securityAccount).toGson())
        }
    }

    fun openWebWallet(activity: Activity, json: String, result: MethodChannel.Result) {
        ParticleNetwork.openWebWallet(activity, json)
    }

    fun setWebAuthConfig(activity: Activity, json: String, result: MethodChannel.Result) {
        val jobj = GsonUtils.fromJson(json, JsonObject::class.java)
        val displayWallet = jobj.get("display_wallet").asBoolean
        val appearance = jobj.get("appearance").asString
        LogUtils.d("setWebAuthConfig", "displayWallet:$displayWallet,appearance:$appearance")
        ParticleNetwork.setWebAuthConfig(displayWallet, ThemeEnum.valueOf(appearance.uppercase()))
    }

    fun setAppearance(appearance: String) {
        ParticleNetwork.setAppearence(ThemeEnum.valueOf(appearance.uppercase()))
    }  fun setFiatCoin(fiatCoin: String) {
        ParticleNetwork.setFiatCoin(CurrencyEnum.valueOf(fiatCoin.uppercase()))
    }

    fun isLoginAsync(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val userInfo = ParticleNetwork.isLoginAsync()
                if (userInfo != null) {
                    result.success(FlutterCallBack.success(userInfo).toGson())
                } else {
                    result.success(FlutterCallBack.failed("failed").toGson())
                }
            } catch (e: Exception) {
                result.success(FlutterCallBack.failed("failed").toGson())
            }
        }
    }
}