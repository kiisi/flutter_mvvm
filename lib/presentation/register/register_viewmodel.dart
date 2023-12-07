import 'dart:async';
import 'dart:io';

import '../../app/functions.dart';
import '../../domain/usecase/register_usecase.dart';
import '../base/baseviewmodel.dart';
import '../common/freezed_data_classes.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';

class RegisterViewModel extends BaseViewModel
    implements RegisterViewsModelInputs, RegisterViewsModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();

  final StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();

  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();

  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();

  final StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();

    super.dispose();
  }

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    print(registerObject);

    (await _registerUseCase.execute(
      RegisterUseCaseInput(
          countryMobileCode: registerObject.countryMobileCode,
          email: registerObject.email,
          mobileNumber: registerObject.mobileNumber,
          password: registerObject.password,
          userName: registerObject.userName,
          profilePicture: registerObject.profilePicture),
    ))
        .fold(
            (failure) => {
                  inputState.add(
                    ErrorState(
                        StateRendererType.POPUP_ERROR_STATE, failure.message),
                  ),
                },
            (data) => {
                  inputState.add(ContentState()),
                  // navigate to main screen
                  isUserLoggedInSuccessfullyStreamController.add(true)
                });
  }

  // input streams
  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => _profilePictureStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputIsAllInputsValid => _isAllInputsValidStreamController.sink;

  // output streams

  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outputErrorUserName => outputIsUserNameValid
      .map((isUserNameValid) => isUserNameValid ? null : "Invalid username");

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : "Invalid email");

  @override
  Stream<bool> get outputIsMobileNumberValid =>
      _mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : "Invalid mobile number");

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid
      .map((isPasswordValid) => isPasswordValid ? null : "Invalid password");

  @override
  Stream<File> get outputProfilePicture =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _validateAllInputs());

  final RegisterUseCase _registerUseCase;

  var registerObject = RegisterObject("", "", "", "", "", "");

  RegisterViewModel(this._registerUseCase);

  _isUserNameValid(userName) {
    return userName.length > 2;
  }

  _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length > 1;
  }

  _isPasswordValid(String password) {
    return password.length > 2;
  }

  bool _validateAllInputs() {
    return (registerObject.countryMobileCode.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty);
  }

  _validate() {
    inputIsAllInputsValid.add(null);
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    _validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      registerObject = registerObject.copyWith(email: email);
    } else {
      registerObject = registerObject.copyWith(email: "");
    }
    _validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    _validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      registerObject = registerObject.copyWith(password: password);
    } else {
      registerObject = registerObject.copyWith(password: "");
    }
    _validate();
  }

  @override
  setProfilePicture(File file) {
    inputProfilePicture.add(file);
    if (file.path.isNotEmpty) {
      registerObject = registerObject.copyWith(profilePicture: file.path);
    } else {
      registerObject = registerObject.copyWith(profilePicture: file.path);
    }
    _validate();
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      registerObject = registerObject.copyWith(userName: "");
    }
    _validate();
  }
}

abstract class RegisterViewsModelInputs {
  register();

  setUserName(String userName);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File file);

  Sink get inputUserName;
  Sink get inputMobileNumber;
  Sink get inputPassword;
  Sink get inputEmail;
  Sink get inputProfilePicture;
  Sink get inputIsAllInputsValid;
}

abstract class RegisterViewsModelOutputs {
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<File> get outputProfilePicture;

  Stream<bool> get outputIsAllInputsValid;
}
