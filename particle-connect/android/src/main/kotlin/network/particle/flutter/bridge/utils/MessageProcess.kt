package network.particle.flutter.bridge.utils

import com.particle.base.ParticleNetwork

object MessageProcess {

    fun start(message: String): String {
        return if (ParticleNetwork.isEvmChain()) {
            if (isHexadecimal(message)) {
                message
            } else {
                EncodeUtils.encode(message)
            }
        } else {
            message
        }

    }

    private fun isHexadecimal(input: String): Boolean {
        val regex = Regex("[0-9A-Fa-f]+")
        return input.isNotEmpty() && input.startsWith("0x") && input.substring(2).matches(regex)
    }
}