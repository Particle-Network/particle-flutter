package network.particle.wallet_plugin.module;

import com.google.gson.annotations.SerializedName;
import com.particle.base.model.DAppMetadata;


public class SupportChain {

    @SerializedName("chain_name")
    public String chainName;

    @SerializedName("chain_id")
    public long chainId;



    @SerializedName("env")
    public String env;

    @SerializedName("metadata")
    public DAppMetadata metadata;


}
