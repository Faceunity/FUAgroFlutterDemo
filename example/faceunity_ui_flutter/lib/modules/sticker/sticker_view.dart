import 'package:faceunity_ui_flutter/modules/sticker/sticker_view_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StickerView extends StatefulWidget {
  const StickerView({super.key});

  @override
  State<StatefulWidget> createState() {
    return StickerViewState();
  }
}

class StickerViewState extends State<StickerView> {
  late StickerViewModel viewModel = StickerViewModel();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(200, 0, 0, 0),
      child: _providerList()
    );
  }

  Widget _providerList() {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<StickerViewModel>(
        builder: (context, value, child) {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            itemBuilder: (context, index) {
              return _itemCell(index);
            },
            itemCount: viewModel.stickers.length,
            scrollDirection: Axis.horizontal
         );
        },
      ),
    );
  }

  Widget _itemCell(int index) {
    String iconString = viewModel.stickers[index].icon;
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
      ),
      onPressed: () {
        setState(() {
          viewModel.setSelectedIndex(index);
        });
      }, 
      child: Container(
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
          image: CommonUtil.assetImageNamed("sticker/$iconString"),
          fit: BoxFit.cover,
        ),
      )
    );
  }
}