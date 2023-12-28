package network.particle.flutter.bridge.ui

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.RelativeLayout
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.blankj.utilcode.util.LogUtils
import com.connect.common.ConnectCallback
import com.connect.common.model.Account
import com.connect.common.model.ConnectError
import com.evm.adapter.EVMConnectAdapter
import com.particle.api.infrastructure.db.table.WalletInfo
import com.particle.base.ParticleNetwork
import com.particle.base.model.LoginType
import com.particle.base.model.MobileWCWalletName
import com.particle.base.model.SupportAuthType
import com.particle.base.model.Wallet
import com.particle.connect.ParticleConnect
import com.particle.gui.ui.login.LoginOptFragment
import com.particle.gui.ui.login.LoginTypeCallBack
import com.particle.gui.ui.setting.manage_wallet.dialog.WalletConnectQRFragment
import com.particle.gui.ui.setting.manage_wallet.private_login.PrivateKeyLoginActivity
import com.particle.gui.utils.Constants
import com.particle.gui.utils.WalletUtils
import com.particle.network.ParticleNetworkAuth.getAddress
import com.phantom.adapter.PhantomConnectAdapter
import com.solana.adapter.SolanaConnectAdapter
import com.wallet.connect.adapter.WalletConnectAdapter
import kotlinx.coroutines.launch
import network.particle.flutter.bridge.model.FlutterCallBack
import network.particle.flutter.bridge.module.WalletBridge
import network.particle.wallet_plugin.particle_wallet.R
import particle.auth.adapter.ParticleConnectConfig

class FlutterLoginOptActivity : AppCompatActivity() {
    lateinit var launcherResult: ActivityResultLauncher<Intent>
    var loginFragment: LoginOptFragment? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter_login_opt)
        setObserver()
        findViewById<RelativeLayout>(R.id.rlMain).setOnClickListener {
            finish()
        }
        loginFragment = LoginOptFragment.show(supportFragmentManager, true)
        loginFragment?.setCallBack(object : LoginTypeCallBack {
            override fun onLoginType(loginType: LoginType) {
                loginWithPn(loginType, SupportAuthType.ALL)
            }

            override fun onLoginConnect(walletName: String) {
                val adapter = ParticleConnect.getAdapters().first{it.name.equals(walletName,true)}
                if(adapter  is EVMConnectAdapter){
                    val intent = PrivateKeyLoginActivity.newIntent(this@FlutterLoginOptActivity)
                    launcherResult.launch(intent)
                }else if(adapter is SolanaConnectAdapter){
                    val intent = PrivateKeyLoginActivity.newIntent(this@FlutterLoginOptActivity)
                    launcherResult.launch(intent)
                }else if(adapter is WalletConnectAdapter){
                    walletConnect(adapter)
                }else if(adapter is PhantomConnectAdapter){
                    connectPhantom(adapter)
                }else {
                    adapter.connect(null, object : ConnectCallback {
                        override fun onConnected(account: Account) {
                            lifecycleScope.launch {
                                val wallet = WalletUtils.createSelectedWallet(account.publicAddress, adapter)
                                WalletUtils.setWalletChain(wallet)
                                val map = mutableMapOf<String, Any>()
                                map["account"] = account
                                map["walletType"] = adapter.name
                                WalletBridge.loginOptCallback!!.success(FlutterCallBack.success(map).toGson())
                                loginFragment?.dismissAllowingStateLoss()
                            }
                        }

                        override fun onError(error: ConnectError) {
                            WalletBridge.loginOptCallback!!.success(FlutterCallBack.failed(error.message).toGson())
                        }
                    })
                }
            }
        })
    }

    private fun loginWithPn(
        loginType: LoginType,
        supportAuthType: SupportAuthType
    ) {

        val adapter =
            ParticleConnect.getAdapters().first{it.name.equals(MobileWCWalletName.Particle.name,true)}
        val config = ParticleConnectConfig(loginType, supportAuthType.value, prompt = null)
        adapter.connect(config, object : ConnectCallback {
            override fun onConnected(account: Account) {
                lifecycleScope.launch {
                    val wallet = WalletInfo.createPnWallet(
                        ParticleNetwork.getAddress(),
                        ParticleNetwork.chainInfo.name,
                        ParticleNetwork.chainInfo.id,
                        1,
                    )
                    WalletUtils.setWalletChain(wallet)
                    val map = mutableMapOf<String, Any>()
                    map["account"] = account
                    map["walletType"] = "Particle"
                    WalletBridge.loginOptCallback!!.success(FlutterCallBack.success(map).toGson())
                    loginFragment?.dismissAllowingStateLoss()
                }
            }

            override fun onError(error: ConnectError) {
                WalletBridge.loginOptCallback!!.success(FlutterCallBack.failed(error.message).toGson())
            }
        })
    }

    private fun connectEvmWallet() {


    }

    var qrFragment: WalletConnectQRFragment? = null
    private fun walletConnect(adapter:WalletConnectAdapter) {
        adapter.connect(null, object : ConnectCallback {
            override fun onConnected(account: Account) {
                qrFragment?.dismissAllowingStateLoss()
                lifecycleScope.launch {
                    val wallet =
                        WalletUtils.createSelectedWallet(account.publicAddress, adapter)
                    WalletUtils.setWalletChain(wallet)
                    val map = mutableMapOf<String, Any>()
                    map["account"] = account
                    map["walletType"] = "WalletConnect"
                    WalletBridge.loginOptCallback!!.success(FlutterCallBack.success(map).toGson())
                    loginFragment?.dismissAllowingStateLoss()
                }
            }

            override fun onError(error: ConnectError) {
                LogUtils.d("MetaMask error: $error")
                qrFragment?.dismissAllowingStateLoss()
                WalletBridge.loginOptCallback!!.success(FlutterCallBack.failed(error.message).toGson())
            }
        })
        val qrUrl = adapter.qrCodeUri()
        qrFragment = WalletConnectQRFragment.show(supportFragmentManager, qrUrl!!)
    }

    private fun connectPhantom(adapter: PhantomConnectAdapter) {
        adapter.connect(null, object : ConnectCallback {
            override fun onConnected(account: Account) {
                lifecycleScope.launch {
                    val wallet = WalletUtils.createSelectedWallet(account.publicAddress, adapter)
                    WalletUtils.setWalletChain(wallet)
                    val map = mutableMapOf<String, Any>()
                    map["account"] = account
                    map["walletType"] = "Phantom"
                    WalletBridge.loginOptCallback!!.success(FlutterCallBack.success(map).toGson())
                    loginFragment?.dismissAllowingStateLoss()
                }
            }

            override fun onError(error: ConnectError) {
                WalletBridge.loginOptCallback!!.success(FlutterCallBack.failed(error.message).toGson())
            }
        })
    }

    private fun setObserver() {
        launcherResult =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { activityResult ->
                if (activityResult.resultCode == Activity.RESULT_OK) {
                    try {
                        loginFragment?.dismissAllowingStateLoss()
                        val wallet: WalletInfo =
                            activityResult.data!!.getParcelableExtra<WalletInfo>(Constants.PRIVATE_KEY_LOGIN_CHAIN_WALLET)!!
                        val map = mutableMapOf<String, Any>()
                        if (wallet.name == MobileWCWalletName.EVMConnect.name) {
                            map["account"] = Account(wallet.address, wallet.name)
                            map["walletType"] = "EthereumPrivateKey"
                        } else {
                            map["account"] = Account(wallet.address, wallet.name)
                            map["walletType"] = "SolanaPrivateKey"
                        }
                        WalletBridge.loginOptCallback!!.success(FlutterCallBack.success(map).toGson())
                    } catch (e: Exception) {
                        e.printStackTrace()
                        WalletBridge.loginOptCallback!!.success(FlutterCallBack.failed("Failed").toGson())
                    }
                }
            }
    }
}