import 'package:flutter/material.dart';

typedef OnChange = void Function(int index);

class SegmentBar extends StatefulWidget {

  const SegmentBar({Key? key, required this.onChange, required this.items}) : super(key: key);

  final OnChange onChange;
  final List<String> items;

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
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent)
      ),
      onPressed: () {
        setState(() {
          selectedIndex = index;
          widget.onChange(index);
        });
      }, 
      child: Center(
        child: Text(
          widget.items[index],
          style: TextStyle(
            color: index == selectedIndex ? const Color.fromARGB(255, 94, 199, 254) : Colors.white,
            fontSize: 13,
          ),
        ),
      )
    );
  }
}