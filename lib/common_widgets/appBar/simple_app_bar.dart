import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:altaface/common_widgets/buttons/circular_icon_button.dart';

import 'app_bar_divider.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<CircularIconButton> leadingButtons;
  final List<CircularIconButton> trailingButtons;
  final bool showDivider;

  @override
  final Size preferredSize;

  const SimpleAppBar({
    Key? key,
    required this.title,
    this.leadingButtons = const [],
    this.trailingButtons = const [],
    this.showDivider = false,
  })  : preferredSize = const Size.fromHeight(56),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: Colors.green,
      elevation: 5.0,
      bottom: showDivider ? const AppBarDivider() : null,
      // Don't show the default leading button
      automaticallyImplyLeading: false,
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // if (leadingButtons != null)
              Row(children: [
                ...[const SizedBox(width: 8)],
                ..._resizeButtons(leadingButtons),
              ]),
              // if (trailingButtons != null)
              Row(children: _resizeButtons(trailingButtons)),
            ],
          ),
          Center(
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  List<Widget> _resizeButtons(List<Widget> buttons) {
    List<Widget> resizedButtons = [];
    for (Widget button in buttons) {
      resizedButtons.add(_constraintWidgetToSize(button));
      resizedButtons.add(const SizedBox(width: 8));
    }
    return resizedButtons;
  }

  Widget _constraintWidgetToSize(Widget widget) {
    return Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: widget,
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:altaface/common_widgets/buttons/circular_icon_button.dart';
// import 'package:altaface/common_widgets/text/text_styles.dart';

// import 'app_bar_divider.dart';


// class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final List<CircularIconButton> leadingButtons;
//   final List<CircularIconButton> trailingButtons;
//   final bool showDivider;

//   @override
//   final Size preferredSize;

//   SimpleAppBar({
//     required this.title,
//     this.leadingButtons = const [],
//     this.trailingButtons = const [],
//     this.showDivider = false,
//   }) : preferredSize = const Size.fromHeight(56);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       centerTitle: true,
//       titleSpacing: 0,
//       brightness: Brightness.light,
//       backgroundColor: Colors.white,
//       elevation: 0.0,
//       bottom: showDivider ? const AppBarDivider() : null,
//       // Don't show the default leading button
//       automaticallyImplyLeading: false,
//       title: Stack(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (leadingButtons != null)
//                 Row(children: [
//                   ...[const SizedBox(width: 8)],
//                   ..._resizeButtons(leadingButtons),
//                 ]),
//               if (trailingButtons != null) Row(children: _resizeButtons(trailingButtons)),
//             ],
//           ),
//           Positioned.fill(
//             child: Center(
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyles.titleTextStyle.copyWith(fontSize: 18.0),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   List<Widget> _resizeButtons(List<Widget> buttons) {
//     List<Widget> resizedButtons = [];
//     for (Widget button in buttons) {
//       resizedButtons.add(_constraintWidgetToSize(button));
//       resizedButtons.add(SizedBox(width: 8));
//     }
//     return resizedButtons;
//   }

//   Widget _constraintWidgetToSize(Widget widget) {
//     return Container(
//       child: Center(
//         child: SizedBox(
//           width: 32,
//           height: 32,
//           child: widget,
//         ),
//       ),
//     );
//   }
// }
