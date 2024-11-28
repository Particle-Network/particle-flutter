package network.particle.connect_plugin.utils;

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
            com.particle.base.utils.Base58Utils.encode(message.toByteArray(Charsets.UTF_8))
        }

    }


    fun processTypedData(message: String): String {
        return if (ParticleNetwork.isEvmChain()) {
            if (isHexadecimal(message)) {
                String(com.particle.base.utils.HexUtils.decode(com.particle.base.utils.HexUtils.removePrefix(message)))
            } else {
                message
            }
        } else {
            com.particle.base.utils.Base58Utils.encode(message.toByteArray(Charsets.UTF_8))
        }

    }

    private fun isHexadecimal(input: String): Boolean {
        val regex = Regex("[0-9A-Fa-f]+")
        return input.isNotEmpty() && input.startsWith("0x") && input.substring(2).matches(regex)
    }
}