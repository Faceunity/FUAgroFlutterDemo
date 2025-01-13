import 'package:flutter/material.dart';

typedef OnChange = void Function(int index, bool enable);

class BarItem {
  final String title;
  final bool enable;

  BarItem(this.title, {this.enable = true});

}

class SegmentBar extends StatefulWidget {

  const SegmentBar({Key? key, required this.onChange, required this.items}) : super(key: key);

  final OnChange onChange;
  final List<BarItem> items;

  @override
  State<StatefulWidget> createState() {
    return SegmentBarState();
  }
}

class SegmentBarState extends State<SegmentBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _itemCell(index);
      },
      itemCount: widget.items.length,
      scrollDirection: Axis.horizontal
    );
  }

  Widget _itemCell(int index) {
    BarItem item = widget.items[index];
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
      ),
      onPressed: () {
        setState(() {
          if (item.enable) {
            selectedIndex = index;
          }
          widget.onChange(index, item.enable);
        });
      },
      child: Center(
        child: Opacity(
          opacity: item.enable ? 1 : 0.5,
          child: Text(
            item.title,
            style: TextStyle(
              color: index == selectedIndex ? const Color.fromARGB(255, 94, 199, 254) : Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      )
    );
  }
}
