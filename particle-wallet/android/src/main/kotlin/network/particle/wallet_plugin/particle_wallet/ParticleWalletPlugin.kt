package network.particle.wallet_plugin.particle_wallet

import android.app.Activity
import com.blankj.utilcode.util.LogUtils

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import network.particle.flutter.bridge.module.WalletBridge

/** ParticleWalletPlugin */
class ParticleWalletPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    private var channel: MethodChannel? = null

    init {
        instance = this
    }

    companion object {
        @JvmStatic
        lateinit var instance: ParticleWalletPlugin
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "wallet_bridge")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        LogUtils.d("xxhong", call)
        when (call.method) {
            "init" -> {
                WalletBridge.init(activity!!)
            }
            "navigatorWallet" -> {
                WalletBridge.navigatorWallet(call.arguments as Int)
            }
            "navigatorTokenReceive" -> {
                WalletBridge.navigatorTokenReceive(call.arguments as String)
            }
            "navigatorTokenSend" -> {
                WalletBridge.navigatorTokenSend(call.arguments as String)
            }
            "navigatorTokenTransactionRecords" -> {
                WalletBridge.navigatorTokenTransactionRecords(call.arguments as String)
            }
            "navigatorNFTSend" -> {
                WalletBridge.navigatorNFTSend(call.arguments as String)
            }
            "navigatorNFTDetails" -> {
                WalletBridge.navigatorNFTDetails(call.arguments as String)
            }
            "navigatorBuyCrypto" -> {
                WalletBridge.navigatorBuyCrypto(activity!!,call.arguments as String)
            }
            "navigatorSwap" -> {
                WalletBridge.navigatorSwap(activity!!, call.arguments as String)
            }
            "navigatorLoginList" -> {
                WalletBridge.navigatorLoginList(activity!!, result)
            }
            "setShowTestNetwork" -> {
                WalletBridge.setShowTestNetwork(call.arguments as Boolean)
            }
            "setShowManageWallet" -> {
                WalletBridge.setShowManageWallet(call.arguments as Boolean)
            }
            "setSupportChain" -> {
                WalletBridge.setSupportChain(call.arguments as String)
            }
            "switchWallet" -> {
                WalletBridge.switchWallet(call.arguments as String, result);
            }
            "enablePay" -> {
                WalletBridge.enablePay(call.arguments as Boolean)
            }
            "getPayDisabled" -> {
                WalletBridge.getEnablePay(result);
            }
            "enableSwap" -> {
                WalletBridge.enableSwap(call.arguments as Boolean)
            }
            "getEnableSwap" -> {
                WalletBridge.getEnableSwap(result)
            }

            "switchWallet" -> {
                WalletBridge.switchWallet(call.arguments as String, result)
            }
            "setWallet" -> {
                WalletBridge.setWallet(call.arguments as String)
            }

            "supportWalletConnect" -> {
                WalletBridge.supportWalletConnect(call.arguments as Boolean)
            }

            "setShowLanguageSetting" -> {
                WalletBridge.setShowLanguageSetting(call.arguments as Boolean)
            }
            "setShowAppearanceSetting" -> {
                WalletBridge.setShowAppearanceSetting(call.arguments as Boolean)
            }

            "setSupportDappBrowser" -> {
                WalletBridge.setSupportDappBrowser(call.arguments as Boolean)
            }
            "setSupportAddToken" -> {
                WalletBridge.setSupportAddToken(call.arguments as Boolean)
            }
            "setDisplayTokenAddresses" -> {
                WalletBridge.setDisplayTokenAddresses(call.arguments as String)
            }
            "setDisplayNFTContractAddresses" -> {
                WalletBridge.setDisplayNFTContractAddresses(call.arguments as String)
            }
            "setCustomWalletName" -> {
                WalletBridge.setCustomWalletName(call.arguments as String)
            }
            "navigatorDappBrowser" -> {
                WalletBridge.navigatorDappBrowser(call.arguments as String)
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
}
