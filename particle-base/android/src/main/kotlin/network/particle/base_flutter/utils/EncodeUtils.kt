package network.particle.base_flutter.utils

import com.particle.base.ParticleNetwork
import network.particle.base_flutter.utils.Base58Utils

object EncodeUtils {
    fun encode(message: String): String {
        return if (ParticleNetwork.isEvmChain()) {
            HexUtils.encodeWithPrefix(message.toByteArray(Charsets.UTF_8))
        } else {
            Base58Utils.encode(message.toByteArray(Charsets.UTF_8))
        }
    }
}