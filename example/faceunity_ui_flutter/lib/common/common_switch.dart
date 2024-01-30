import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonSwitch extends StatefulWidget {

  const CommonSwitch({super.key, this.onChanged});

  final ValueChanged<bool>? onChanged;
  
  @override
  State<StatefulWidget> createState() {
    return CommonSwitchState();
  }

}

class CommonSwitchState extends State<CommonSwitch> {
  bool isOn = true;
  @override
  Widget build(BuildContext context) {
      return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Platform.isIOS ? CupertinoSwitch(
          value: isOn,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            setState(() {
              isOn = value;
            });
          }
        ) : Switch(
          value: isOn,
          inactiveTrackColor: Colors.transparent,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            setState(() {
              isOn = value;
            });
          }
        )
      ),
    );
  }

}