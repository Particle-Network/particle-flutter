package network.particle.flutter.bridge.utils

import com.particle.base.ParticleNetwork
import network.particle.unity.utils.HexUtils

object EncodeUtils {
    fun encode(message: String): String {
        return if (ParticleNetwork.isEvmChain()) {
            HexUtils.encodeWithPrefix(message.toByteArray(Charsets.UTF_8))
        } else {
            Base58Utils.encode(message.toByteArray(Charsets.UTF_8))
        }
    }
}