package network.particle.auth_flutter.bridge.model

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.particle.base.model.Erc4337FeeQuote

@Keep
data class BiconomyFeeMode(val option: String, val feeQuote: Erc4337FeeQuote)

@Keep
data class TransactionParams(
    @SerializedName("transaction") val transaction: String,
    @SerializedName("fee_mode") val feeMode: BiconomyFeeMode?,
)

@Keep
data class TransactionsParams(
    @SerializedName("transactions") val transactions: List<String>,
    @SerializedName("fee_mode") val feeMode: BiconomyFeeMode?,
)
