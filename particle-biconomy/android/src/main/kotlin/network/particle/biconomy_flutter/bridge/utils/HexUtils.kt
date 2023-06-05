package network.particle.biconomy_flutter.bridge.utils

import org.apache.commons.codec.DecoderException
import org.apache.commons.codec.binary.Hex

/**
 * Created by chaichuanfa on 2022/7/18
 */
object HexUtils {

    @Throws(DecoderException::class)
    fun decode(data: String): ByteArray {
        return Hex.decodeHex(data)
    }

    fun encode(bytes: ByteArray, prefix: String = ""): String {
        return "${prefix}${String(Hex.encodeHex(bytes))}"
    }

    fun encodeWithPrefix(bytes: ByteArray): String {
        return encode(bytes, "0x")
    }

    fun removePrefix(input: String, prefix: String = "0x"): String {
        if (input.startsWith(prefix)) {
            return input.replaceFirst(prefix, "")
        }
        return input
    }

}