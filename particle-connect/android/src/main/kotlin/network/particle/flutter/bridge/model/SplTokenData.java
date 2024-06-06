package network.particle.flutter.bridge.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;

@Keep
public class SplTokenData {

    @SerializedName("chainId")
    public Integer chainId;

    @SerializedName("address")
    public String address;

    @SerializedName("symbol")
    public String symbol;

    @SerializedName("name")
    public String name;

    @SerializedName("decimals")
    public Integer decimals;

    @SerializedName("logoURI")
    public String logoURI;

    public SplTokenData(Integer chainId, String address, String symbol, String name,
            Integer decimals, String logoURI) {
        this.chainId = chainId;
        this.address = address;
        this.symbol = symbol;
        this.name = name;
        this.decimals = decimals;
        this.logoURI = logoURI;
    }
}
