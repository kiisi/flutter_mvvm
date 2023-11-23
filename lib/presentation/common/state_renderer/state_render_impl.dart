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

// empty state

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

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(
      BuildContext context, Widget contentScreenWidget, Function retryAction) {
    switch (runtimeType) {
      case LoadingState _:
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
      case ErrorState _:
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
      case ContentState _:
        return contentScreenWidget;
      case EmptyState _:
        return StateRenderer(
          stateRendererType: getStateRendererType(),
          message: getMessage(),
          retryAction: retryAction,
        );
      default:
        return contentScreenWidget;
    }
  }

  showPopUp(BuildContext context, StateRendererType stateRendererType,
      String message) {
    WidgetsBinding.instance.addPersistentFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
          stateRendererType: stateRendererType,
          message: message,
          retryAction: () {},
        ),
      ),
    );
  }
}