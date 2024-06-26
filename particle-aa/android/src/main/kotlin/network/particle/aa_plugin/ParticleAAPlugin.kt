package network.particle.aa_plugin
import android.app.Activity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import network.particle.aa_plugin.module.AABridge

/** ParticleAuthPlugin */
class ParticleAAPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    private var channel: MethodChannel? = null

    init {
        instance = this
    }

    companion object {
        @JvmStatic
        lateinit var instance: ParticleAAPlugin
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "aa_bridge")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                AABridge.init(activity!!, call.arguments as String)
            }

            "isSupportChainInfo" -> {
                AABridge.isSupportChainInfo(call.arguments as String, result)
            }

            "isDeploy" -> {
                AABridge.isDeploy(call.arguments as String, result)
            }

            "isAAModeEnable" -> {
                AABridge.isBiconomyModeEnable(result)
            }

            "enableAAMode" -> {
                AABridge.enableBiconomyMode()
            }

            "disableAAMode" -> {
                AABridge.disableBiconomyMode()
            }

            "rpcGetFeeQuotes" -> {
                AABridge.rpcGetFeeQuotes(call.arguments as String, result)
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
