package network.particle.auth_core_flutter.bridge.model

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.particle.base.data.FeeQuote
import com.particle.base.data.FeeQuotesResult

@Keep
data class BiconomyFeeMode(
    @SerializedName("option") val option: String,
    @SerializedName("fee_quote") val feeQuote: FeeQuote?,
    @SerializedName("whole_fee_quote") val wholeFeeQuote: FeeQuotesResult,
    @SerializedName("token_paymaster_address") val tokenPaymasterAddress: String?
)

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
