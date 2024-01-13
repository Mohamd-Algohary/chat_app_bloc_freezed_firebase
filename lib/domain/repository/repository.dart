import 'dart:async';

import 'package:dartz/dartz.dart';
import '/domain/model/model.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);
  Future<Either<Failure, List<Message>>> getMessage();
  Future<Either<Failure, String>> sendMessage(
      {required String message, required String email});
}
