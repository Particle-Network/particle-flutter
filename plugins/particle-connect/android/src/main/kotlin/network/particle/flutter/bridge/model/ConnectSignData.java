package network.particle.flutter.bridge.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ConnectSignData {

    @SerializedName("wallet_type")
    public String walletType;

    @SerializedName("public_address")
    public String publicAddress;

    //transactions
    @SerializedName("transactions")
    public List<String> transactions;

    @SerializedName("transaction")
    public String transaction;

    @SerializedName("message")
    public String message;

    @SerializedName("version")
    public String version;

    @SerializedName("mnemonic")
    public String mnemonic;

    @SerializedName("private_key")
    public String privateKey;

    @SerializedName("domain")
    public String domain;

    @SerializedName("uri")
    public String uri;

    @SerializedName("signature")
    public String signature;

}
