package network.particle.wallet_plugin.module

import android.app.Activity
import android.content.Intent
import android.text.TextUtils
import android.util.Log
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.connect.common.IConnectAdapter
import com.connect.common.IParticleConnectAdapter
import com.google.gson.reflect.TypeToken
import com.particle.api.infrastructure.db.table.WalletInfo
import com.particle.api.service.DBService
import com.particle.base.ParticleNetwork
import com.particle.base.model.MobileWCWalletName
import com.particle.base.utils.ChainUtils
import com.particle.base.utils.PrefUtils
import com.particle.connect.ParticleConnect
import com.particle.gui.ParticleWallet
import com.particle.gui.ParticleWallet.displayNFTContractAddresses
import com.particle.gui.router.PNRouter
import com.particle.gui.router.RouterPath
import com.particle.gui.ui.nft_detail.NftDetailParams
import com.particle.gui.ui.receive.ReceiveData
import com.particle.gui.ui.send.WalletSendParams
import com.particle.gui.ui.swap.SwapConfig
import com.particle.gui.ui.token_detail.TokenTransactionRecordsParams
import com.particle.gui.utils.WalletUtils
import com.particle.network.ParticleNetworkAuth.getAddress
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import network.particle.connect_plugin.utils.BridgeScope
import network.particle.chains.ChainInfo
import network.particle.wallet_plugin.ui.FlutterLoginOptActivity
import network.particle.wallet_plugin.utils.WalletScope
import org.json.JSONObject
import particle.auth.adapter.ParticleConnectAdapter
import java.math.BigInteger

object WalletBridge {
    var isUIInit = false

    //init
    fun init(activity: Activity?) {
        isUIInit = try {
            PrefUtils.init(activity!!, "particle")
            ParticleWallet.init(activity!!, null)
            true
        } catch (e: Exception) {
            false
        }
    }

    fun setPNWallet() {
        if (!isUIModuleInit()) return;
        WalletScope.launch {
            val address = ParticleNetwork.getAddress()
            val wallet = WalletUtils.createSelectedWallet(address, MobileWCWalletName.Particle.name)
            WalletUtils.setWalletChain(wallet)

        }
    }

    fun createSelectedWallet(publicAddress: String, adapter: IConnectAdapter) {
        WalletScope.launch {
            val wallet = WalletUtils.createSelectedWallet(publicAddress, adapter)
            WalletUtils.setWalletChain(wallet)
        }
    }

    fun setWallet(jsonParams: String) {
        LogUtils.d("setWallet", jsonParams)
        val jsonObject = JSONObject(jsonParams);
        val walletType = jsonObject.getString("wallet_type");
        val publicKey = jsonObject.getString("public_address");
        val walletName = jsonObject.getString("wallet_name");
        val adapter = ParticleConnect.getAdapters().first { it.name.equals(walletType, true) }
        if (!TextUtils.isEmpty(walletName) && adapter is IParticleConnectAdapter) {
            WalletScope.launch {
                val wallet = WalletInfo.createWallet(
                    publicKey,
                    ParticleNetwork.chainInfo.name,
                    ParticleNetwork.chainInfo.id,
                    1,
                    walletName,
                    adapter.name
                )
                ParticleWallet.setWallet(wallet)
            }
        } else {
            WalletScope.launch {
                val wallet = WalletUtils.createSelectedWallet(publicKey, adapter)
                WalletUtils.setWalletChain(wallet)
            }
        }
    }

    /**
     * navigatorWallet
     */
    fun navigatorWallet(display: Int) {
        if (!isUIModuleInit()) return;
        PNRouter.build(RouterPath.Wallet).withInt(RouterPath.Wallet.toString(), display)
            .navigation();
    }

    fun navigatorTokenReceive(tokenAddress: String) {
        if (!isUIModuleInit()) return;
        try {
            val receiveData = ReceiveData(tokenAddress);
            PNRouter.build(RouterPath.TokenReceive)
                .withParcelable(RouterPath.TokenReceive.toString(), receiveData).navigation();
        } catch (e: Exception) {
            e.printStackTrace();
        }
    }

    /**
     * {
     * token_address: "0x0000000000000000000000000000000000000000",
     * to_address:"0x0000000000000000000000000000000000000000",
     * amount: 111,
     * }
     */
    fun navigatorTokenSend(json: String) {
        if (!isUIModuleInit()) return;
        LogUtils.d("navigatorTokenSend", json);
        try {
            val jsonObject = JSONObject(json);
            val tokenAddress = jsonObject.getString("token_address");
            val toAddress = jsonObject.getString("to_address");
            val amount = jsonObject.getString("amount").toLong()
            val params = WalletSendParams(
                tokenAddress, toAddress, BigInteger.valueOf(amount)
            );
            PNRouter.build(RouterPath.TokenSend, params).navigation();
        } catch (e: Exception) {
            e.printStackTrace();
        }
    }

    fun navigatorTokenTransactionRecords(tokenAddress: String) {
        if (!isUIModuleInit()) return;
        try {
            val params = TokenTransactionRecordsParams(tokenAddress);
            PNRouter.build(RouterPath.TokenTransactionRecords, params).navigation();
        } catch (e: Exception) {
            e.printStackTrace();
        }
    }

    /**
     * {
     * "mint":"0x0000000000000000000000000000000000000000",
     * "receiver_address":"0x0000000000000000000000000000000000000000",
     * }
     */
    fun navigatorNFTSend(json: String) {
        if (!isUIModuleInit()) return;
        try {
            val jsonObject = JSONObject(json);
            val mint = jsonObject.getString("mint");
            val receiverAddress = jsonObject.getString("receiver_address");
            val params = NftDetailParams(mint, receiverAddress);
            PNRouter.build(RouterPath.NftDetails, params).navigation();
        } catch (e: Exception) {
            e.printStackTrace();
        }

    }

    fun navigatorNFTDetails(mint: String) {
        if (!isUIModuleInit()) return;
        try {
            val params = NftDetailParams(mint, null);
            PNRouter.build(RouterPath.NftDetails, params).navigation();
        } catch (e: Exception) {
            e.printStackTrace();
        }
    }


    fun logoutWallet(publicAddress: String) {
        if (!isUIModuleInit()) return;
        WalletScope.launch {
            DBService.walletInfoDao.deleteWallet(publicAddress)
        }
    }

    private fun isUIModuleInit(): Boolean {
        return if (isUIInit) {
            true
        } else {
            Log.e("UIBridge", "UI module is not init!!!")
            false
        }
    }

    fun getEnablePay(result: MethodChannel.Result) {
        result.success(!ParticleWallet.getPayDisabled())
    }

    fun enablePay(enable: Boolean) {
    }

    fun navigatorBuyCrypto(activity: Activity, json: String) {
        LogUtils.d("navigatorBuyCrypto", json)
        if (!isUIModuleInit()) return;
        val jsonObject = JSONObject(json)
        val walletAddress = jsonObject.optString("wallet_address")
        val chainName = jsonObject.optString("network")
        val cryptoCoin = jsonObject.optString("crypto_coin")
        val fiatCoin = jsonObject.optString("fiat_coin")
        val fiatAmt = jsonObject.optInt("fiat_amt")
        val fixCryptoCoin = jsonObject.optBoolean("fix_crypto_coin")
        val fixFiatAmt = jsonObject.optBoolean("fix_fiat_amt")
        val fixFiatCoin = jsonObject.optBoolean("fix_fiat_coin")
        val theme = jsonObject.optString("theme")
        val language = jsonObject.optString("language")
//        ParticleNetwork.openBuy(walletAddress, fiatAmt, fiatCoin, cryptoCoin, fixFiatCoin, fixFiatAmt, fixCryptoCoin, theme, language, chainName
//        )
        ParticleNetwork.openBuy(
            activity,
            walletAddress = walletAddress,
            amount = fiatAmt,
            fiatCoin = fiatCoin,
            cryptoCoin = cryptoCoin,
            fixFiatCoin = fixFiatCoin,
            fixFiatAmt = fixFiatAmt,
            fixCryptoCoin = fixCryptoCoin,
            theme = theme,
            language = language,
            chainName = chainName
        )
//        try {
//
//
//
//        } catch (e: Exception) {
//            ParticleNetworkAuth.openBuy(ParticleNetwork.INSTANCE, "", 0, "", "", false, false, false, "", "", "");
//            e.printStackTrace();
//        }

    }

    fun navigatorSwap(activity: Activity, json: String) {
        try {
            var jsonObject = JSONObject(json);
            val fromTokenAddress = jsonObject.opt("from_token_address") as? String;
            val toTokenAddress = jsonObject.opt("to_token_address") as? String;
            val amount = jsonObject.opt("amount") as? String;
            if (fromTokenAddress != null) {
                PNRouter.navigatorSwap(
                    SwapConfig(
                        fromTokenAddress,
                        toTokenAddress ?: "",
                        amount ?: "0"
                    )
                )
            } else {
                PNRouter.navigatorSwap(null);
            };
        } catch (e: Exception) {
            PNRouter.navigatorSwap(null);
        }


    }

    fun setShowTestNetwork(show: Boolean) {
        ParticleWallet.setShowTestNetworkSetting(show)
    }

    fun setShowManageWallet(show: Boolean) {
        ParticleWallet.setShowManageWalletSetting(show)
    }

    var loginOptCallback: MethodChannel.Result? = null

    fun navigatorLoginList(activity: Activity, result: MethodChannel.Result) {
        loginOptCallback = result
        activity.startActivity(
            Intent(
                activity, FlutterLoginOptActivity::class.java
            )
        )
    }

    /**
     * GUI
     */
    fun setSupportChain(jsonParams: String) {
        val chains = GsonUtils.fromJson<List<SupportChain>>(
            jsonParams, object : TypeToken<List<SupportChain>>() {}.type
        )
        val supportChains: MutableList<ChainInfo> = java.util.ArrayList()
        for (chain in chains) {
            val chainInfo: ChainInfo = ChainUtils.getChainInfo(chain.chainId)
            supportChains.add(chainInfo)
        }
        ParticleWallet.setSupportChain(supportChains)
    }

    fun switchWallet(jsonParams: String, result: MethodChannel.Result) {
        try {
            val jsonObject = JSONObject(jsonParams);
            val walletType = jsonObject.getString("wallet_type");
            val publicKey = jsonObject.getString("public_address");
            val adapter = ParticleConnect.getAdapters().first { it.name.equals(walletType, true) }
            WalletScope.launch {
                WalletUtils.createSelectedWallet(publicKey, adapter)
                result.success(true)
            }
        } catch (e: Exception) {
            result.success(false)
        }
    }

    fun enableSwap(enable: Boolean) {
        LogUtils.d("enableSwap", enable.toString());
        ParticleWallet.setSwapDisabled(!enable)
    }

    fun getEnableSwap(result: MethodChannel.Result) {
        result.success(!ParticleWallet.getSwapDisabled())
    }

    fun getBridgeDisabled(result: MethodChannel.Result){
        result.success(ParticleWallet.getBridgeDisabled())
    }

    fun setBridgeDisabled(disable: Boolean) {
        LogUtils.d("setBridgeDisabled", disable.toString());
        ParticleWallet.setBridgeDisabled(disable)
    }

    fun getPayDisabled(result: MethodChannel.Result) {
        result.success(ParticleWallet.getPayDisabled())
    }

    fun getChainInfo(chainId: Long): ChainInfo {
        return ChainUtils.getChainInfo(chainId)
    }

    fun supportWalletConnect(enable: Boolean) {
        LogUtils.d("supportWalletConnect", enable.toString());
        ParticleWallet.setSupportWalletConnect(enable);
    }

    fun setShowLanguageSetting(isShow: Boolean) {
        ParticleWallet.setShowLanguageSetting(isShow)
    }

    fun setShowAppearanceSetting(isShow: Boolean) {
        ParticleWallet.setShowAppearanceSetting(isShow)
    }

    fun setSupportDappBrowser(isShow: Boolean) {
        ParticleWallet.setSupportDappBrowser(isShow)
    }

    fun setSupportAddToken(isShow: Boolean) {
        ParticleWallet.setSupportAddToken(isShow)
    }

    fun setDisplayTokenAddresses(tokenAddressJson: String) {
        val tokenAddresses = GsonUtils.fromJson<List<String>>(
            tokenAddressJson, object : TypeToken<List<String>>() {}.type
        )
        ParticleWallet.displayTokenAddresses(tokenAddresses as MutableList<String>)
    }

    fun setDisplayNFTContractAddresses(nftContractAddresses: String) {
        val nftContractAddressList = GsonUtils.fromJson<List<String>>(
            nftContractAddresses, object : TypeToken<List<String>>() {}.type
        )
        ParticleNetwork.displayNFTContractAddresses(nftContractAddressList as MutableList<String>)
    }

    fun setCustomWalletName(jsonParams: String) {
        try {
            val jsonObject = JSONObject(jsonParams);
            val icon = jsonObject.getString("icon")
            ParticleWallet.setWalletIcon(icon)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    fun navigatorDappBrowser(jsonParams: String) {
        try {
            val jsonObject = JSONObject(jsonParams);
            val url = jsonObject.optString("url")
            ParticleWallet.navigatorDAppBrowser(url)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}