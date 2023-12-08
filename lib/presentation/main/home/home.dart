import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../app/di.dart';
import '../../../domain/models/model.dart';
import '../../common/state_renderer/state_render_impl.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import 'home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = instance<HomeViewModel>();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _viewModel.start();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data
                    ?.getScreenWidget(context, _getContentScreenWidget(), () {
                  _viewModel.start();
                }) ??
                Container();
          },
        ),
      ),
    );
  }

  Widget _getContentScreenWidget() {
    return StreamBuilder<HomeViewObject>(
        stream: _viewModel.outputHomeData,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSize.s10,
              ),
              _getBanner(snapshot.data?.banners),
              _getSection(AppStrings.services),
              _getServices(snapshot.data?.services),
              _getSection(AppStrings.stores),
              _getStores(snapshot.data?.stores),
              const SizedBox(
                height: AppSize.s10,
              ),
            ],
          );
        });
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.p24,
        left: AppPadding.p12,
        right: AppPadding.p12,
        bottom: AppPadding.p2,
      ),
      child: Text(title, style: Theme.of(context).textTheme.displayMedium),
    );
  }

  Widget _getBanner(List<BannerAd>? banners) {
    if (banners != null) {
      return CarouselSlider(
        items: banners
            .map(
              (banner) => SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: AppSize.s1_5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    side: BorderSide(
                        color: ColorManager.white, width: AppSize.s1_5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    child: Image.network(
                      banner.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: AppSize.s180,
          autoPlay: true,
          enableInfiniteScroll: true,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getServices(List<Service>? services) {
    if (services != null) {
      return Padding(
        padding: const EdgeInsets.only(
            left: AppPadding.p12, right: AppPadding.p12, top: AppPadding.p12),
        child: SizedBox(
          height: AppSize.s165,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: services
                .map(
                  (service) => Card(
                    elevation: AppSize.s4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s8),
                      side: BorderSide(
                          color: ColorManager.white, width: AppSize.s1_5),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppSize.s8),
                            topRight: Radius.circular(AppSize.s8),
                          ),
                          child: Image.network(
                            service.image,
                            fit: BoxFit.cover,
                            width: AppSize.s130,
                            height: AppSize.s120,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: AppPadding.p8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              service.title,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getStores(List<Store>? stores) {
    if (stores != null) {
      return Padding(
        padding: const EdgeInsets.only(
            left: AppPadding.p12, right: AppPadding.p12, top: AppPadding.p12),
        child: Flex(
          direction: Axis.vertical,
          children: [
            GridView.count(
              crossAxisSpacing: AppSize.s8,
              mainAxisSpacing: AppSize.s8,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(
                stores.length,
                (index) => InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                  },
                  child: Card(
                    elevation: AppSize.s4,
                    child: Image.network(
                      stores[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
