package network.particle.aa_plugin.module
import android.app.Activity
import androidx.annotation.Keep
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.particle.base.ParticleNetwork
import com.particle.base.isSupportedERC4337
import com.particle.erc4337.ParticleNetworkAA.initAAMode

import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import network.particle.aa_plugin.model.BiconomyInitData
import network.particle.aa_plugin.model.FeeQuotesParams
import network.particle.base_flutter.model.ChainData
import network.particle.base_flutter.model.FlutterCallBack
import network.particle.base_flutter.utils.ChainUtils

@Keep
object AABridge {
    ///////////////////////////////////////////////////////////////////////////
    //////////////////////////// AUTH //////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    /**
     * {
     * "chain": "BscChain",
     * "chain_id": "Testnet",
     * "env": "PRODUCTION"
     * }
     */
    fun init(activity: Activity, initParams: String?) {
        LogUtils.d("init", initParams)
        val initData = GsonUtils.fromJson(initParams, BiconomyInitData::class.java)
        ParticleNetwork.initAAMode(initData.dAppKeys)
        val providerName = initData.name
        val providerVersion = initData.version
        LogUtils.d("providerName", providerName)
        val aaService = ParticleNetwork.getRegisterAAServices().values.firstOrNull {
            it.getIAAProvider().apiName.equals(
                providerName,
                true
            ) && it.getIAAProvider().version.equals(providerVersion, true)
        }
        aaService?.apply {
//            getIAAProvider().version = initData.version
            ParticleNetwork.setAAService(aaService)
        }

    }

    fun isSupportChainInfo(chainParams: String, result: MethodChannel.Result) {
        LogUtils.d("setChainName", chainParams)
        val chainData: ChainData = GsonUtils.fromJson(
            chainParams,
            ChainData::class.java
        )
        try {
            val chainInfo = ChainUtils.getChainInfo(chainData.chainId)
            val isSupportedERC4337 = chainInfo.isSupportedERC4337()
            result.success(isSupportedERC4337)
        } catch (e: Exception) {
            result.success(false)
        }
    }


    fun isDeploy(eoaAddress: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val isDeploy = ParticleNetwork.getAAService().isDeploy(eoaAddress)
                result.success(FlutterCallBack.success(isDeploy).toGson())
            } catch (e: Exception) {
                result.success(FlutterCallBack.failed(e.message ?: "failed").toGson())
            }
        }
    }

    fun isBiconomyModeEnable(result: MethodChannel.Result) {
        try {
            val isBiconomyModeEnable = ParticleNetwork.getAAService().isAAModeEnable()
            result.success(isBiconomyModeEnable)
        } catch (e: Exception) {
            result.success(false)
        }
    }

    fun enableBiconomyMode() {
        ParticleNetwork.getAAService().enableAAMode()
    }

    fun disableBiconomyMode() {
        ParticleNetwork.getAAService().disableAAMode()
    }

    fun rpcGetFeeQuotes(feeQuotesParams: String, result: MethodChannel.Result) {
        LogUtils.d("rpcGetFeeQuotes", feeQuotesParams)
        val feeQuotesParams = GsonUtils.fromJson(feeQuotesParams, FeeQuotesParams::class.java)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val resp = ParticleNetwork.getAAService()
                    .rpcGetFeeQuotes(feeQuotesParams.eoaAddress, feeQuotesParams.transactions)
                LogUtils.d("rpcGetFeeQuotes", resp)
                if (resp.isSuccess()) {
                    result.success(FlutterCallBack.success(resp.result).toGson())
                } else {
                    result.success(FlutterCallBack.failed(resp.error?.message ?: "failed").toGson())
                }
            } catch (e: Exception) {
                result.success(FlutterCallBack.failed(e.message ?: "failed").toGson())
            }
        }
    }

}
