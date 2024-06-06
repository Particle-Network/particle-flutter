package network.particle.flutter.bridge.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;

@Keep
public class ChainData {

    @SerializedName("chain_id")
    public long chainId;

    @SerializedName("chain_id_name")
    public String chainIdName;

    @SerializedName("env")
    public String env;
}
