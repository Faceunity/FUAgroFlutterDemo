# faceunity_ui

### 相芯UI部分做的事:

 #### 1. 利用UI页面来调节配置FURenderKit所需要的参数

#### 2. UI通过faceunity_plugin 来把数据传输给native，最终由Native 来和[FURenderKit shareInstance] 进行接口通信，



### 注意事项 + 一般Flutter 项目跑起来的步骤

### 大前提：

#### 1. 确保电脑已经安装Flutter 环境

#### 2. 确保电脑安装了cocoapods 的版本大于 1.10.0

#### 然后在终端进行操作

#### 1. 工程根目录调用Flutter pub get

#### 2. 在iOS 目录下  pod install 



## faceunity_ui 和 FaceUnity_Plugin关系以及组织结构

#### 1.由于公司暂时没有Flutter pub 类似的 publish 服务器所以暂时无法建立私有Flutter pub 仓库

#### 2. 目前相芯 Flutter对接第三方的组件平时开发都放到公司内部的gitlab上

#### 3. faceunity_ui git地址 git@192.168.0.118:songhongliu/FaceUnityUI.git

#### 4. FaceUnity_Plugin git地址:git@192.168.0.118:songhongliu/FaceUnity_Plugin.git

##### 5. FaceUnity_Plugin 是faceunity_ui对应的iOS native插件, 以gitsubModule形式被 faceunity_ui引用

##### 6. 集成到第三方demo 的时候可以直接拷贝faceunity_ui文件夹即可，去掉faceunity_ui目录下 隐藏文件.git和.gitmodules相关的内容，避免引起第三方demo git提交问题。



## 第三方Demo相关问题

#### 在第三方demo的相机数据流的代理或者专门的方法里面调用FURenderKit渲染即可。



## 第三方Demo 如果没有本地 图片数据处理插件怎么办？

#### 需要在第三方的pub 库下载插件之后在插件对应的 .podspec 内部添加   s.dependency 'FURenderKit' 依赖,必须要podinstall，否则xcode 报错找不到FURenderKit.h依赖，以便于使用FURenderKit能力，

#### 以TRTC为例:

#### 1. 先替换GenerateTestUserSig.dart 里面的sdkAppId和secretKey 腾讯账号相关。

#### 2. 添加第三方代理回调相关方法，需要那个demo就在那个demo里面添加，目前已经配置好TRTCCallingDemo 相关的三方代理回调，具体参考下面函数(全局搜索下Flutter 工程，看看加载哪些地方就明白了):

```dart
  /*
   * 设置本地视频的自定义渲染回调
   * returrn 纹理id
   */
  Future<int?> setLocalVideoRenderListener(
      String userId, bool isFront, int streamType, int width, int height);
```





#### 3.在tencent_trtc_cloud插件下的tencent_trtc_cloud.podspec里面添加  s.dependency 'FURenderKit' 依赖，然后pod install。

#### 4.在trtc 插件tencent_trtc_cloud 里面的TencentVideoTextureRender.mm文件的onProcessVideoFrame:dstFrame代理里面添加FURenderKit 相关渲染代码,具体代码范例如下(trtc把自己组件推到pub上，每次重新拉下来的代码是不包含FURenderKit相关代码，需要自行添加)

``````objective-c
- (uint32_t)onProcessVideoFrame:(TRTCVideoFrame *)srcFrame
                       dstFrame:(TRTCVideoFrame *)dstFrame {
    dstFrame.pixelBuffer = srcFrame.pixelBuffer;
    //走纹理
    if (srcFrame.textureId != 0) {
        CVPixelBufferRef buffer = srcFrame.pixelBuffer;
        _localBuffer = CVBufferRetain(buffer);
        
        
        _mContext = [EAGLContext currentContext];
        if ([FUGLContext shareGLContext].currentGLContext != _mContext) {
            [[FUGLContext shareGLContext] setCustomGLContext: _mContext];
        }
        
        FURenderInput *input = [[FURenderInput alloc] init];
        input.renderConfig.imageOrientation = FUImageOrientationUP;
        input.renderConfig.isFromFrontCamera = YES;
        input.renderConfig.stickerFlipH = YES;
        FUTexture tex = {srcFrame.textureId, CGSizeMake(srcFrame.width, srcFrame.height)};
        input.texture = tex;
        //开启重力感应，内部会自动计算正确方向，设置fuSetDefaultRotationMode，无须外面设置
        input.renderConfig.gravityEnable = YES;
        input.renderConfig.textureTransform = CCROT0_FLIPVERTICAL;
        FURenderOutput *output = [[FURenderKit shareRenderKit] renderWithInput:input];
        dstFrame.textureId = output.texture.ID;
        
        //触发Flutter 调用 copyPixelBuffer
        _callback();
        
        if (output.texture.ID != 0) {
            return output.texture.ID;
        }
    }
    return 0;
}
``````





##### 





