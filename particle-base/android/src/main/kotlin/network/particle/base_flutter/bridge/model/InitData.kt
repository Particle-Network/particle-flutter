package network.particle.auth_flutter.bridge.model

import com.google.gson.annotations.SerializedName

class InitData {
    @SerializedName("chain_name")
    var chainName: String? = null

    @SerializedName("chain_id")
    var chainId: Long = 0

    @SerializedName("chain_id_name")
    var chainIdName: String? = null

    @SerializedName("env")
    var env: String? = null
}