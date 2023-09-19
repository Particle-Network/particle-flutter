package com.particleauthcore

import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.google.gson.reflect.TypeToken
import com.particle.auth.AuthCore
import com.particle.auth.data.AuthCoreServiceCallback
import com.particle.auth.data.AuthCoreSignCallback
import com.particle.auth.data.MasterPwdServiceCallback
import com.particle.base.data.ErrorInfo
import com.particle.base.data.SignAllOutput
import com.particle.base.data.SignOutput
import com.particle.base.model.ResultCallback
import com.particle.base.model.UserInfo
import com.particleauthcore.model.ChainData
import com.particleauthcore.model.ReactCallBack
import com.particleauthcore.utils.ChainUtils
import com.particleauthcore.utils.MessageProcess

class ParticleAuthCoreModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  fun multiply(a: Double, b: Double, promise: Promise) {
    promise.resolve(a * b)
  }

  @ReactMethod
  fun connect(jwt: String, callback: Callback) {
    AuthCore.connect(jwt, object : AuthCoreServiceCallback<UserInfo> {
      override fun success(output: UserInfo) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }

      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }
    })
  }

  @ReactMethod
  fun disconnect(callback: Callback) {
    AuthCore.disconnect(object : ResultCallback {
      override fun failure() {
        callback.invoke(ReactCallBack.success("success").toGson())
      }

      override fun success() {
        callback.invoke(ReactCallBack.failed("failed").toGson())
      }
    })
  }

  @ReactMethod
  fun isConnected(callback: Callback) {
    callback.invoke(AuthCore.isConnected())
  }

  @ReactMethod
  fun getUserInfo(promise: Promise) {
    val userInfo = AuthCore.getUserInfo()
    promise.resolve(GsonUtils.toJson(userInfo))
  }

  @ReactMethod
  fun switchChain(chainInfo: String, callback: Callback) {
    val chainData: ChainData = GsonUtils.fromJson(
      chainInfo, ChainData::class.java
    )
    val chainInfo = ChainUtils.getChainInfo(chainData.chainId)
    AuthCore.switchChain(chainInfo, object : ResultCallback {
      override fun failure() {
        callback.invoke(false)
      }

      override fun success() {
        callback.invoke(true)
      }
    })
  }

  @ReactMethod
  fun changeMasterPassword(callback: Callback) {
    AuthCore.changeMasterPassword(object : MasterPwdServiceCallback {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success() {
        callback.invoke(ReactCallBack.success("success").toGson())
      }
    })
  }

  @ReactMethod
  fun hasMasterPassword(callback: Callback) {
    val hasMasterPassword = AuthCore.hasMasterPassword()
    if (hasMasterPassword) {
      callback.invoke(ReactCallBack.success(true).toGson())
    } else {
      callback.invoke(ReactCallBack.failed(false).toGson())
    }
  }

  @ReactMethod
  fun hasPaymentPassword(callback: Callback) {
    val hasPaymentPassword = AuthCore.hasPaymentPassword()
    if (hasPaymentPassword) {
      callback.invoke(ReactCallBack.success(true).toGson())
    } else {
      callback.invoke(ReactCallBack.failed(false).toGson())
    }
  }

  @ReactMethod
  fun openAccountAndSecurity(callback: Callback) {
    currentActivity?.apply {
      runOnUiThread(Runnable {
        AuthCore.openAccountAndSecurity(this)
      })
    }
    callback.invoke(ReactCallBack.success("success").toGson())
  }

  @ReactMethod
  fun openWebWallet(customJson: String?) {

  }

  @ReactMethod
  fun openAccountAndSecurity() {

  }


  //evm
  @ReactMethod
  fun evmGetAddress(promise: Promise) {
    promise.resolve(AuthCore.evm.getAddress())
  }

  @ReactMethod
  fun evmPersonalSign(serializedMessage: String, callback: Callback) {
    AuthCore.evm.personalSign(serializedMessage, object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }

  @ReactMethod
  fun evmPersonalSignUnique(serializedMessage: String, callback: Callback) {
    AuthCore.evm.personalSignUnique(serializedMessage, object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }

  @ReactMethod
  fun evmSignTypedData(message: String, callback: Callback) {
    AuthCore.evm.signTypedData(message, object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }

  @ReactMethod
  fun evmSignTypedDataUnique(message: String, callback: Callback) {
    AuthCore.evm.signTypedDataUnique(message, object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }

  @ReactMethod
  fun sendTransaction(transaction: String, callback: Callback) {
    AuthCore.evm.sendTransaction(transaction, object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }
  //solana

  @ReactMethod
  fun solanaGetAddress(promise: Promise) {
    promise.resolve(AuthCore.solana.getAddress())
  }

  @ReactMethod
  fun solanaSignMessage(message: String, callback: Callback) {
    AuthCore.solana.signMessage(MessageProcess.start(message) , object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }

  @ReactMethod
  fun signTransaction(transaction: String, callback: Callback) {
    AuthCore.solana.signTransaction(transaction, object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }

  @ReactMethod
  fun signAllTransaction(transactions: String, callback: Callback) {
    LogUtils.d("signAllTransactions", transactions)
    val trans = GsonUtils.fromJson<List<String>>(
      transactions,
      object : TypeToken<List<String>>() {}.type
    )
    AuthCore.solana.signAllTransactions(trans, object : AuthCoreSignCallback<SignAllOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignAllOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })

  }

  @ReactMethod
  fun solanaSignAndSendTransaction(transaction: String, callback: Callback) {
    AuthCore.solana.signAndSendTransaction(transaction, object : AuthCoreSignCallback<SignOutput> {
      override fun failure(errMsg: ErrorInfo) {
        callback.invoke(ReactCallBack.failed(errMsg).toGson())
      }

      override fun success(output: SignOutput) {
        callback.invoke(ReactCallBack.success(output).toGson())
      }
    })
  }

  companion object {
    const val NAME = "ParticleAuthCorePlugin"
  }

}
