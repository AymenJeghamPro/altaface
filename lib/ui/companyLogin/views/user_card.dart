import 'package:flutter/material.dart';
import 'package:flutter_projects/af_core/entity/company/company.dart';
import 'package:flutter_projects/af_core/entity/user/user.dart';
import 'package:flutter_projects/common_widgets/text/text_styles.dart';

class UserCard extends StatelessWidget {
  final User user;
  final Company company;
  final VoidCallback onPressed;

  const UserCard(
      {Key? key,
      required this.user,
      required this.company,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(20), // Image radius
                      // child: Image.network(user.avatar!, fit: BoxFit.cover),
                      child: Image.asset("assets/icons/avatar.png"),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyles.titleTextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
