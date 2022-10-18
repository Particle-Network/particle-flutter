package network.particle.flutter.bridge.utils;

import com.particle.base.ChainInfo;
import com.particle.base.ChainName;

import java.lang.reflect.Constructor;


public class ChainUtils {

    public static ChainInfo getChainInfo(String chainName, String chainIdName) {
        if (ChainName.BSC.toString().equals(chainName)) {
            chainName = "Bsc";
        }
        try {
            Class clazz1 = Class.forName("com.particle.base." + chainName + "Chain");
            Constructor cons = clazz1.getConstructor(String.class);
            ChainInfo chainInfo = (ChainInfo) cons.newInstance(chainIdName);
            return chainInfo;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }
}
