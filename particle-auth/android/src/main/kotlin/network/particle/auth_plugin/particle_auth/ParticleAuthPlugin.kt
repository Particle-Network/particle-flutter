package network.particle.auth_plugin.particle_auth

import android.app.Activity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import network.particle.auth_flutter.bridge.module.AuthBridge

/** ParticleAuthPlugin */
class ParticleAuthPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    private var channel: MethodChannel? = null

    init {
        instance = this
    }

    companion object {
        @JvmStatic
        lateinit var instance: ParticleAuthPlugin
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "auth_bridge")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                AuthBridge.init(activity!!, call.arguments as String)
            }
            "login" -> {
                AuthBridge.login(call.arguments as String, result)
            }
            "logout" -> {
                AuthBridge.logout(result)
            }
            "getAddress" -> {
                AuthBridge.getAddress(result)
            }
            "signMessage" -> {
                AuthBridge.signMessage(call.arguments as String, result)
            }
            "signTransaction" -> {
                AuthBridge.signTransaction(call.arguments as String, result)
            }
            "signAllTransactions" -> {
                AuthBridge.signAllTransactions(call.arguments as String, result)
            }
            "signAndSendTransaction" -> {
                AuthBridge.signAndSendTransaction(call.arguments as String, result)
            }
            "signTypedData" -> {
                AuthBridge.signTypedData(call.arguments as String, result)
            }
            "setChainInfo" -> {
                AuthBridge.setChainInfo(call.arguments as String, result)
            }
            "setChainInfoAsync" -> {
                AuthBridge.setChainInfoAsync(call.arguments as String, result)
            }
            "getChainInfo" -> {
                AuthBridge.getChainInfo(result)
            }
            "getUserInfo" -> {
                AuthBridge.getUserInfo(result)
            }
            "setSecurityAccountConfig" -> {
                AuthBridge.setSecurityAccountConfig(call.arguments as String)
            }
            "setLanguage" -> {
                AuthBridge.setLanguage(call.arguments as String)
            }
            "openAccountAndSecurity" -> {
                AuthBridge.openAccountAndSecurity()
            }
            "setUserInfo" -> {
                AuthBridge.setUserInfo(call.arguments as String, result)
            }
            "isLogin" -> {
                AuthBridge.isLogin(result)
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
