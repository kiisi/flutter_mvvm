import "dart:async";

import "package:rxdart/rxdart.dart";

import "../common/state_renderer/state_render_impl.dart";

abstract class BaseViewModel extends BaseViewModelInputs
    implements BaseViewModelOutputs {
  // shared variables and functions that will be used through any view model

  final StreamController _inputStreamController = BehaviorSubject<FlowState>();

  @override
  void dispose() {
    _inputStreamController.close();
  }

  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStreamController.stream.map((flowState) => flowState);
}

abstract class BaseViewModelInputs {
  void start(); // will be called while initialization of view model.
  void dispose(); // will be called when viewmodel dies.

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
