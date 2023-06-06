package network.particle.auth_flutter.bridge.model

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
data class BiconomyFeeMode(val option: String, val feeQuote: String?)

@Keep
data class TransactionParams(
    @SerializedName("transaction") val transaction: String,
    @SerializedName("fee_mode") val feeMode: BiconomyFeeMode?,
)
