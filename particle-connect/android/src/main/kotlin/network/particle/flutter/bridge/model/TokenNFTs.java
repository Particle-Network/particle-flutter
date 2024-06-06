package network.particle.flutter.bridge.model;

import androidx.annotation.Keep;

import com.google.gson.annotations.SerializedName;

import java.util.List;
@Keep
public class TokenNFTs {

    @SerializedName("tokens")
    public List<TokensDTO> tokens;

    @SerializedName("nfts")
    public List<NftsDTO> nfts;

    public static class TokensDTO {

        @SerializedName("mintAddress")
        public String mintAddress;

        @SerializedName("amount")
        public String amount;

        @SerializedName("decimals")
        public Integer decimals;

        @SerializedName("updateAt")
        public Long updateAt;

        @SerializedName("symbol")
        public String symbol;

        @SerializedName("logoURI")
        public String logoURI;

        public TokensDTO(String mintAddress, String amount, Integer decimals, Long updateAt,
                String symbol, String logoURI) {
            this.mintAddress = mintAddress;
            this.amount = amount;
            this.decimals = decimals;
            this.updateAt = updateAt;
            this.symbol = symbol;
            this.logoURI = logoURI;
        }
    }


    public static class NftsDTO {

        @SerializedName("mintAddress")
        public String mintAddress;

        @SerializedName("image")
        public String image;

        @SerializedName("symbol")
        public String symbol;

        @SerializedName("name")
        public String name;

        @SerializedName("sellerFeeBasisPoints")
        public Integer sellerFeeBasisPoints;

        @SerializedName("description")
        public String description;

        @SerializedName("externalUrl")
        public String externalUrl;

        @SerializedName("animationUrl")
        public String animationUrl;

        @SerializedName("data")
        public String data;

        @SerializedName("isSemiFungible")
        public Boolean isSemiFungible;

        @SerializedName("tokenId")
        public String tokenId;

        @SerializedName("tokenBalance")
        public Integer tokenBalance;

        public NftsDTO(String mintAddress, String image, String symbol, String name,
                Integer sellerFeeBasisPoints, String description, String externalUrl,
                String animationUrl, String data, Boolean isSemiFungible, String tokenId,
                Integer tokenBalance) {
            this.mintAddress = mintAddress;
            this.image = image;
            this.symbol = symbol;
            this.name = name;
            this.sellerFeeBasisPoints = sellerFeeBasisPoints;
            this.description = description;
            this.externalUrl = externalUrl;
            this.animationUrl = animationUrl;
            this.data = data;
            this.isSemiFungible = isSemiFungible;
            this.tokenId = tokenId;
            this.tokenBalance = tokenBalance;
        }
    }
}
