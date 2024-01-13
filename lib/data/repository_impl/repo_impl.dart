import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../presentation/resources/strings_manager.dart';
import '/data/network/error_handler.dart';
import '../network/network_info.dart';
import '/domain/model/model.dart';
import '/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final NetworkInfo _networkInfo;
  CollectionReference messages;
  List<Message> messagesList = [];
  RepositoryImpl(this._networkInfo, this.messages);
  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (_networkInfo.isConnected) {
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: loginRequest.email, password: loginRequest.password);
        return Right(Authentication(user));
      } catch (err) {
        return Left(ErrorHandler.handle(err).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (_networkInfo.isConnected) {
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: registerRequest.email,
                password: registerRequest.password);
        return Right(Authentication(user));
      } catch (err) {
        return Left(ErrorHandler.handle(err).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessage() async {
    if (_networkInfo.isConnected) {
      try {
        await messages
            .orderBy(StringsManager.createdAt, descending: true)
            .get()
            .then((value) {
          messagesList.clear();
          for (var doc in value.docs) {
            messagesList.add(Message.fromJson(doc));
          }
        });

        return Right(messagesList);
      } catch (err) {
        return Left(ErrorHandler.handle(err).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendMessage(
      {required String message, required String email}) async {
    if (_networkInfo.isConnected) {
      try {
        await messages.add({
          StringsManager.message: message,
          StringsManager.createdAt: DateTime.now().toIso8601String(),
          StringsManager.id: email
        });
        return Right(messages.id);
      } catch (err) {
        return Left(ErrorHandler.handle(err).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
