import 'package:flutter/material.dart';

import '../../../data/mapper/mapper.dart';
import '../../resources/strings_manager.dart';
import 'state_renderer.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

// loading state

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
      : message = AppStrings.loading;

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// error state

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// content state

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => EMPTY;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.CONTENT_SCREEN_STATE;
}

// content state

class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => EMPTY;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.EMPTY_SCREEN_STATE;
}

// success state
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.POPUP_SUCCESS;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(
      BuildContext context, Widget contentScreenWidget, Function retryAction) {
    switch (this.runtimeType) {
      case LoadingState:
        if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
          // show popup dialog
          showPopUp(context, getStateRendererType(), getMessage());
          // return content screen
          return contentScreenWidget;
        } else {
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryAction: retryAction,
          );
        }
      case ErrorState:
        dismissDialog(context);
        if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
          // show popup dialog
          showPopUp(context, getStateRendererType(), getMessage());
          // return content screen
          return contentScreenWidget;
        } else {
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryAction: retryAction,
          );
        }
      case ContentState:
        dismissDialog(context);
        return contentScreenWidget;
      case EmptyState:
        return StateRenderer(
          stateRendererType: getStateRendererType(),
          message: getMessage(),
          retryAction: retryAction,
        );
      case SuccessState:
        dismissDialog(context);

        showPopUp(context, StateRendererType.POPUP_SUCCESS, getMessage(),
            title: AppStrings.success);

        return contentScreenWidget;

      default:
        return contentScreenWidget;
    }
  }

  dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  showPopUp(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = EMPTY}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
          stateRendererType: stateRendererType,
          message: message,
          title: title,
          retryAction: () {},
        ),
      ),
    );
  }
}
