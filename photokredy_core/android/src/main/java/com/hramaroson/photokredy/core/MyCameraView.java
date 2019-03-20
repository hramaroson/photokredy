package com.hramaroson.photokredy.core;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.view.View;

import com.otaliastudios.cameraview.CameraView;
import com.otaliastudios.cameraview.Mode;
import com.otaliastudios.cameraview.Flash;
import com.otaliastudios.cameraview.Audio;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.platform.PlatformView;

public class MyCameraView implements PlatformView, MethodCallHandler,
        Application.ActivityLifecycleCallbacks {

    private final CameraView mCameraView;
    private final MethodChannel mMethodChanel;
    private final Context mContext;

    MyCameraView(Context context, BinaryMessenger messenger, int id, Activity activity) {
        mContext = context;
        mCameraView = new CameraView(context);
        mMethodChanel = new MethodChannel(messenger, "plugins.hramaroson.github.io/cameraview_" + id);
        mMethodChanel.setMethodCallHandler(this);

        activity.getApplication().registerActivityLifecycleCallbacks(this);

        mCameraView.setMode(Mode.PICTURE);
        mCameraView.setAudio(Audio.OFF);

        mCameraView.open();

    }

    @Override
    public View getView() {
        return mCameraView;
    }

    @Override
    public void dispose(){
        mCameraView.destroy();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "setFlash":
                setFlash(methodCall, result);
                break;
            case "getFlash":
                getFlash(methodCall, result);
                break;
        }
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {}

    @Override
    public void onActivityStarted(Activity activity) {
        mCameraView.open();
    }

    @Override
    public void onActivityResumed (Activity activity) {
        mCameraView.open();
    }

    @Override
    public void onActivityPaused(Activity activity) {
        mCameraView.close();
    }

    @Override
    public void onActivityStopped(Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {}

    @Override
    public void onActivityDestroyed(Activity activity) {
        mCameraView.destroy();
    }

    private static Flash __flashValueFromIndex(int index){
        switch (index){
            case 0:
                return Flash.OFF;
            case 1:
                return Flash.TORCH;
            default:
                break;
        }
        return Flash.OFF;
    }

    private static int __flashIndexFromValue(Flash flash){
        switch (flash){
            case OFF:
                return 0;
            case TORCH:
                return 1;
            default:
                break;
        }
        return 0;
    }

    private void setFlash(MethodCall methodCall, MethodChannel.Result result){
        if (mCameraView.isOpened() && !mCameraView.isTakingPicture() && !mCameraView.isTakingVideo()){
            mCameraView.setFlash(__flashValueFromIndex((int) methodCall.arguments));
            result.success (true);
            return;
        }
        result.success(false);
    }

    private void getFlash(MethodCall methodCall, MethodChannel.Result result){
        if(mCameraView.isOpened()){
            result.success(__flashIndexFromValue(mCameraView.getFlash()));
            return;
        }
        result.success(null);
    }
}