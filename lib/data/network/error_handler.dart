// ignore_for_file: constant_identifier_names, constant_pattern_never_matches_value_type

import 'package:firebase_auth/firebase_auth.dart';
import '/presentation/resources/strings_manager.dart';

import '../../domain/model/model.dart';

class ErrorHandler implements Exception {
  late final Failure failure;

  ErrorHandler.handle(dynamic err) {
    if (err is FirebaseAuthException) {
      // dio Exception so it's an error from API response or from dio it self
      failure = _handelError(err);
    } else {
      // unknown error
      failure = DataSource.UNKNOWN.getFailure();
    }
  }

  //!get Firebase Auth error type
  Failure _handelError(FirebaseAuthException firbaseException) {
    switch (firbaseException.code) {
      case 'weak-password':
        return Failure(01, 'The password provided is too weak.');
      case 'email-already-in-use':
        return Failure(02, 'The account already exists for that email.');
      case 'user-not-found':
        return Failure(03, 'No user found for that email.');
      case 'wrong-password':
        return Failure(04, 'Wrong password provided for that user.');
      default:
        return DataSource.UNKNOWN.getFailure();
    }
  }
}

extension DataSourceExtention on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.UNKNOWN:
        return Failure(ResponseCode.UNKNOWN, ResponseMessage.UNKNOWN);
      default:
        return Failure(0, "");
    }
  }
}

enum DataSource { NO_INTERNET_CONNECTION, UNKNOWN }

class ResponseCode {
  static const int NO_INTERNET_CONNECTION = -6; //
  static const int UNKNOWN = -7; //
}

class ResponseMessage {
  static const String NO_INTERNET_CONNECTION =
      StringsManager.noInternetConnection; //
  static const String UNKNOWN = StringsManager.defaultError; //
}
