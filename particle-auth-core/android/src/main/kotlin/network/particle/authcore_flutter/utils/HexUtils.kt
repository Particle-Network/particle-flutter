package network.particle.authcore_flutter.utils;

import org.apache.commons.codec.DecoderException
import org.apache.commons.codec.binary.Hex


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
