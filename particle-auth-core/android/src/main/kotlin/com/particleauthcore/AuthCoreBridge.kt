package com.particleauthcore

import android.app.Activity
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.google.gson.reflect.TypeToken
import com.particle.auth.AuthCore
import com.particle.auth.data.AuthCoreServiceCallback
import com.particle.auth.data.AuthCoreSignCallback
import com.particle.auth.data.MasterPwdServiceCallback
import com.particle.base.data.ErrorInfo
import com.particle.base.data.SignAllOutput
import com.particle.base.data.SignOutput
import com.particle.base.model.LoginPageConfig
import com.particle.base.model.LoginType
import com.particle.base.model.ResultCallback
import com.particle.base.model.SupportLoginType
import com.particle.base.model.UserInfo
import com.particleauthcore.module.ChainData
import com.particleauthcore.module.ConnectData
import com.particleauthcore.utils.ChainUtils
import com.particleauthcore.utils.MessageProcess
import io.flutter.plugin.common.MethodChannel
import network.particle.auth_flutter.bridge.model.FlutterCallBack


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


    fun sendTransaction(transaction: String, result: MethodChannel.Result) {
        AuthCore.evm.sendTransaction(transaction, object : AuthCoreSignCallback<SignOutput> {
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

}
