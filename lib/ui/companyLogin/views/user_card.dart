import 'package:flutter/material.dart';
import 'package:altaface/af_core/entity/company/company.dart';
import 'package:altaface/af_core/entity/user/user.dart';
import 'package:altaface/common_widgets/text/text_styles.dart';

class UserCard extends StatefulWidget {
  final User user;
  final Company company;
  final VoidCallback onPressed;
  final bool selected;

  const UserCard(
      {Key? key,
      required this.user,
      required this.company,
      required this.onPressed,
      required this.selected})
      : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
            elevation: 4,
            color: widget.selected ? Colors.green[200] : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  widget.onPressed();
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(20),
                          child: Image.asset("assets/icons/avatar.png"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${widget.user.firstName} ${widget.user.lastName}',
                        style: TextStyles.titleTextStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ))));
  }
}
