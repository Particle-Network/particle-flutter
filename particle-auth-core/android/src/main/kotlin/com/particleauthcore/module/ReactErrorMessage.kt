package com.particleauthcore.module

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName

@Keep
class ReactErrorMessage {
    @SerializedName("code")
    var code = 0

    @SerializedName("message")
    var message: String? = null

    constructor(code: Int, message: String?) {
        this.code = code
        this.message = message
    }

    constructor()

    companion object {
        const val ExceptionCode = 10000
        fun exceptionMsg(message: String?): ReactErrorMessage {
            return ReactErrorMessage(ExceptionCode, message)
        }
    }
}
