package network.particle.flutter.bridge.module

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.connect.common.IConnectAdapter
import com.google.gson.reflect.TypeToken
import com.particle.api.infrastructure.db.table.WalletType
import com.particle.api.service.DBService
import com.particle.base.ChainInfo
import com.particle.base.ChainName
import com.particle.base.ParticleNetwork
import com.particle.gui.ParticleWallet
import com.particle.gui.ParticleWallet.enablePay
import com.particle.gui.ParticleWallet.enableSwap
import com.particle.gui.ParticleWallet.getEnablePay
import com.particle.gui.ParticleWallet.getEnableSwap
import com.particle.gui.ParticleWallet.navigatorBuy
import com.particle.gui.ParticleWallet.openPay
import com.particle.gui.ParticleWallet.supportWalletConnect
import com.particle.gui.router.PNRouter
import com.particle.gui.router.RouterPath
import com.particle.gui.ui.nft_detail.NftDetailParams
import com.particle.gui.ui.receive.ReceiveData
import com.particle.gui.ui.send.WalletSendParams
import com.particle.gui.ui.token_detail.TokenTransactionRecordsParams
import com.particle.gui.utils.WalletUtils
import com.particle.network.ParticleNetworkAuth.getAddress
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import network.particle.flutter.bridge.ui.FlutterLoginOptActivity
import network.particle.flutter.bridge.utils.BridgeScope
import network.particle.flutter.bridge.utils.WalletScope
import network.particle.flutter.bridge.utils.WalletTypeParser
import org.json.JSONObject
import java.math.BigInteger

object WalletBridge {
    var isUIInit = false

    //init
    fun init(activity: Activity?) {
        isUIInit = try {
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
            val wallet = WalletUtils.createSelectedWallet(address, WalletType.PN_WALLET)
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
        val jsonObject = JSONObject(jsonParams);
        val walletType = jsonObject.getString("wallet_type");
        val publicKey = jsonObject.getString("public_address");
        val type = WalletTypeParser.getWalletType(walletType);
        BridgeScope.launch {
            val wallet = WalletUtils.createSelectedWallet(publicKey, type)
            WalletUtils.setWalletChain(wallet)
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
            val amount = jsonObject.getLong("amount");
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
            DBService.walletDao.deleteWallet(publicAddress)
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
        result.success(ParticleNetwork.getEnablePay())
    }

    fun enablePay(enable: Boolean) {
        ParticleNetwork.enablePay(enable)
    }

    fun openPay() {
        ParticleNetwork.openPay()
    }

    fun navigatorBuyCrypto(json: String) {
        if (!isUIModuleInit()) return;

        try {
            val jsonObject = JSONObject(json);

            val walletAddress = jsonObject.opt("wallet_address") as? String;
            val fiatCoin = jsonObject.opt("fiat_coin") as? String;
            val cryptoCoin = jsonObject.opt("crypto_coin") as? String;
            val fiatAmt = jsonObject.opt("fiat_amt") as? Int;
            val networkString = (jsonObject.opt("network") as? String)?.lowercase();
            var network: ChainName? = null;

            if (networkString == "solana") {
                network = ChainName.Solana;
            } else if (networkString == "ethereum") {
                network = ChainName.Ethereum;
            } else if (networkString == "binancesmartchain") {
                network = ChainName.BSC;
            } else if (networkString == "avalanche")  {
                network = ChainName.Avalanche;
            } else if (networkString == "polygon")  {
                network = ChainName.Polygon;
            }

            ParticleNetwork.navigatorBuy(walletAddress, network, cryptoCoin, fiatCoin, fiatAmt);
        } catch (e: Exception) {
            ParticleNetwork.navigatorBuy();
        }
    }

    fun navigatorSwap(activity: Activity, json: String) {
        try {
            var jsonObject = JSONObject(json);
            val fromTokenAddress = jsonObject.opt("from_token_address") as? String;
            val toTokenAddress = jsonObject.opt("to_token_address") as? String;
            val amount = jsonObject.opt("amount") as? String;
            if (fromTokenAddress != null) {
                PNRouter.navigatorSwap(fromTokenAddress)
            } else {
                PNRouter.navigatorSwap("native");
            };
        } catch (e: Exception) {
            PNRouter.navigatorSwap("native");
        }



    }

    fun showTestNetwork(show: Boolean) {
        ParticleWallet.showTestNetworks(show)
    }

    fun showManageWallet(show: Boolean) {
        ParticleWallet.showManageWallet(show)
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
            val chainInfo: ChainInfo = getChainInfo(chain.chainName, chain.chainIdName)
            supportChains.add(chainInfo)
        }
        ParticleWallet.setSupportChain(supportChains)
    }

    fun switchWallet(jsonParams: String, result: MethodChannel.Result) {
        try {
            val jsonObject = JSONObject(jsonParams);
            val walletType = jsonObject.getString("wallet_type");
            val publicKey = jsonObject.getString("public_address");
            val type = WalletTypeParser.getWalletType(walletType);
            val adapter = WalletUtils.getConnectAdapter(type)
            WalletScope.launch {
                WalletUtils.createSelectedWallet(publicKey, adapter!!)
                result.success(true)
            }
        } catch (e: Exception) {
            result.success(false)
        }
    }

    fun enableSwap(enable: Boolean) {
        LogUtils.d("enableSwap", enable.toString());
        ParticleNetwork.enableSwap(enable)
    }

    fun getEnableSwap(result: MethodChannel.Result) {
        result.success(ParticleNetwork.getEnableSwap())
    }
    fun getChainInfo(chainName: String, chainIdName: String?): ChainInfo {
        var chainNameTmp = chainName
        if (ChainName.BSC.toString() == chainName) {
            chainNameTmp = "Bsc"
        }
        return try {
            val clazz1 =
                Class.forName("com.particle.base." + chainNameTmp + "Chain")
            val cons =
                clazz1.getConstructor(String::class.java)
            cons.newInstance(chainIdName) as ChainInfo
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
            throw RuntimeException(e.message)
        }
    }

    fun supportWalletConnect(enable: Boolean) {
        LogUtils.d("supportWalletConnect", enable.toString());
        ParticleNetwork.supportWalletConnect(enable);
    }


}