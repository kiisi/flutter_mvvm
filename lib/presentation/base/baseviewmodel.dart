abstract class BaseViewModel extends BaseViewModelInputs
    implements BaseViewModelOutputs {
  // shared variables and functions that will be used through any view model
}

abstract class BaseViewModelInputs {
  void start(); // will be called while initialization of view model.
  void dispose(); // will be called when viewmodel dies.
}

abstract class BaseViewModelOutputs {}
