import '../../domain/model.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repository.dart';
import '../data_source/remote_data_source.dart';
import '../mapper/mapper.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../network/network_info.dart';
import '../request/request.dart';

class RepositoryImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    // TODO: implement login
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          // business logic error
          return Left(Failure(response.status ?? ApiInternalStatus.ERROR,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (err) {
        return Left(ErrorHandler.handle(err).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int ERROR = 1;
}
