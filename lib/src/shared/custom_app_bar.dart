// import "package:flutter/material.dart";
// import "package:task_manager/src/domain/constants/app_colors.dart";

// class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String title;
//   final void Function(bool)? onTapToggle;
//   final void Function()? onTap;
//   final bool isBackButton;
//   final bool isToogleOn;
//   final Color? buttonColor;
//   final AlignmentGeometry alignment;
//   final Color? backgroundColor;

//   const CustomAppBar({
//     super.key,
//     this.title = "",
//     this.onTapToggle,
//     this.onTap,
//     this.isBackButton = false,
//     this.isToogleOn = true,
//     this.buttonColor,
//     this.alignment = Alignment.center,
//     this.backgroundColor,
//   });

//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(70);
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       leading: null,
//       backgroundColor: widget.backgroundColor,
//       elevation: 0,
//       flexibleSpace: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 24.0),
//           child: Row(
//             children: [
//               _buildIcon(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIcon() {
//     return Expanded(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//               padding: const EdgeInsets.only(left: 14.0),
//               child: widget.isBackButton
//                   ? CustomHoverIconButton(
//                       iconColor: widget.buttonColor,
//                       image: ThemeController.isDarkTheme ? "backDark" : "back",
//                       forceSize: 40,
//                       onTap: widget.onTap ??
//                           () {
//                             NavigationController.pop();
//                           },
//                     )
//                   : Image(
//                       image: AssetImage(ThemeController.isDarkTheme
//                           ? "assets/images/logoDark.png"
//                           : "assets/images/logo.png"),
//                     )),
//           widget.isToogleOn
//               ? Padding(
//                   padding: const EdgeInsets.only(right: 20.0),
//                   child: CustomToggleDarkModeComponent(
//                     value: ThemeController.isDarkTheme,
//                     onChanged: widget.onTapToggle ?? (_) {},
//                   ),
//                 )
//               : const SizedBox.shrink()
//         ],
//       ),
//     );
//   }
// }
