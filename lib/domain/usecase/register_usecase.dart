import '../../data/network/failure.dart';
import 'package:dartz/dartz.dart';

import '../../data/request/request.dart';
import '../models/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
    return await _repository.register(
      RegisterRequest(
        countryMobileCode: input.countryMobileCode,
        password: input.password,
        email: input.email,
        mobileNumber: input.mobileNumber,
        profilePicture: input.profilePicture,
        userName: input.userName,
      ),
    );
  }
}

class RegisterUseCaseInput {
  String countryMobileCode;
  String password;
  String userName;
  String email;
  String mobileNumber;
  String profilePicture;

  RegisterUseCaseInput({
    required this.countryMobileCode,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.profilePicture,
    required this.userName,
  });
}
