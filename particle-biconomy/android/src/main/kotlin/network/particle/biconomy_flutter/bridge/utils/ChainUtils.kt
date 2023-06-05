package network.particle.biconomy_flutter.bridge.utils

import com.particle.base.ChainInfo
import com.particle.base.ChainName

object ChainUtils {
    fun getChainInfo(chainName: String, chainIdName: String?): ChainInfo {
        var chainName = chainName
        if (ChainName.BSC.toString() == chainName) {
            chainName = "Bsc"
        }
        return try {
            val clazz1 = Class.forName("com.particle.base." + chainName + "Chain")
            val cons = clazz1.getConstructor(String::class.java)
            cons.newInstance(chainIdName) as ChainInfo
        } catch (e: Exception) {
            e.printStackTrace()
            throw RuntimeException(e.message)
        }
    }
}