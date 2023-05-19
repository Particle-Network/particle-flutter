package network.particle.auth_flutter.bridge.model;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

public class FlutterCallBack<T> {

    public enum FlutterCallBackStatus {
        Failed, Success;
    }

    @SerializedName("status")
    public int status;

    @SerializedName("data")
    public T t;

    public FlutterCallBack(FlutterCallBackStatus status, T t) {
        this.status = status.ordinal();
        this.t = t;
    }
    public static  FlutterCallBack successStr() {
        return new FlutterCallBack(FlutterCallBackStatus.Success,"success");
    }
    public static <T> FlutterCallBack success(T t) {
        return new FlutterCallBack(FlutterCallBackStatus.Success, t);
    }
    public static FlutterCallBack failedStr() {
        return new FlutterCallBack(FlutterCallBackStatus.Failed, "failed");
    }
    public static <T> FlutterCallBack failed(T t) {
        return new FlutterCallBack(FlutterCallBackStatus.Failed, t);
    }

    public String toGson() {
        return new Gson().toJson(this);
    }
}
