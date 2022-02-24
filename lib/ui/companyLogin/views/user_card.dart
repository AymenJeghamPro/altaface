import 'package:flutter/material.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';
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
    final PageController controller = PageController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyles.titleTextStyle
                      .copyWith(fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            user.type.toString(),
                            style: TextStyles.titleTextStyle
                                .copyWith(color: AppColors.defaultColor),
                          ),
                          const SizedBox(height: 6),
                          Text(user.userName.toString(),
                              style: TextStyles.subTitleTextStyle
                                  .copyWith(color: Colors.black)),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
