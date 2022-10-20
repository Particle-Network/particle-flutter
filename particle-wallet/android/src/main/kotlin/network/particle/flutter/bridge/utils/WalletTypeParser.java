package network.particle.flutter.bridge.utils;

import androidx.annotation.NonNull;

import com.particle.api.infrastructure.db.table.WalletType;

public class WalletTypeParser {

    public enum WalletTypeUnity {
        Particle,
        EthereumPrivateKey,
        SolanaPrivateKey,
        MetaMask,
        Rainbow,
        Trust,
        ImToken,
        BitKeep,
        WalletConnect,
        Phantom;

        @NonNull
        @Override
        public String toString() {
            return super.toString().toUpperCase();
        }
    }

    public static WalletType getWalletType(String walletType) {
        walletType = walletType.toUpperCase();
        if (walletType.equals(WalletTypeUnity.Particle.toString())) {
            return WalletType.PN_WALLET;
        } else if (walletType.equals(WalletTypeUnity.EthereumPrivateKey.toString())) {
            return WalletType.ETH_IMPORT;
        } else if (walletType.equals(WalletTypeUnity.SolanaPrivateKey.toString())) {
            return WalletType.SOL_IMPORT;
        } else if (walletType.equals(WalletTypeUnity.MetaMask.toString())) {
            return WalletType.CONNET_METAMASK;
        } else if (walletType.equals(WalletTypeUnity.Rainbow.toString())) {
            return WalletType.CONNET_RAINBOW;
        } else if (walletType.equals(WalletTypeUnity.Trust.toString())) {
            return WalletType.CONNET_TRUST;
        } else if (walletType.equals(WalletTypeUnity.ImToken.toString())) {
            return WalletType.CONNET_IMTOKEN;
        } else if (walletType.equals(WalletTypeUnity.BitKeep.toString())) {
            return WalletType.CONNET_BITKEEP;
        } else if (walletType.equals(WalletTypeUnity.WalletConnect.toString())) {
            return WalletType.CONNET_WALLET;
        } else if (walletType.equals(WalletTypeUnity.Phantom.toString())) {
            return WalletType.CONNET_PHANTOM;
        }
        return WalletType.PN_WALLET;
    }
}
