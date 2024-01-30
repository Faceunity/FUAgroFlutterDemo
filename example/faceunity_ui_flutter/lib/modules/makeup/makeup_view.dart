
import 'package:faceunity_ui_flutter/common/slider_view.dart';
import 'package:faceunity_ui_flutter/modules/makeup/makeup_view_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:faceunity_ui_flutter/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MakeupView extends StatefulWidget {
  const MakeupView({super.key});

  @override
  State<StatefulWidget> createState() {
    return MakeupViewState();
  }

}

class MakeupViewState extends State<MakeupView> {

  MakeupViewModel viewModel = MakeupViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Consumer<MakeupViewModel>(builder: (context, value, child) {
        return Container(
          color: const Color.fromARGB(200, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.up,
              children: [
                _providerList(),
                viewModel.selectedIndex > 0 ? 
                SizedBox(
                  height: 50,
                  width: ScreenUtil.getScreenW(context) - 112,
                  child: SliderView(
                    value: viewModel.makeups.isNotEmpty ? viewModel.makeups[viewModel.selectedIndex].value : 0,
                    onChanged: (value) {
                      viewModel.setMakeupIntensity(value);
                    },
                  ),
                ) : const SizedBox(
                  height: 50,
                )
              ],
            )
          )
        );
      },),
    );
  }

  Widget _providerList() {
    return SizedBox(
      height: 98,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        itemBuilder: (context, index) {
          return _itemCell(index);
        },
        itemCount: viewModel.makeups.length,
        scrollDirection: Axis.horizontal
      )
    );
  }

  Widget _itemCell(int index) {
    String makeupName = viewModel.makeups[index].name;
    String makeupIcon = viewModel.makeups[index].icon;
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
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              border: Border.all(
                color: viewModel.selectedIndex == index ? const Color(0xFF5EC7FE) : Colors.transparent,
                width: 2
              ),
              borderRadius: BorderRadius.circular(3.0)
            ),
            child: Image(
              image: CommonUtil.assetImageNamed("makeup/$makeupIcon"),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 16,
            width: 54,
            child: Text(makeupName, style: const TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center,),
          )
        ],
      )
    );
  }

}