package com.particleauthcore.module;

import com.google.gson.annotations.SerializedName;

public class ReactErrorMessage {
    public static final int ExceptionCode = 10000;
    @SerializedName("code")
    public int code;

    @SerializedName("message")
    public String message;


    public ReactErrorMessage(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public ReactErrorMessage() {
    }

    public static ReactErrorMessage exceptionMsg(String message) {
        return new ReactErrorMessage(ExceptionCode, message);
    }


}
