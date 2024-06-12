package network.particle.authcore_flutter;

import android.app.Activity
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.google.gson.reflect.TypeToken
import com.particle.auth.AuthCore
import com.particle.auth.data.AuthCoreServiceCallback
import com.particle.auth.data.AuthCoreSignCallback
import com.particle.auth.data.MasterPwdServiceCallback
import com.particle.base.ParticleNetwork
import com.particle.base.data.ErrorInfo
import com.particle.base.data.SignAllOutput
import com.particle.base.data.SignOutput
import com.particle.base.data.WebServiceCallback
import com.particle.base.iaa.FeeMode
import com.particle.base.iaa.FeeModeGasless
import com.particle.base.iaa.FeeModeNative
import com.particle.base.iaa.FeeModeToken
import com.particle.base.iaa.MessageSigner
import com.particle.base.model.LoginPageConfig
import com.particle.base.model.LoginType
import com.particle.base.model.ResultCallback
import com.particle.base.model.SupportLoginType
import com.particle.base.model.UserInfo
import com.particle.base.utils.ChainUtils
import com.particle.base.utils.MessageProcess

import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import network.particle.base_flutter.model.ChainData
import network.particle.authcore_flutter.module.ConnectData
import network.particle.base_flutter.model.TransactionParams
import network.particle.base_flutter.model.TransactionsParams
import network.particle.base_flutter.model.FlutterCallBack
object AuthCoreBridge {

    private val failed = ErrorInfo("failed", 100000)
    fun connect(loginJson: String, result: MethodChannel.Result) {
        LogUtils.d("connect", loginJson)
        val loginData = GsonUtils.fromJson(loginJson, ConnectData::class.java);
        val loginType = LoginType.valueOf(loginData.loginType.uppercase())
        val account = loginData.account ?: ""
        val prompt = loginData.prompt
        val loginPageConfig = loginData.loginPageConfig
        val supportLoginTypes: List<SupportLoginType> = loginData.supportLoginTypes?.map {
            SupportLoginType.valueOf(it.uppercase())
        } ?: emptyList()
        LogUtils.d("connect", loginType, account, supportLoginTypes, prompt, loginPageConfig)
        try {
            AuthCore.connect(
                loginType,
                account,
                supportLoginTypes,
                prompt,
                loginPageConfig = loginPageConfig,
                object : AuthCoreServiceCallback<UserInfo> {
                    override fun success(output: UserInfo) {
                        try {
                            result.success(FlutterCallBack.success(output).toGson())
                        } catch (_: Exception) {

                        }
                    }

                    override fun failure(errMsg: ErrorInfo) {
                        result.success(FlutterCallBack.failed(errMsg).toGson())
                    }
                })
        } catch (e: Exception) {
            result.success(FlutterCallBack.failed(ErrorInfo(e.message ?: "", 100000)).toGson())
        }

    }


    fun disconnect(result: MethodChannel.Result) {
        AuthCore.disconnect(object : ResultCallback {
            override fun failure() {
                result.success(FlutterCallBack.failed(failed).toGson())
            }

            override fun success() {
                result.success(FlutterCallBack.success("success").toGson())
            }
        })
    }


    fun isConnected(result: MethodChannel.Result) {
        result.success(FlutterCallBack.success(AuthCore.isConnected()).toGson())
    }


    fun getUserInfo(result: MethodChannel.Result) {
        val userInfo = AuthCore.getUserInfo()
        result.success(GsonUtils.toJson(userInfo))
    }


    fun switchChain(chainInfo: String, result: MethodChannel.Result) {
        val chainData: ChainData = GsonUtils.fromJson(
            chainInfo, ChainData::class.java
        )
        val chainInfo = ChainUtils.getChainInfo(chainData.chainId)
        AuthCore.switchChain(chainInfo, object : ResultCallback {
            override fun failure() {
                result.success(false)
            }

            override fun success() {
                result.success(true)
            }
        })
    }


    fun changeMasterPassword(result: MethodChannel.Result) {
        AuthCore.changeMasterPassword(object : MasterPwdServiceCallback {
            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success() {
                result.success(FlutterCallBack.success(true).toGson())
            }
        })
    }


    fun hasMasterPassword(result: MethodChannel.Result) {
        val hasMasterPassword = AuthCore.hasMasterPassword()
        if (hasMasterPassword) {
            result.success(FlutterCallBack.success(true).toGson())
        } else {
            result.success(FlutterCallBack.success(false).toGson())
        }
    }


    fun hasPaymentPassword(result: MethodChannel.Result) {
        val hasPaymentPassword = AuthCore.hasPaymentPassword()
        if (hasPaymentPassword) {
            result.success(FlutterCallBack.success(true).toGson())
        } else {
            result.success(FlutterCallBack.success(false).toGson())
        }
    }


    fun openAccountAndSecurity(activity: Activity, result: MethodChannel.Result) {
        activity?.apply {
            runOnUiThread(Runnable {
                AuthCore.openAccountAndSecurity(this)
            })
        }
        result.success(FlutterCallBack.success("success").toGson())
    }


    fun openAccountAndSecurity() {

    }


    //evm
    fun evmGetAddress(result: MethodChannel.Result) {
        result.success(AuthCore.evm.getAddress())
    }


    fun evmPersonalSign(serializedMessage: String, result: MethodChannel.Result) {
        AuthCore.evm.personalSign(serializedMessage, object : AuthCoreSignCallback<SignOutput> {
            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success(output: SignOutput) {
                result.success(FlutterCallBack.success(output.signature).toGson())
            }
        })
    }


    fun evmPersonalSignUnique(serializedMessage: String, result: MethodChannel.Result) {
        AuthCore.evm.personalSignUnique(serializedMessage,
            object : AuthCoreSignCallback<SignOutput> {
                override fun failure(errMsg: ErrorInfo) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }
            })
    }


    fun evmSignTypedData(message: String, result: MethodChannel.Result) {
        AuthCore.evm.signTypedData(message, object : AuthCoreSignCallback<SignOutput> {
            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success(output: SignOutput) {
                result.success(FlutterCallBack.success(output.signature).toGson())
            }
        })
    }


    fun evmSignTypedDataUnique(message: String, result: MethodChannel.Result) {
        AuthCore.evm.signTypedDataUnique(message, object : AuthCoreSignCallback<SignOutput> {
            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success(output: SignOutput) {
                result.success(FlutterCallBack.success(output.signature).toGson())
            }
        })
    }



    //solana


    fun solanaGetAddress(result: MethodChannel.Result) {
        result.success(AuthCore.solana.getAddress())
    }


    fun solanaSignMessage(message: String, result: MethodChannel.Result) {
        AuthCore.solana.signMessage(
            MessageProcess.start(message),
            object : AuthCoreSignCallback<SignOutput> {
                override fun failure(errMsg: ErrorInfo) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }
            })
    }


    fun signTransaction(transaction: String, result: MethodChannel.Result) {
        AuthCore.solana.signTransaction(transaction, object : AuthCoreSignCallback<SignOutput> {
            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success(output: SignOutput) {
                result.success(FlutterCallBack.success(output.signature).toGson())
            }
        })
    }


    fun signAllTransaction(transactions: String, result: MethodChannel.Result) {
        LogUtils.d("signAllTransactions", transactions)
        val trans = GsonUtils.fromJson<List<String>>(
            transactions, object : TypeToken<List<String>>() {}.type
        )
        AuthCore.solana.signAllTransactions(trans, object : AuthCoreSignCallback<SignAllOutput> {
            override fun failure(errMsg: ErrorInfo) {
                result.success(FlutterCallBack.failed(errMsg).toGson())
            }

            override fun success(output: SignAllOutput) {
                result.success(FlutterCallBack.success(output.signatures).toGson())
            }
        })

    }


    fun solanaSignAndSendTransaction(transaction: String, result: MethodChannel.Result) {
        AuthCore.solana.signAndSendTransaction(transaction,
            object : AuthCoreSignCallback<SignOutput> {
                override fun failure(errMsg: ErrorInfo) {
                    result.success(FlutterCallBack.failed(errMsg).toGson())
                }

                override fun success(output: SignOutput) {
                    result.success(FlutterCallBack.success(output.signature).toGson())
                }
            })
    }

    fun setBlindEnable(enable: Boolean, result: MethodChannel.Result) {
        AuthCore.setBlindEnable(enable)
    }

    fun getBlindEnable(result: MethodChannel.Result) {
        result.success(AuthCore.getBlindEnable())
    }

    fun sendTransaction(transactionParams: String, result: MethodChannel.Result) {
        LogUtils.d("signAndSendTransaction", transactionParams)
        val transParams =
            GsonUtils.fromJson<TransactionParams>(transactionParams, network.particle.base_flutter.model.TransactionParams::class.java)
        var feeMode: FeeMode = FeeModeNative()
        if (transParams.feeMode != null) {
            val option = transParams!!.feeMode!!.option
            if (option == "token") {
                val tokenPaymasterAddress = transParams!!.feeMode!!.tokenPaymasterAddress
                val feeQuote = transParams.feeMode!!.feeQuote!!
                feeMode = FeeModeToken(feeQuote, tokenPaymasterAddress!!)
            } else if (option == "gasless") {
                val verifyingPaymasterGasless =
                    transParams.feeMode!!.wholeFeeQuote.verifyingPaymasterGasless
                feeMode = FeeModeGasless(verifyingPaymasterGasless)
            } else if (option == "native") {
                val verifyingPaymasterNative =
                    transParams.feeMode!!.wholeFeeQuote.verifyingPaymasterNative
                feeMode = FeeModeNative(verifyingPaymasterNative)
            }
        }
        try {
            AuthCore.evm.sendTransaction(
                transParams.transaction,
                object : AuthCoreSignCallback<SignOutput> {

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

    fun batchSendTransactions(transactions: String, result: MethodChannel.Result) {
        LogUtils.d("batchSendTransactions", transactions)
        val transParams =
            GsonUtils.fromJson<TransactionsParams>(transactions, TransactionsParams::class.java)
        var feeMode: FeeMode = FeeModeNative()
        if (transParams.feeMode != null && ParticleNetwork.isAAModeEnable()) {
            when (transParams.feeMode!!.option) {
                "token" -> {
                    val tokenPaymasterAddress = transParams.feeMode!!.tokenPaymasterAddress
                    val feeQuote = transParams.feeMode!!.feeQuote!!
                    feeMode = FeeModeToken(feeQuote, tokenPaymasterAddress!!)
                }
                "gasless" -> {
                    val verifyingPaymasterGasless =
                        transParams.feeMode!!.wholeFeeQuote.verifyingPaymasterGasless
                    feeMode = FeeModeGasless(verifyingPaymasterGasless)
                }
                "native" -> {
                    val verifyingPaymasterNative =
                        transParams.feeMode!!.wholeFeeQuote.verifyingPaymasterNative
                    feeMode = FeeModeNative(verifyingPaymasterNative)
                }
            }
        }
        CoroutineScope(Dispatchers.IO).launch {
            try {
                ParticleNetwork.getAAService().quickSendTransaction(
                    transParams.transactions,
                    feeMode,
                    object : MessageSigner {
                        override fun signMessage(
                            message: String,
                            callback: WebServiceCallback<SignOutput>,
                            chainId: Long?
                        ) {
                            AuthCore.evm.personalSign(
                                message,
                                object : AuthCoreSignCallback<SignOutput> {
                                    override fun success(output: SignOutput) {
                                        callback.success(output)
                                    }

                                    override fun failure(errMsg: ErrorInfo) {
                                        callback.failure(errMsg)
                                    }
                                })
                        }

                        override fun eoaAddress(): String {
                            return AuthCore.evm.getAddress()!!
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


}
