package network.particle.auth_flutter.bridge.model

import com.google.gson.Gson
import com.google.gson.annotations.SerializedName

class FlutterCallBack<T>(status: FlutterCallBackStatus, t: T) {
    enum class FlutterCallBackStatus {
        Failed, Success
    }

    @SerializedName("status")
    var status: Int

    @SerializedName("data")
    var t: T

    init {
        this.status = status.ordinal
        this.t = t
    }

    fun toGson(): String {
        return Gson().toJson(this)
    }

    companion object {
        fun successStr(): FlutterCallBack<*> {
            return FlutterCallBack<Any?>(FlutterCallBackStatus.Success, "success")
        }

        fun <T> success(t: T): FlutterCallBack<*> {
            return FlutterCallBack<Any?>(FlutterCallBackStatus.Success, t)
        }

        fun failedStr(): FlutterCallBack<*> {
            return FlutterCallBack<Any?>(FlutterCallBackStatus.Failed, "failed")
        }

        fun <T> failed(t: T): FlutterCallBack<*> {
            return FlutterCallBack<Any?>(FlutterCallBackStatus.Failed, t)
        }
    }
}