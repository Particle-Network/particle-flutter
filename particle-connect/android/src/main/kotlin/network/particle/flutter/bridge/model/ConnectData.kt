package network.particle.flutter.bridge.model

import com.google.gson.annotations.SerializedName

data class ConnectData(
    @SerializedName("wallet_type") val walletType: String,
    @SerializedName("particle_connect_config") val particleConnectConfig: ParticleConnectConfigData?
)

data class ParticleConnectConfigData(
    @SerializedName("login_type") var loginType: String,
    @SerializedName("account") var account: String = "",
    @SerializedName("support_auth_type_values") var supportAuthTypeValues: List<String> = arrayListOf(),
    @SerializedName("social_login_prompt") var prompt: String? = null
)

