package network.particle.auth_flutter.bridge.model

import com.google.gson.annotations.SerializedName
import com.particle.network.service.model.LoginAuthorization

class LoginData {
    @SerializedName("login_type")
    var loginType: String? = null
    var account: String? = null

    @SerializedName("support_auth_type_values")
    var supportAuthTypeValues: List<String>? = null

    @SerializedName("social_login_prompt")
    var prompt: String? = null

    @SerializedName("login_form_mode")
    var loginFormMode: Boolean? = null

    @SerializedName("authorization")
    val authorization: LoginAuthorization? = null
}