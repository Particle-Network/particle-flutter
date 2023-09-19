package com.particleauthcore.model;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

public class ReactCallBack<T> {

    public enum FlutterCallBackStatus {
        Failed, Success;
    }

    @SerializedName("status")
    public int status;

    @SerializedName("data")
    public T t;

    public ReactCallBack(FlutterCallBackStatus status, T t) {
        this.status = status.ordinal();
        this.t = t;
    }
    public static ReactCallBack successStr() {
        return new ReactCallBack(FlutterCallBackStatus.Success,"success");
    }
    public static <T> ReactCallBack success(T t) {
        return new ReactCallBack(FlutterCallBackStatus.Success, t);
    }
    public static ReactCallBack failedStr() {
        return new ReactCallBack(FlutterCallBackStatus.Failed, "failed");
    }
    public static <T> ReactCallBack failed(T t) {
        return new ReactCallBack(FlutterCallBackStatus.Failed, t);
    }

    public String toGson() {
        return new Gson().toJson(this);
    }
}
