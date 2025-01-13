import 'package:faceunity_ui_flutter/common/slider_view.dart';
import 'package:faceunity_ui_flutter/modules/skin/skin_model.dart';
import 'package:faceunity_ui_flutter/modules/skin/skin_view_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:faceunity_ui_flutter/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SkinView extends StatefulWidget {
  const SkinView({super.key});

  @override
  State<StatefulWidget> createState() {
    return SkinViewState();
  }

}

class SkinViewState extends State<SkinView> {
  SkinViewModel viewModel = SkinViewModel();

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil.getScreenW(context);

    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Consumer<SkinViewModel>(
        builder: (context, value, child) {
          double sliderValue = 0;
          bool defaulInMiddle = false;
          SkinModel? skinModel;
          if (viewModel.skins.isNotEmpty && viewModel.selectedIndex >= 0) {
            sliderValue = viewModel.skins[viewModel.selectedIndex].currentValue / viewModel.skins[viewModel.selectedIndex].ratio;
            defaulInMiddle = viewModel.skins[viewModel.selectedIndex].defaultValueInMiddle;
            skinModel = viewModel.skins[viewModel.selectedIndex];
          }
          return Container(
            color: const Color.fromARGB(200, 0, 0, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.up,
                children: [
                  _providerList(width),
                  viewModel.selectedIndex >= 0 ?
                  SizedBox(
                    height: 50,
                    width: skinModel?.extra != null ? width - 30 : width - 112,
                    child: Row(
                      children: [
                        if (skinModel?.extra != null) _expandSlider(100, 30, skinModel),
                        Expanded(child: SliderView(
                          value: sliderValue,
                          defaulInMiddle: defaulInMiddle,
                          onChanged: (value) {
                            // 程度值变化
                            viewModel.setSkinIntensity(value);
                          },
                          onChangeEnd: () {
                            // 滑动结束，需要刷新列表
                            setState(() {
                            });
                          },
                        ))
                      ],
                    ),
                  ) : const SizedBox(
                    height: 50,
                  )
                ],
              )
            )
          );
        },
      ),
    );
  }

  Widget _providerList(double screenWidth) {
    // 是否默认值
    bool isDefault = viewModel.isDefaultValue;
    return SizedBox(
      height: 98,
      child: Row(
        children: [
          SizedBox(
            width: 68,
            child: Opacity(
              opacity: isDefault ? 0.6 : 1,
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
                ),
                onPressed: () {
                  if (!isDefault) {
                    showAlertDialog(
                      context: context,
                      content: "是否将所有参数恢复到默认值",
                      comformPressed: () {
                        viewModel.recoverAllSkinValuesToDefault();
                      },
                    );
                    // viewModel.recoverAllSkinValuesToDefault();
                  }
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 44,
                      width: 44,
                      child: Image(
                        image: CommonUtil.assetImageNamed("common/recover"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                      width: 44,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("恢复", style: TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center,),
                      )
                    )
                  ],
                )
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            endIndent: 54,
            indent: 20,
            color: Color.fromARGB(51, 229, 229, 229),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left:4),
              itemBuilder: (context, index) {
                return _itemCell(index);
              },
              itemCount: viewModel.skins.length,
              scrollDirection: Axis.horizontal
            ),
          )
        ],
      )
    );
  }

  Widget _expandSlider(double width, double height, SkinModel? skinModel) {
    if (skinModel?.extra == null) return const SizedBox();
    SkinExtraModel extra = skinModel!.extra!;
    bool selectedLeft = extra.value == extra.defaultValue;
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(top: 8,bottom: 8, right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: selectedLeft ? Colors.white : Colors.transparent,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25.0), bottomLeft: Radius.circular(25.0)),
                ), alignment: Alignment.center,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        extra.value = 0.0;
                        viewModel.setSkinExtra(extra);
                      });
                    }, child: Text(extra.leftText, style: TextStyle(fontSize: 11, color:  selectedLeft ? const Color.fromARGB(255, 9, 0, 23) : const Color.fromARGB(153, 255, 255, 255),),))),
          ),
          Expanded(
            child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: !selectedLeft ? Colors.white : Colors.transparent,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(25.0), bottomRight: Radius.circular(25.0)),
                ), alignment: Alignment.center,
                child: InkWell(
                    onTap: (){
                      setState(() {
                        if (viewModel.devicePerformanceLevel >= extra.supportDeviceLevel) {
                          extra.value = 1.0;
                          viewModel.setSkinExtra(extra);
                        }else {
                          showCommonToast(context: context, content: "${extra.title}功能仅支持在高端机型上使用");
                        }
                      });
                    },
                    child: Text(extra.rightText, style: TextStyle(fontSize: 11, color:  !selectedLeft ? const Color.fromARGB(255, 9, 0, 23) : const Color.fromARGB(153, 255, 255, 255),),))),
          ),
        ],
      ),
    );
  }


  Widget _itemCell(int index) {
    SkinModel skin = viewModel.skins[index];
    String name = skin.name;
    bool disabled = !_deviceCheck(skin);

    String imageName;
    Color textColor = Colors.white;
    if (disabled) {
      imageName = "$name-0";
    } else {
      if (viewModel.selectedIndex == index) {
        imageName = skin.currentValue > 0.01 ? "$name-3" : "$name-2";
        textColor = const Color.fromARGB(255, 94, 199, 254);
      } else {
        imageName = skin.currentValue > 0.01 ? "$name-1" : "$name-0";
        textColor = Colors.white;
      }
    }

    return Opacity(
      opacity: disabled ? 0.6 : 1.0,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
        ),
        onPressed: () {
          if (!disabled) {
            setState(() {
              viewModel.setSelectedIndex(index);
            });
          } else {
            showCommonToast(context: context, content: "${skin.name}功能仅支持在高端机型上使用");
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 44,
              width: 44,
              child: Image(
                image: CommonUtil.assetImageNamed("skin/$imageName"),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 24,
              width: 44,
              child: Align(
                alignment: Alignment.center,
                child: Text(name, style: TextStyle(fontSize: 10, color: textColor), textAlign: TextAlign.center,),
              )
            )
          ],
        )
      ),
    );
  }

  bool _deviceCheck(SkinModel skin) {
    return viewModel.isSupport(skin);
  }
}
