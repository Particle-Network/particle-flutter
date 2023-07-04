package network.particle.connect_plugin.particle_connect_example

import android.app.Application
import com.connect.common.model.DAppMetadata
import com.evm.adapter.EVMConnectAdapter
import com.particle.base.Env
import com.particle.base.EthereumChain
import com.particle.base.EthereumChainId
import com.particle.connect.ParticleConnect
import com.particle.connect.ParticleConnectAdapter
import com.phantom.adapter.PhantomConnectAdapter
import com.solana.adapter.SolanaConnectAdapter
import com.wallet.connect.adapter.BitKeepConnectAdapter
import com.wallet.connect.adapter.ImTokenConnectAdapter
import com.wallet.connect.adapter.MetaMaskConnectAdapter
import com.wallet.connect.adapter.ParticleWalletConnectAdapter
import com.wallet.connect.adapter.RainbowConnectAdapter
import com.wallet.connect.adapter.TrustConnectAdapter
import com.wallet.connect.adapter.WalletConnectAdapter
import com.wallet.connect.adapter.secondory.TokenPocketConnectAdapter

class App :Application() {
    override fun onCreate() {
        super.onCreate()
    }
}