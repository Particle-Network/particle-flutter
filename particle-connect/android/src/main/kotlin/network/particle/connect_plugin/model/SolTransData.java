package network.particle.connect_plugin.model;
import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;

@Keep
public class SolTransData {

    @SerializedName("from")
    public String from;

    @SerializedName("to")
    public String to;

    @SerializedName("type")
    public String type;

    @SerializedName("lamportsChange")
    public Long lamportsChange;

    @SerializedName("lamportsFee")
    public Long lamportsFee;

    @SerializedName("signature")
    public String signature;

    @SerializedName("blockTime")
    public Long blockTime;

    @SerializedName("status")
    public Integer status;

    @SerializedName("data")
    public String data;

    @SerializedName("mint")
    public String mint;

    public SolTransData(String from, String to, String type, Long lamportsChange,
            Long lamportsFee, String signature, Long blockTime, Integer status,
            String data, String mint) {
        this.from = from;
        this.to = to;
        this.type = type;
        this.lamportsChange = lamportsChange;
        this.lamportsFee = lamportsFee;
        this.signature = signature;
        this.blockTime = blockTime;
        this.status = status;
        this.data = data;
        this.mint = mint;
    }
}
