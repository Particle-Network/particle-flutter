package network.particle.biconomy_flutter.bridge.module

import android.app.Activity
import androidx.annotation.Keep
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.particle.base.ParticleNetwork
import com.particle.base.isSupportedERC4337
import com.particle.base.model.BiconomyVersion
import com.particle.erc4337.ParticleNetworkBiconomy.initBiconomyMode
import com.particle.erc4337.biconomy.BiconomyService

import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import network.particle.auth_flutter.bridge.model.ChainData
import network.particle.auth_flutter.bridge.model.FlutterCallBack
import network.particle.auth_flutter.bridge.utils.ChainUtils
import network.particle.biconomy_flutter.bridge.model.*

@Keep
object BiconomyBridge {
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
        ParticleNetwork.initBiconomyMode(initData.dAppKeys, BiconomyVersion.V100)
        ParticleNetwork.setBiconomyService(BiconomyService)
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
                val isDeploy = ParticleNetwork.getBiconomyService().isDeploy(eoaAddress)
                result.success(FlutterCallBack.success(isDeploy).toGson())
            } catch (e: Exception) {
                result.success(FlutterCallBack.failed(e.message ?: "failed").toGson())
            }
        }
    }

    fun isBiconomyModeEnable(result: MethodChannel.Result) {
        try {
            val isBiconomyModeEnable = ParticleNetwork.getBiconomyService().isBiconomyModeEnable()
            result.success(isBiconomyModeEnable)
        } catch (e: Exception) {
            result.success(false)
        }
    }

    fun enableBiconomyMode() {
        ParticleNetwork.getBiconomyService().enableBiconomyMode()
    }

    fun disableBiconomyMode() {
        ParticleNetwork.getBiconomyService().disableBiconomyMode()
    }

    fun rpcGetFeeQuotes(feeQuotesParams: String, result: MethodChannel.Result) {
        LogUtils.d("rpcGetFeeQuotes", feeQuotesParams)
        val feeQuotesParams = GsonUtils.fromJson(feeQuotesParams, FeeQuotesParams::class.java)
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val resp = ParticleNetwork.getBiconomyService().rpcGetFeeQuotes(feeQuotesParams.eoaAddress, feeQuotesParams.transactions)
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