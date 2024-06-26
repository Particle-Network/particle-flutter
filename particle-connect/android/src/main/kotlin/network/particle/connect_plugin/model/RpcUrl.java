package network.particle.connect_plugin.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;
@Keep
public class RpcUrl {

    @SerializedName("evm_url")
    public String evmUrl;

    @SerializedName("sol_url")
    public String solUrl;
}
