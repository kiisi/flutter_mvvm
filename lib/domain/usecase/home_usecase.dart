import '../../data/network/failure.dart';
import 'package:dartz/dartz.dart';

import '../models/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class HomeUseCase extends BaseUseCase<void, HomeObject> {
  final Repository _repository;

  HomeUseCase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHome();
  }
}
