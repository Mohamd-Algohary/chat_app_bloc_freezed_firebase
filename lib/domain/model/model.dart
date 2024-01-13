import 'package:firebase_auth/firebase_auth.dart';

import '/presentation/resources/strings_manager.dart';

class Authentication {
  UserCredential userCredential;
  Authentication(this.userCredential);
}

class LoginRequest {
  String email;
  String password;
  LoginRequest(
    this.email,
    this.password,
  );
}

class RegisterRequest {
  String email;
  String password;
  RegisterRequest(
    this.email,
    this.password,
  );
}

class Failure {
  int statusCode;
  String message;
  Failure(
    this.statusCode,
    this.message,
  );
}

class Message {
  final String message;
  final String id;
  Message(this.message, this.id);

  factory Message.fromJson(jsonData) {
    return Message(
        jsonData[StringsManager.message], jsonData[StringsManager.id]);
  }
}
