import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/mapper/mapper.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  _bind() {
    _viewModel.start();

    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });

    _passwordTextEditingController.addListener(() {
      _viewModel.setPassword(_passwordTextEditingController.text);
    });

    _emailTextEditingController.addListener(() {
      _viewModel.setEmail(_emailTextEditingController.text);
    });

    _mobileNumberTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);
    });

    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isSuccessLoggedIn) {
      // Navigate to main screen
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _appPreferences.setIsUserLoggedIn();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.primary),
        backgroundColor: ColorManager.white,
        shadowColor: Colors.white,
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return Center(
            child: snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.register();
                }) ??
                _getContentWidget(),
          );
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.only(top: AppPadding.p30, bottom: AppPadding.p30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Image(
              image: AssetImage(ImageAssets.splashLogo),
            ),
            const SizedBox(height: AppSize.s24),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorUserName,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _userNameTextEditingController,
                    decoration: InputDecoration(
                      labelText: AppStrings.username.tr(),
                      errorText: snapshot.data,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CountryCodePicker(
                        onChanged: (country) {
                          _viewModel.setCountryCode(country.dialCode ?? EMPTY);
                        },
                        initialSelection: '+966',
                        showCountryOnly: true,
                        hideMainText: true,
                        showOnlyCountryWhenClosed: true,
                        favorite: const ['+966', '+02', '+39'],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: StreamBuilder<String?>(
                        stream: _viewModel.outputErrorMobileNumber,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _mobileNumberTextEditingController,
                            decoration: InputDecoration(
                              labelText: AppStrings.mobileNumber.tr(),
                              errorText: snapshot.data,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorPassword,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordTextEditingController,
                    decoration: InputDecoration(
                      labelText: AppStrings.password.tr(),
                      errorText: snapshot.data,
                    ),
                    obscureText: true,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorEmail,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTextEditingController,
                    decoration: InputDecoration(
                      labelText: AppStrings.emailHint.tr(),
                      errorText: snapshot.data,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p28,
                right: AppPadding.p28,
              ),
              child: Container(
                height: AppSize.s40,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.lightGrey),
                ),
                child: GestureDetector(
                  child: _getMediaWidget(),
                  onTap: () {
                    _showPicker(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppPadding.p28, right: AppPadding.p28),
              child: StreamBuilder<bool>(
                stream: _viewModel.outputIsAllInputsValid,
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s50,
                    child: ElevatedButton(
                      onPressed: (snapshot.data ?? false)
                          ? () {
                              _viewModel.register();
                            }
                          : null,
                      child: const Text(
                        AppStrings.register,
                      ).tr(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppStrings.haveAccount,
                  style: Theme.of(context).textTheme.titleSmall,
                ).tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppPadding.p8,
        left: AppPadding.p8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: const Text(AppStrings.profilePicture).tr(),
          ),
          Flexible(
            child: StreamBuilder<File?>(
              stream: _viewModel.outputProfilePicture,
              builder: (context, snapshot) {
                return _imagePickedByUser(snapshot.data);
              },
            ),
          ),
          Flexible(
            child: SvgPicture.asset(ImageAssets.photoCameraIc),
          ),
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery).tr(),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text(AppStrings.photoCamera).tr(),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }
}
