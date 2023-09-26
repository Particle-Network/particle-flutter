package network.particle.auth_core_flutter.bridge.module

import android.app.Activity
import android.text.TextUtils
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.reflect.TypeToken
import com.particle.base.CurrencyEnum
import com.particle.base.Env
import com.particle.base.LanguageEnum
import com.particle.base.ParticleNetwork
import com.particle.base.ParticleNetwork.setFiatCoin
import com.particle.base.ThemeEnum
import com.particle.base.data.ErrorInfo
import com.particle.base.data.SignOutput
import com.particle.base.data.WebOutput
import com.particle.base.data.WebServiceCallback
import com.particle.base.ibiconomy.FeeMode
import com.particle.base.ibiconomy.FeeModeGasless
import com.particle.base.ibiconomy.FeeModeNative
import com.particle.base.ibiconomy.FeeModeToken
import com.particle.base.ibiconomy.MessageSigner
import com.particle.base.model.LoginType
import com.particle.base.model.ResultCallback
import com.particle.base.model.SecurityAccountConfig
import com.particle.base.model.SupportAuthType
import com.particle.base.model.UserInfo
import com.particle.network.ParticleNetworkAuth.fastLogout
import com.particle.network.ParticleNetworkAuth.getAddress
import com.particle.network.ParticleNetworkAuth.getSecurityAccount
import com.particle.network.ParticleNetworkAuth.getUserInfo
import com.particle.network.ParticleNetworkAuth.isLogin
import com.particle.network.ParticleNetworkAuth.isLoginAsync
import com.particle.network.ParticleNetworkAuth.login
import com.particle.network.ParticleNetworkAuth.logout
import com.particle.network.ParticleNetworkAuth.openAccountAndSecurity
import com.particle.network.ParticleNetworkAuth.openWebWallet
import com.particle.network.ParticleNetworkAuth.setWebAuthConfig
import com.particle.network.ParticleNetworkAuth.signAllTransactions
import com.particle.network.ParticleNetworkAuth.signAndSendTransaction
import com.particle.network.ParticleNetworkAuth.signMessage
import com.particle.network.ParticleNetworkAuth.signMessageUnique
import com.particle.network.ParticleNetworkAuth.signTransaction
import com.particle.network.ParticleNetworkAuth.signTypedData
import com.particle.network.ParticleNetworkAuth.switchChain
import com.particle.network.SignTypedDataVersion
import com.particle.network.service.*
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import network.particle.auth_core_flutter.bridge.model.*
import network.particle.auth_core_flutter.bridge.utils.ChainUtils
import network.particle.auth_core_flutter.bridge.utils.EncodeUtils
import network.particle.chains.ChainInfo
import org.json.JSONObject


object AuthCoreBridge {
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
        LogUtils.d("activity", activity)
        LogUtils.d("init", initParams)
        val initData = GsonUtils.fromJson(initParams, InitData::class.java)
        val chainInfo = ChainUtils.getChainInfo(initData.chainId)
        ParticleNetwork.init(activity, Env.valueOf(initData.env!!.uppercase()), chainInfo)
    }
}
