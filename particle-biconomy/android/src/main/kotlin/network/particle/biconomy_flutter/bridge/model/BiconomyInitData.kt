package network.particle.biconomy_flutter.bridge.model

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
data class BiconomyInitData(
    @SerializedName("version")
    val version: String,
    @SerializedName("dapp_app_keys")
    val dAppKeys: Map<Long, String>
)

@Keep
data class FeeQuotesParams(
    @SerializedName("eoa_address")
    val eoaAddress: String,
    val transactions: List<String>)