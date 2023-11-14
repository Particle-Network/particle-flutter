package network.particle.auth_core_flutter.bridge.utils

import network.particle.chains.ChainInfo

object ChainUtils {
    fun getChainInfo(chainId: Long): ChainInfo {
        return getChainInfoByChainId(chainId)
    }

    private fun getChainInfoByChainId(chainId: Long): ChainInfo {
        return ChainInfo.getEvmChain(chainId) ?: ChainInfo.getSolanaChain(chainId) ?: ChainInfo.getEvmChain(1)!!
    }
}
