import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_task_manager/widgets/app_bar_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final int currentIndex;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight + 140,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          decoration: const BoxDecoration(color: Color(0xFF4A3780)),
        ),
        Positioned(
          top: height == 240 ? 110 : -30,
          left: -180,
          child: SvgPicture.asset(
            "assets/images/ellipse-left.svg",
            width: 342,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: -20,
          right: -80,
          child: SvgPicture.asset(
            "assets/images/ellipse-right.svg",
            width: 145,
            fit: BoxFit.contain,
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:
              currentIndex == 2 || currentIndex == 3
                  ? Padding(
                    padding: EdgeInsets.only(left: 4, top: 8),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset(
                        "assets/images/cancel.svg",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  )
                  : null,
          title: Builder(
            builder: (context) {
              switch (currentIndex) {
                case 1:
                  return AppBarText(text: "Statistics");
                case 2:
                  return Padding(
                    padding: EdgeInsets.only(left: 4, top: 8),
                    child: AppBarText(text: "Add new Task"),
                  );
                case 3:
                  return Padding(
                    padding: EdgeInsets.only(left: 4, top: 8),
                    child: AppBarText(text: "Edit Task"),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
