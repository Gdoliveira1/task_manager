import "dart:async";
import "dart:math";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_manager/src/app_wrap_state.dart";
import "package:task_manager/src/domain/models/response_status_model.dart";

class AppWrapCubit extends Cubit<AppWrapState> {
  AppWrapCubit._internal() : super(const AppWrapState());

  static final AppWrapCubit _instance = AppWrapCubit._internal();

  static AppWrapCubit get instance => _instance;

  static bool _hasInit = false;

  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  final Random _random = Random();

  void alert(ResponseStatusModel response, {int duration = 8}) {
    Future.delayed(const Duration(milliseconds: 80), () {
      emit(state.copyWith(
        alertResponse: response,
        duration: duration,
      ));
    });
    _reset(resetAlert: true);
  }

  void snackBar(
    ResponseStatusModel response, {
    int duration = 8,
    bool canClose = true,
  }) {
    Future.delayed(const Duration(milliseconds: 100), () {
      emit(state.copyWith(
        snackBarResponse: response,
        duration: duration,
        canClose: canClose,
      ));
    });

    _reset(resetSnackBar: true);
  }

  void _reset({bool resetSnackBar = false, bool resetAlert = false}) {
    Future.delayed(Duration(milliseconds: 200 + _random.nextInt(500)), () {
      if (resetSnackBar) {
        emit(state.copyWith(
          snackBarResponse: null,
          alertResponse: state.alertResponse,
        ));
      }
      if (resetAlert) {
        emit(state.copyWith(
          alertResponse: null,
          snackBarResponse: state.snackBarResponse,
        ));
      }
    });
  }
}
