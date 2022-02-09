// import 'package:avatar_view/avatar_view.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_projects/_shared/constants/app_colors.dart';
// import 'package:flutter_projects/af_core/entity/company/company.dart';
// import 'package:flutter_projects/af_core/entity/user/user.dart';
// import 'package:flutter_projects/common_widgets/text/text_styles.dart';
// import 'dart:async';

// class UserCard extends StatelessWidget {
// final User user;
// final Company company;
// final VoidCallback onPressed;

//   const UserCard(
//       {required this.user, required this.company, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     final String firstLettter = user.firstName.toString()[0];
//     bool _visible = true;

//     // const oneSec = Duration(seconds: 1);
//     // Timer.periodic(oneSec, (Timer t) => {_visible = !_visible});

// return Card(
//     child: ListTile(
//         onTap: onPressed,
//         leading: (user.avatar.toString() ==
//                     "https://assets1.altagem.info/packs/media/images/default_female_avatar-db160bdcc75bebf90cadd738bd029978.png" ||
//                 user.avatar.toString() ==
//                     "https://assets0.altagem.info/packs/media/images/default_avatar-89183a200fec38ff5efaeb043ee79375.png"
//             ? CircleAvatar(
//                 // backgroundImage: imageAssets,
//                 backgroundImage: NetworkImage(user.avatar.toString()),
//                 backgroundColor: Colors.transparent,
//                 radius: 25,
//               )
//             : CircleAvatar(
//                 // backgroundImage: imageAssets,
//                 child: Text(firstLettter),
//                 backgroundColor: Colors.green,
//                 radius: 25,
//               )),
//         title: Text(
//             user.firstName.toString() + ' ' + user.lastName.toString()),
//         subtitle: Text(user.type.toString()),
//         trailing: const IconTheme(
//           data: IconThemeData(color: Colors.green, size: 15),
//           child: Icon(Icons.circle),
//         )
//         // ignore: dead_code
//         ));
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../af_core/entity/company/company.dart';
import '../../../af_core/entity/user/user.dart';

class UserCard extends StatefulWidget {
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
  UserCardState createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  bool _show = true;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      setState(() => _show = !_show);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            onTap: widget.onPressed,
            leading: (widget.user.avatar.toString() ==
                        "https://assets1.altagem.info/packs/media/images/default_female_avatar-db160bdcc75bebf90cadd738bd029978.png" ||
                    widget.user.avatar.toString() ==
                        "https://assets0.altagem.info/packs/media/images/default_avatar-89183a200fec38ff5efaeb043ee79375.png"
                ? CircleAvatar(
                    // backgroundImage: imageAssets,
                    backgroundImage:
                        NetworkImage(widget.user.avatar.toString()),
                    backgroundColor: Colors.transparent,
                    radius: 25,
                  )
                : CircleAvatar(
                    // backgroundImage: imageAssets,
                    child: Text(widget.user.firstName.toString()[0]),
                    backgroundColor: Colors.green,
                    radius: 25,
                  )),
            title: Text(widget.user.firstName.toString() +
                ' ' +
                widget.user.lastName.toString()),
            subtitle: Text(widget.user.type.toString()),
            trailing: widget.user.firstName == 'Malak' ||
                    widget.user.firstName == 'Malek' ||
                    widget.user.firstName == 'Sami' ||
                    widget.user.firstName == 'Achraf'
                ? _show
                    ? const IconTheme(
                        data: IconThemeData(color: Colors.green, size: 15),
                        child: Icon(Icons.circle),
                      )
                    : null
                : const IconTheme(
                    data: IconThemeData(color: Colors.red, size: 15),
                    child: Icon(Icons.circle),
                  )

            // ignore: dead_code
            ));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
