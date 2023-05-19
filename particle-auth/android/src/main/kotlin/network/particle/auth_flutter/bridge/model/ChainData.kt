package network.particle.auth_flutter.bridge.model

import com.google.gson.annotations.SerializedName

class ChainData {
    @SerializedName("chain_name")
    var chainName: String? = null

    @SerializedName("chain_id")
    var chainId = 0

    @SerializedName("chain_id_name")
    var chainIdName: String? = null

    @SerializedName("env")
    var env: String? = null
}