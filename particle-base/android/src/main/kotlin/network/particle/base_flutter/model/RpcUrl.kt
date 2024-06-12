package network.particle.base_flutter.model


import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
@Keep
class RpcUrl {
    @SerializedName("evm_url")
    var evmUrl: String? = null

    @SerializedName("sol_url")
    var solUrl: String? = null
}