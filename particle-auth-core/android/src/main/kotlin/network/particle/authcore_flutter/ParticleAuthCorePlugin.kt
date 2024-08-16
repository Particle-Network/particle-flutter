package network.particle.authcore_flutter;


import android.app.Activity
import android.os.Handler
import android.os.Looper
import com.particle.auth.AuthCore
import com.particle.auth.data.MasterPwdServiceCallback
import com.particle.base.data.ErrorInfo
import network.particle.authcore_flutter.AuthCoreBridge

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import network.particle.base_flutter.model.FlutterCallBack


/** ParticleAuthCorePlugin */
class ParticleAuthCorePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    private var channel: MethodChannel? = null

    init {
        instance = this
    }

    companion object {
        @JvmStatic
        lateinit var instance: ParticleAuthCorePlugin
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "auth_core_bridge")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }
    private val mainHandler = Handler(Looper.getMainLooper())
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                mainHandler.post {
                    val isConnected = AuthCore.isConnected()
                    result.success(isConnected)
                }
            }
            "connect" -> {
                AuthCoreBridge.connect(call.arguments as String, result)
            }
            "disconnect" -> {
                AuthCoreBridge.disconnect(result)
            }
            "isConnected" -> {
                AuthCoreBridge.isConnected(result)
            }
            "getUserInfo" -> {
                AuthCoreBridge.getUserInfo(result)
            }
            "switchChain" -> {
                AuthCoreBridge.switchChain(call.arguments as String, result)
            }
            "changeMasterPassword" -> {
                if (AuthCore.hasMasterPassword()) {
                    AuthCore.changeMasterPassword(object : MasterPwdServiceCallback {
                        override fun failure(errMsg: ErrorInfo) {
                            try {
                                result.success(FlutterCallBack.failed(errMsg).toGson())
                            } catch (_: Exception) {

                            }
                        }

                        override fun success() {
                            try {
                                result.success(FlutterCallBack.success(true).toGson())

                            } catch (_: Exception) {

                            }
                        }
                    })
                }else{
                    AuthCore.setMasterPassword(object : MasterPwdServiceCallback {
                        override fun failure(errMsg: ErrorInfo) {
                            try {
                                result.success(FlutterCallBack.failed(errMsg).toGson())
                            } catch (_: Exception) {

                            }
                        }

                        override fun success() {
                            try {
                                result.success(FlutterCallBack.success(true).toGson())
                            } catch (_: Exception) {

                            }

                        }
                    })
                }
            }
            "hasMasterPassword" -> {
                AuthCoreBridge.hasMasterPassword(result)
            }
            "hasPaymentPassword" -> {
                AuthCoreBridge.hasPaymentPassword(result)
            }
            "openAccountAndSecurity" -> {
                activity?.apply {
                    AuthCoreBridge.openAccountAndSecurity(this, result)
                }
            }
            "evmGetAddress" -> {
                AuthCoreBridge.evmGetAddress(result)
            }
            "evmPersonalSign" -> {
                AuthCoreBridge.evmPersonalSign(call.arguments as String, result)
            }
            "evmPersonalSignUnique" -> {
                AuthCoreBridge.evmPersonalSignUnique(call.arguments as String, result)
            }
            "evmSignTypedData" -> {
                AuthCoreBridge.evmSignTypedData(call.arguments as String, result)
            }
            "evmSignTypedDataUnique" -> {
                AuthCoreBridge.evmSignTypedDataUnique(call.arguments as String, result)
            }
            "evmSendTransaction" -> {
                AuthCoreBridge.sendTransaction(call.arguments as String, result)
            }
            "evmBatchSendTransactions" -> {
                AuthCoreBridge.batchSendTransactions(call.arguments as String, result)
            }
            "solanaGetAddress" -> {
                AuthCoreBridge.solanaGetAddress(result)
            }
            "solanaSignMessage" -> {
                AuthCoreBridge.solanaSignMessage(call.arguments as String, result)
            }
            "solanaSignTransaction" -> {
                AuthCoreBridge.signTransaction(call.arguments as String, result)
            }
            "solanaSignAllTransactions" -> {
                AuthCoreBridge.signAllTransaction(call.arguments as String, result)
            }
            "solanaSignAndSendTransaction" -> {
                AuthCoreBridge.solanaSignAndSendTransaction(call.arguments as String, result)
            }

            "setBlindEnable" -> {
                AuthCoreBridge.setBlindEnable(call.arguments as Boolean, result)
            }

            "getBlindEnable" -> {
                AuthCoreBridge.getBlindEnable(result)
            }

            "sendEmailCode"->{
                AuthCoreBridge.sendEmailCode(call.arguments as String, result)
            }
            "sendPhoneCode"->{
                AuthCoreBridge.sendPhoneCode(call.arguments as String, result)
            }
            "connectWithCode"->{
                AuthCoreBridge.connectWithCode(call.arguments as String, result)
            }
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        //nothing to do
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    /**
     * 客户端回调Flutter
     */
    private fun nativeCallFlutter(method: String, arguments: Any) {
        if (channel != null && activity != null) {
            activity?.runOnUiThread(Runnable {
                channel?.invokeMethod(
                    method,
                    arguments
                )
            })
        }
    }
}
