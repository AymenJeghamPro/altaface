
import 'package:flutter/material.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';

void popupAlert({required BuildContext context, required Widget widget}) {
  showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 200),
    context: context,
    pageBuilder: (dialogContext, anim1, anim2) {
      return Container();
    },
    transitionBuilder: (dialogContext, anim1, anim2, child) {


      return Padding(
          padding: const EdgeInsets.only(bottom: 200),
          child: WillPopScope(
              onWillPop: () async => false,
              child: Transform.scale(
                scale: anim1.value,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, right: 16, left: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: Material(
                          elevation: 5.0,
                          color: AppColors.primaryContrastColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16, bottom: 16, right: 16, left: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [widget],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )));
    },
  );
}
