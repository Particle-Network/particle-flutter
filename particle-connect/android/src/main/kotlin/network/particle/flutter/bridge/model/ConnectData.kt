package network.particle.flutter.bridge.model

import com.google.gson.annotations.SerializedName

data class ConnectData(
    @SerializedName("wallet_type") val walletType: String,
    @SerializedName("particle_connect_config") val particleConnectConfig: ParticleConnectConfig?
)

data class ParticleConnectConfig(
    @SerializedName("login_type") var loginType: String,
    @SerializedName("account") var account: String = "",
    @SerializedName("login_form_mode") var loginFormMode: Boolean = false,
    @SerializedName("support_auth_type_values") var supportAuthTypeValues: List<String> = arrayListOf()
)