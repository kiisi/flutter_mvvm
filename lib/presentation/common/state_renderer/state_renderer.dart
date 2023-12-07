import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../data/mapper/mapper.dart';
import '../../../data/network/failure.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

enum StateRendererType {
  // POPUP STATES
  POPUP_LOADING_STATE,
  POPUP_ERROR_STATE,
  POPUP_SUCCESS,

  // FULL SCREEN STATES
  FULL_SCREEN_LOADING_STATE,
  FULL_SCREEN_ERROR_STATE,

  CONTENT_SCREEN_STATE,
  EMPTY_SCREEN_STATE
}

class StateRenderer extends StatelessWidget {
  final StateRendererType stateRendererType;
  final String message;
  final String title;
  final Function retryAction;

  const StateRenderer(
      {super.key,
      required this.stateRendererType,
      Failure? failure,
      String? message,
      String? title,
      required this.retryAction})
      : message = message ?? AppStrings.loading,
        title = title ?? EMPTY;

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.POPUP_LOADING_STATE:
        return _getPopUpDialogue(
          context,
          [_getAnimatedImage(JsonAssets.loading)],
        );
      case StateRendererType.POPUP_ERROR_STATE:
        return _getPopUpDialogue(
          context,
          [
            _getAnimatedImage(JsonAssets.error),
            _getMessage(message),
            _getRetryButton(AppStrings.ok, context),
          ],
        );
      case StateRendererType.POPUP_SUCCESS:
        return _getPopUpDialogue(
          context,
          [
            _getAnimatedImage(JsonAssets.success),
            _getMessage(title),
            _getMessage(message),
            _getRetryButton(AppStrings.ok, context),
          ],
        );
      case StateRendererType.FULL_SCREEN_LOADING_STATE:
        return _getItemInColumn([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message),
        ]);
      case StateRendererType.FULL_SCREEN_ERROR_STATE:
        return _getItemInColumn([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retryAgain, context),
        ]);
      case StateRendererType.CONTENT_SCREEN_STATE:
        return Container();
      case StateRendererType.EMPTY_SCREEN_STATE:
        return _getItemInColumn([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message),
        ]);
      default:
        return Container();
    }
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: Text(
          message,
          style: getMediumStyle(
            color: ColorManager.black,
            fontSize: FontSize.s16,
          ),
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: AppSize.s180,
          child: ElevatedButton(
            onPressed: () {
              if (stateRendererType ==
                  StateRendererType.FULL_SCREEN_LOADING_STATE) {
                retryAction.call();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              buttonTitle,
              style: TextStyle(color: ColorManager.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getItemInColumn(List<Widget> children) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _getPopUpDialogue(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.red,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: AppSize.s12,
              offset: Offset(AppSize.s0, AppSize.s12),
            ),
          ],
        ),
        child: _getDialogueContent(context, children),
      ),
    );
  }

  Widget _getDialogueContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
