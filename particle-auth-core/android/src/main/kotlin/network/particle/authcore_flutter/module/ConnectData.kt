package network.particle.authcore_flutter.module

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.particle.base.model.LoginPageConfig
import com.particle.base.model.LoginPrompt

@Keep
data class ConnectData(
    @SerializedName("login_type")
    val loginType: String,
    @SerializedName("account")
    val account: String?,
    @SerializedName("support_auth_type_values")
    val supportLoginTypes: List<String>? = null,
    @SerializedName("login_page_config")
    val loginPageConfig: LoginPageConfig? = null,
    @SerializedName("social_login_prompt")
    val prompt: LoginPrompt? = null
)


