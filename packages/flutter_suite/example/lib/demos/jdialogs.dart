import 'package:flutter/material.dart';
import 'package:flutter_suite/flutter_suite.dart';

var content =
    '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s''';

class JDialogsDemo extends StatelessWidget {
  const JDialogsDemo({super.key});

  Widget button(String text, {VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      child: Text(text),
    ).paddingAll(16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Wrap(
            children: [
              InfoJDialog(
                title: 'Info Dialog',
                subtitle: 'caption text',
                content: content,
              ),
              AlertJDialog(
                title: 'Alert Dialog',
                content: content,
              ),
              SelectJDialog(
                maxSelect: 2,
                title: 'Select Dialog',
                subtitle: 'Here are selected dialog subtitle.',
                actionOnMaxExceed: JDialogAction.unSelectAll,
                tileJConfig: ListTileJConfig(
                  indicator: ItemIndicator.checkbox,
                  items: ['Class A', 'Class B', 'Class C']
                      .map((e) => JListTile(
                            key: e,
                            title: Text(e),
                            subtitle: const Text('Here are selected dialog subtitle.'),
                            leading: const Icon(Icons.ac_unit),
                          ))
                      .toList(),
                ),
                onSelected: (result) {},
              ),
              SelectJDialog(
                maxSelect: 2,
                title: 'Select Dialog',
                subtitle: 'Here are selected dialog subtitle.',
                actionOnMaxExceed: JDialogAction.resetOnMaxExceed,
                tileJConfig: GridTileJConfig(
                  indicator: ItemIndicator.checkbox,
                  selectColor: Colors.red,
                  keys: ['Class A'],
                  items: ['Class A', 'Class B', 'Class C']
                      .map((e) => JGridTile(
                            key: e,
                            header: Text(e),
                            alignment: IndicatorAlignment.bottomCenter,
                            child: const Icon(Icons.abc),
                          ))
                      .toList(),
                ), onSelected: (List<String> result) {  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
