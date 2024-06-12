package network.particle.authcore_flutter.utils;

import com.particle.base.ParticleNetwork
import com.particle.base.utils.Base58Utils

object MessageProcess {

  fun start(message: String): String {
    return if (ParticleNetwork.isEvmChain()) {
      if (isHexadecimal(message)) {
        message
      } else {
        EncodeUtils.encode(message)
      }
    } else {
      if(isBase58(message)){
        message
      }else{
        Base58Utils.encode(message.toByteArray(Charsets.UTF_8))
      }
    }
  }

  private fun isBase58(input: String): Boolean {
    var isBase58 = true
    try {
      Base58Utils.decode(input)
    } catch (e: Exception) {
      isBase58 = false
    }
    return isBase58
  }

  private fun isHexadecimal(input: String): Boolean {
    val regex = Regex("[0-9A-Fa-f]+")
    return input.isNotEmpty() && input.startsWith("0x") && input.substring(2).matches(regex)
  }
}
