package network.particle.aa_flutter.bridge.model

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
data class BiconomyInitData(
    @SerializedName("biconomy_app_keys")
    val dAppKeys: Map<Long, String>,
    @SerializedName("name")
    val name: String,
    @SerializedName("version")
    val version: String
)

@Keep
data class FeeQuotesParams(
    @SerializedName("eoa_address")
    val eoaAddress: String,
    val transactions: List<String>
)
