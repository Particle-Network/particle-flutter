package network.particle.flutter.bridge.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;

import java.util.List;

@Keep
public class AddCustomTokenData {

    @SerializedName("address")
    public String address;

    @SerializedName("token_addresses")
    public List<String> tokenAddress;

}
