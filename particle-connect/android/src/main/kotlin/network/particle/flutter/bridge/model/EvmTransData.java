package network.particle.flutter.bridge.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;
@Keep
public class EvmTransData {

    @SerializedName("from")
    public String from;

    @SerializedName("to")
    public String to;

    @SerializedName("hash")
    public String hash;

    @SerializedName("value")
    public String value;

    @SerializedName("data")
    public String data;

    @SerializedName("gasLimit")
    public String gasLimit;

    @SerializedName("gasSpent")
    public String gasSpent;

    @SerializedName("gasPrice")
    public String gasPrice;

    @SerializedName("fees")
    public String fees;

    @SerializedName("type")
    public Integer type;

    @SerializedName("nonce")
    public String nonce;

    @SerializedName("maxPriorityFeePerGas")
    public String maxPriorityFeePerGas;

    @SerializedName("maxFeePerGas")
    public String maxFeePerGas;

    @SerializedName("timestamp")
    public Long timestamp;

    @SerializedName("status")
    public Integer status;

    public EvmTransData(String from, String to, String hash, String value, String data,
            String gasLimit, String gasSpent, String gasPrice, String fees, Integer type,
            String nonce, String maxPriorityFeePerGas, String maxFeePerGas, Long timestamp,
            Integer status) {
        this.from = from;
        this.to = to;
        this.hash = hash;
        this.value = value;
        this.data = data;
        this.gasLimit = gasLimit;
        this.gasSpent = gasSpent;
        this.gasPrice = gasPrice;
        this.fees = fees;
        this.type = type;
        this.nonce = nonce;
        this.maxPriorityFeePerGas = maxPriorityFeePerGas;
        this.maxFeePerGas = maxFeePerGas;
        this.timestamp = timestamp;
        this.status = status;
    }
}
