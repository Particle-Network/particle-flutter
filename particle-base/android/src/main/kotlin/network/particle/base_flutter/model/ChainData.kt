package network.particle.base_flutter.model


import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
class ChainData {
    @SerializedName("chain_name")
    var chainName: String? = null

    @SerializedName("chain_id")
    var chainId:Long = 0

    @SerializedName("env")
    var env: String? = null
}