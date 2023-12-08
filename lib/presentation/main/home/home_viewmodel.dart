import 'dart:async';
import 'dart:ffi';

import 'package:rxdart/rxdart.dart';

import '../../../domain/models/model.dart';
import '../../../domain/usecase/home_usecase.dart';
import '../../base/baseviewmodel.dart';
import '../../common/state_renderer/state_render_impl.dart';
import '../../common/state_renderer/state_renderer.dart';

class HomeViewModel extends BaseViewModel
    implements HomeViewModelInputs, HomeViewModelOutputs {
  HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  final StreamController _bannerStreamController =
      BehaviorSubject<List<BannerAd>>();
  final StreamController _storeStreamController =
      BehaviorSubject<List<Store>>();
  final StreamController _serviceStreamController =
      BehaviorSubject<List<Service>>();

  @override
  void start() {
    _getHome();
  }

  _getHome() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _homeUseCase.execute(null)).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    },
        (homeObject) => {
              inputState.add(ContentState()),
              inputBanner.add(homeObject.data.banners),
              inputService.add(homeObject.data.services),
              inputService.add(homeObject.data.stores),
            });
  }

  @override
  void dispose() {
    _bannerStreamController.close();
    _storeStreamController.close();
    _serviceStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputBanner => _bannerStreamController.sink;

  @override
  Sink get inputService => _serviceStreamController.sink;

  @override
  Sink get inputStore => _storeStreamController.sink;

  @override
  Stream<List<BannerAd>> get outputBanner =>
      _bannerStreamController.stream.map((banner) => banner);

  @override
  Stream<List<Service>> get outputService =>
      _storeStreamController.stream.map((service) => service);

  @override
  Stream<List<Store>> get outputStore =>
      _serviceStreamController.stream.map((store) => store);
}

abstract class HomeViewModelInputs {
  Sink get inputStore;
  Sink get inputService;
  Sink get inputBanner;
}

abstract class HomeViewModelOutputs {
  Stream<List<Store>> get outputStore;
  Stream<List<Service>> get outputService;
  Stream<List<BannerAd>> get outputBanner;
}
