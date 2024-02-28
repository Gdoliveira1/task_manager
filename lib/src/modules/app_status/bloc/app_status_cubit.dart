import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/modules/app_status/bloc/app_status_state.dart";

class AppStatusCubit extends Cubit<AppStatusState> {
  AppStatusCubit() : super(const AppStatusState());
}
