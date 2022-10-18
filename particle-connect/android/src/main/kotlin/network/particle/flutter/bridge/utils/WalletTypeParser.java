package network.particle.flutter.bridge.utils;

import androidx.annotation.NonNull;


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

}
