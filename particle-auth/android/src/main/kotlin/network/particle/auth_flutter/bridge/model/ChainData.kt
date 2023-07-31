package network.particle.auth_flutter.bridge.model

import com.google.gson.annotations.SerializedName

class ChainData {
    @SerializedName("chain_name")
    var chainName: String? = null

    @SerializedName("chain_id")
    var chainId:Long = 0

    @SerializedName("env")
    var env: String? = null
}