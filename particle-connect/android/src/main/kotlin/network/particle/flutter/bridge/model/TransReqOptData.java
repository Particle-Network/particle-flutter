package network.particle.flutter.bridge.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;

@Keep
public class TransReqOptData {

    @SerializedName("address")
    public String address;

    @SerializedName("before")
    public String before;

    @SerializedName("mint_address")
    public String mint;

    @SerializedName("until")
    public String until;

    @SerializedName("limit")
    public int limit;

    public TransReqOptData(String address, String before, String until, int limit) {
        this.address = address;
        this.before = before;
        this.until = until;
        this.limit = limit;
    }
}
