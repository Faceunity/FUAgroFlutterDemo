import 'package:faceunity_ui_flutter/common/slider_view.dart';
import 'package:faceunity_ui_flutter/modules/filter/filter_view_model.dart';
import 'package:faceunity_ui_flutter/util/common_util.dart';
import 'package:faceunity_ui_flutter/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<StatefulWidget> createState() {
    return FilterViewState();
  }
}

class FilterViewState extends State<FilterView> {

  FilterViewModel viewModel = FilterViewModel();
  
  @override
  Widget build(Object context) { 
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Consumer<FilterViewModel>(builder: (context, value, child) {
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
                    value: viewModel.filters.isNotEmpty ? viewModel.filters[viewModel.selectedIndex].filterLevel : 0,
                    onChanged: (value) {
                      viewModel.setFilterLevel(value);
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
        itemCount: viewModel.filters.length,
        scrollDirection: Axis.horizontal
      )
    );
  }

  Widget _itemCell(int index) {
    String filterName = viewModel.filters[index].filterName;
    String filterKey = viewModel.filters[index].filterKey;
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
              image: CommonUtil.assetImageNamed("filter/$filterKey"),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 16,
            width: 54,
            child: Text(filterName, style: const TextStyle(fontSize: 10, color: Colors.white), textAlign: TextAlign.center,),
          )
        ],
      )
    );
  }

}