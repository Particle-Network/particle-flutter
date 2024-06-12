package network.particle.connect_plugin.model;

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
data class AddSwitchChain(
    @SerializedName("chain_name") val chainName: String,
    @SerializedName("chain_id") val chainId: String,
    @SerializedName("chain_id_name") val chainIdName: String,
    @SerializedName("wallet_type") val walletType: String,
    @SerializedName("public_address") val publicAddress: String,
)