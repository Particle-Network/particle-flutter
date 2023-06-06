package network.particle.biconomy_plugin.particle_biconomy

import android.app.Activity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import network.particle.biconomy_flutter.bridge.module.BiconomyBridge

/** ParticleAuthPlugin */
class ParticleBiconomyPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    private var channel: MethodChannel? = null

    init {
        instance = this
    }

    companion object {
        @JvmStatic
        lateinit var instance: ParticleBiconomyPlugin
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "biconomy_bridge")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                BiconomyBridge.init(activity!!, call.arguments as String)
            }

            "isSupportChainInfo" -> {
                BiconomyBridge.isSupportChainInfo(call.arguments as String, result)
            }

            "isDeploy" -> {
                BiconomyBridge.isDeploy(call.arguments as String, result)
            }

            "isBiconomyModeEnable" -> {
                BiconomyBridge.isBiconomyModeEnable(result)
            }

            "enableBiconomyMode" -> {
                BiconomyBridge.enableBiconomyMode()
            }

            "disableBiconomyMode" -> {
                BiconomyBridge.disableBiconomyMode()
            }

            "rpcGetFeeQuotes" -> {
                BiconomyBridge.rpcGetFeeQuotes(call.arguments as String, result)
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
