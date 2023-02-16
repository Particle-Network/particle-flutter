package network.particle.auth_flutter.bridge.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;


public class LoginData {

    @SerializedName("login_type")
    public String loginType;

    public String account;

    @SerializedName("support_auth_type_values")
    public List<String> supportAuthTypeValues;

    @SerializedName("social_login_prompt")
    public String prompt;

    @SerializedName("login_form_mode")
    public Boolean loginFormMode;
}
