import 'package:flutter/material.dart';
import 'package:altaface/_shared/constants/app_colors.dart';
import 'package:altaface/common_widgets/text/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBarWithTitle extends StatefulWidget {
  final String title;
  final Function(String) onChanged;
  final TextEditingController? controller;

  const SearchBarWithTitle(
      {Key? key, required this.title, required this.onChanged, this.controller})
      : super(key: key);

  @override
  _SearchBarWithTitleState createState() =>
      // ignore: no_logic_in_create_state
      _SearchBarWithTitleState(controller);
}

class _SearchBarWithTitleState extends State<SearchBarWithTitle> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  _SearchBarWithTitleState(TextEditingController? controller) {
    if (controller != null) {
      _controller = controller;
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autocorrect: false,
        enableSuggestions: false,
        style: TextStyles.titleTextStyle,
        decoration: InputDecoration(
          hintText: widget.title,
          hintStyle: TextStyles.titleTextStyle,
          suffixIcon: _suffixIcon(),
          border: InputBorder.none,
        ),
        onChanged: (text) {
          widget.onChanged(text);
          setState(() {});
        },
      ),
    );
  }

  Widget _suffixIcon() {
    if (_controller.text.isNotEmpty) {
      return IconButton(
        onPressed: () {
          _controller.clear();
          _focusNode.unfocus();
          widget.onChanged(_controller.text);
          setState(() {});
        },
        icon: SvgPicture.asset(
          'assets/icons/close_icon.svg',
          color: AppColors.defaultColor,
          width: 22,
          height: 22,
        ),
      );
    } else {
      return IconButton(
        onPressed: () {
          _focusNode.requestFocus();
          setState(() {});
        },
        icon: SvgPicture.asset(
          'assets/icons/search_icon.svg',
          color: AppColors.defaultColor,
          width: 22,
          height: 22,
        ),
      );
    }
  }
}
