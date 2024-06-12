package network.particle.connect_plugin.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;

import java.util.List;

@Keep
public class LoginData {

    @SerializedName("login_type")
    public String loginType;

    public String account;

    @SerializedName("support_auth_type_values")
    public List<String> supportAuthTypeValues;
}
