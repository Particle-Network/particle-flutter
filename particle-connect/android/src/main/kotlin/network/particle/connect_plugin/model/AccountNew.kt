package network.particle.connect_plugin.model

import androidx.annotation.Keep

@Keep
data class AccountNew(val publicAddress: String, val walletType: String? = null)