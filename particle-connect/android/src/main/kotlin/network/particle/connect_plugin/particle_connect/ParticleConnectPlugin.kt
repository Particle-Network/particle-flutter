package network.particle.connect_plugin.particle_connect

import android.app.Activity
import com.blankj.utilcode.util.LogUtils

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import network.particle.flutter.bridge.module.ConnectBridge

/** ParticleConnectPlugin */
class ParticleConnectPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
    private var activity: Activity? = null
    private var channel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var events: EventSink? = null

    init {
        instance = this
    }

    companion object {
        @JvmStatic
        lateinit var instance: ParticleConnectPlugin

    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "connect_bridge")
        eventChannel = EventChannel(binding.binaryMessenger, "connect_event_bridge")
        channel?.setMethodCallHandler(this)
        eventChannel?.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        LogUtils.d("onMethodCall", call)
        when (call.method) {
            "init" -> {
                ConnectBridge.init(activity!!, call.arguments as String)
            }
            "setChainInfo" -> {
                ConnectBridge.setChainInfo(call.arguments as String, result)
            }
            "connect" -> {
                ConnectBridge.connect(call.arguments as String, result,events)
            }
            "connectWalletConnect" -> {
                ConnectBridge.connectWalletConnect(result,events)
            }
            "qrCodeUri" -> {
                ConnectBridge.qrCodeUri(result)
            }
            "disconnect" -> {
                ConnectBridge.disconnect(call.arguments as String, result)
            }
            "isConnected" -> {
                ConnectBridge.isConnect(call.arguments as String, result)
            }
            "getAccounts" -> {
                ConnectBridge.getAccounts(call.arguments as String, result)
            }

            "signMessage" -> {
                ConnectBridge.signMessage(call.arguments as String, result)
            }
            "signTransaction" -> {
                ConnectBridge.signTransaction(call.arguments as String, result)
            }
            "signAllTransactions" -> {
                ConnectBridge.signAllTransactions(call.arguments as String, result)
            }
            "signAndSendTransaction" -> {
                ConnectBridge.signAndSendTransaction(call.arguments as String, result)
            }
            "signTypedData" -> {
                ConnectBridge.signTypedData(call.arguments as String, result)
            }
            "importPrivateKey" -> {
                ConnectBridge.importPrivateKey(call.arguments as String, result)
            }
            "importMnemonic" -> {
                ConnectBridge.importMnemonic(call.arguments as String, result)
            }
            "exportPrivateKey" -> {
                ConnectBridge.exportPrivateKey(call.arguments as String, result)
            }
            "login" -> {
                ConnectBridge.login(call.arguments as String, result)
            }
            "verify" -> {
                ConnectBridge.verify(call.arguments as String, result)
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
                    method, arguments
                )
            })
        }
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        this.events = events;
    }

    override fun onCancel(arguments: Any?) {
    }
}
