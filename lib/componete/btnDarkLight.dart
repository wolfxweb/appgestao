



import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class BtnDarkLight extends StatelessWidget {
  const BtnDarkLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    FlutterSwitch(
      width: 75.0,
      activeText:'Dark',
      inactiveText:'Light',
      activeColor: Colors.orange,
      inactiveColor: Colors.orange,
      activeIcon: const Icon(Icons.dark_mode,color: Colors.black54),
      inactiveIcon: const Icon(Icons.light_mode, color: Colors.orange),
      showOnOff: true,
      key: Key('EasyDynamicThemeSwitch'),
      value: Theme.of(context).brightness == Brightness.dark,
      onToggle: (val) {
        EasyDynamicTheme.of(context).changeTheme(dark: val);
      },
    );
  }
}
