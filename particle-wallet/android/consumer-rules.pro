-keep class network.particle.**{*;}
-dontwarn com.network.particle.**

# Keep particle gui classes to prevent R8 optimization
-keep class com.particle.gui.**{*;}
-keep @androidx.annotation.Keep class com.particle.gui.**{*;}
-keepclassmembers class com.particle.gui.**{
    *;
}

# Keep connect adapter classes
-keep class com.evm.adapter.**{*;}
-keep class com.solana.adapter.**{*;}
-keep class com.wallet.connect.adapter.**{*;}
-keep class com.phantom.adapter.**{*;}
-keep class com.connect.common.**{*;}
-keep class particle.auth.adapter.**{*;}