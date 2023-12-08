import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../domain/models/model.dart';
import '../../../domain/usecase/home_usecase.dart';
import '../../base/baseviewmodel.dart';
import '../../common/state_renderer/state_render_impl.dart';
import '../../common/state_renderer/state_renderer.dart';

class HomeViewModel extends BaseViewModel
    implements HomeViewModelInputs, HomeViewModelOutputs {
  final HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  final StreamController _dataStreamController =
      BehaviorSubject<HomeViewObject>();

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
              inputHomeData.add(
                HomeViewObject(
                    stores: homeObject.data.stores,
                    services: homeObject.data.services,
                    banners: homeObject.data.banners),
              )
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
  Sink get inputHomeData => _dataStreamController.sink;

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}
