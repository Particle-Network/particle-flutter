package network.particle.connect_plugin.model;

import com.connect.common.model.ConnectError;
import com.google.gson.annotations.SerializedName;

public class FlutterErrorMessage {
    public static final int ExceptionCode = 10000;
    @SerializedName("code")
    public int code;

    @SerializedName("message")
    public String message;


    public FlutterErrorMessage(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public FlutterErrorMessage() {
    }

    public static FlutterErrorMessage exceptionMsg(String message) {
        return new FlutterErrorMessage(ExceptionCode, message);
    }

    public static FlutterErrorMessage parseConnectError(ConnectError error) {
        return new FlutterErrorMessage(error.getCode(), error.getMessage());
    }
}
