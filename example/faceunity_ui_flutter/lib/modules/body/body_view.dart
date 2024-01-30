import 'package:faceunity_ui_flutter/common/slider_view.dart';
import 'package:faceunity_ui_flutter/modules/body/body_model.dart';
import 'package:faceunity_ui_flutter/modules/body/body_view_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:faceunity_ui_flutter/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyView extends StatefulWidget {
  const BodyView({super.key});

  @override
  State<StatefulWidget> createState() {
    return BodyViewState();
  }
}

class BodyViewState extends State<BodyView> {
  BodyViewModel viewModel = BodyViewModel();
  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil.getScreenW(context);
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Consumer<BodyViewModel>(
        builder: (context, value, child) {
          double sliderValue = 0;
          bool defaulInMiddle = false;
          if (viewModel.bodies.isNotEmpty && viewModel.selectedIndex >= 0) {
            sliderValue = viewModel.bodies[viewModel.selectedIndex].currentValue;
            defaulInMiddle = viewModel.bodies[viewModel.selectedIndex].defaultValueInMiddle;
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
                    width: width - 112,
                    child: SliderView(
                      value: sliderValue,
                      defaulInMiddle: defaulInMiddle,
                      onChanged: (value) {
                        // 程度值变化
                        viewModel.setBodyIntensity(value);
                      },
                      onChangeEnd: () {
                        // 滑动结束，需要刷新列表
                        setState(() {
                        });
                      },
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
                        viewModel.recoverAllBodyValuesToDefault();
                      },
                    );
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
              itemCount: viewModel.bodies.length,
              scrollDirection: Axis.horizontal
            ),
          )
        ],
      )
    );
  }

  Widget _itemCell(int index) {
    BodyModel body = viewModel.bodies[index];
    String name = body.name;

    String imageName;
    Color textColor = Colors.white;

    bool changed = false;
    if (body.defaultValueInMiddle) {
      changed = (body.currentValue - 0.5).abs() > 0.01;
    } else {
      changed = body.currentValue > 0.01;
    }
    if (viewModel.selectedIndex == index) {
      imageName = changed ? "$name-3" : "$name-2";
      textColor = const Color.fromARGB(255, 94, 199, 254);
    } else {
      imageName = changed ? "$name-1" : "$name-0";
      textColor = Colors.white;
    }
    
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
      ),
      onPressed: () {
        setState(() {
          viewModel.setSelectedIndex(index);
        });
      }, 
      child: Column(
        children: [
          SizedBox(
            height: 44,
            width: 44,
            child: Image(
              image: CommonUtil.assetImageNamed("body/$imageName"),
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
    );
  }
}