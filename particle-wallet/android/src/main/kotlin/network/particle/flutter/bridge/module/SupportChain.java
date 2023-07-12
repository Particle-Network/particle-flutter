package network.particle.flutter.bridge.module;

import com.google.gson.annotations.SerializedName;
import com.particle.base.model.DAppMetadata;


public class SupportChain {

    @SerializedName("chain_name")
    public String chainName;

    @SerializedName("chain_id")
    public int chainId;

    @SerializedName("chain_id_name")
    public String chainIdName;

    @SerializedName("env")
    public String env;

    @SerializedName("metadata")
    public DAppMetadata metadata;


}
