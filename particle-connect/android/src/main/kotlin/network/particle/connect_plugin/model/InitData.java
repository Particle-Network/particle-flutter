package network.particle.connect_plugin.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;
import com.particle.base.model.DAppMetadata;

@Keep
public class InitData {

    @SerializedName("chain_name")
    public String chainName;

    @SerializedName("chain_id")
    public long chainId;

    @SerializedName("env")
    public String env;

    @SerializedName("metadata")
    public DAppMetadata metadata;

    @SerializedName("rpc_url")
    public RpcUrl rpcUrl;
}
