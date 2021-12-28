package im.zego.capture;

/**
 * Created by Sven on 12/10/2020
 */
public interface ICaptureCamera {
    int setFrontCam(int bFront);
    // 停止预览
    int stopPreview();
    void enableCamera(boolean enable);
}
