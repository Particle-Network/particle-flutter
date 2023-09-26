package network.particle.auth_core_flutter.bridge.model

import com.google.gson.annotations.SerializedName

class FlutterErrorMessage {
    @SerializedName("code")
    var code = 0

    @SerializedName("message")
    var message: String? = null

    constructor(code: Int, message: String?) {
        this.code = code
        this.message = message
    }

    constructor() {}

    companion object {
        const val ExceptionCode = 10000
        fun exceptionMsg(message: String?): FlutterErrorMessage {
            return FlutterErrorMessage(ExceptionCode, message)
        }
    }
}
