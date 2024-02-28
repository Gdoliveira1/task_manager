import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/domain/constants/app_colors.dart";
import "package:task_manager/src/domain/constants/app_constants.dart";
import "package:task_manager/src/domain/constants/app_text_styles.dart";
import "package:task_manager/src/modules/app_status/bloc/app_status_cubit.dart";
import "package:task_manager/src/modules/app_status/bloc/app_status_state.dart";

class AppStatusLoadingView extends StatefulWidget {
  const AppStatusLoadingView({super.key});

  @override
  State<AppStatusLoadingView> createState() => _AppStatusLoadingViewState();
}

class _AppStatusLoadingViewState extends State<AppStatusLoadingView> {
  late Size deviceScale;

  @override
  Widget build(BuildContext context) {
    deviceScale = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: deviceScale.height,
        width: deviceScale.width,
        decoration: AppColors.backgroundLogoGradient(),
        child: BlocBuilder<AppStatusCubit, AppStatusState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/images/logo.jpg"),
                      width: 240,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      "Versão ${kAppVersion.getVersion()}",
                      style: AppTextStyles.black16w500,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
