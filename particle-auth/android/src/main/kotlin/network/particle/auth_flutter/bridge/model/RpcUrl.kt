package network.particle.auth_flutter.bridge.model;

import com.google.gson.annotations.SerializedName;

public class RpcUrl {

    @SerializedName("evm_url")
    public String evmUrl;

    @SerializedName("sol_url")
    public String solUrl;
}
