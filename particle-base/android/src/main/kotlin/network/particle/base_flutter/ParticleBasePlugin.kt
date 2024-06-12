package network.particle.base_flutter
import android.app.Activity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import network.particle.base_flutter.module.BaseBridge
/** ParticleBasePlugin */
class ParticleBasePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    private var channel: MethodChannel? = null
    companion object {
        @JvmStatic
        lateinit var instance: ParticleBasePlugin
    }

    init {
        instance = this
    }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "base_bridge")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

            "init" -> {
                BaseBridge.init(activity!!, call.arguments as String)
            }
            "getChainInfo" -> {
                BaseBridge.getChainInfo(result)
            }
            "setChainInfo" -> {
                BaseBridge.setChainInfo(call.arguments as String, result)
            }

            "setSecurityAccountConfig" -> {
                BaseBridge.setSecurityAccountConfig(call.arguments as String)
            }

            "setLanguage" -> {
                BaseBridge.setLanguage(call.arguments as String)
            }

            "getLanguage" -> {
                BaseBridge.getLanguage(result)
            }

            "setAppearance" -> {
                BaseBridge.setAppearance(call.arguments as String)
            }

            "setFiatCoin" -> {
                BaseBridge.setFiatCoin(call.arguments as String)
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
