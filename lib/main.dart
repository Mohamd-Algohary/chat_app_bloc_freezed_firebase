import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import '/data/network/network_info.dart';
import '/app/app.dart';
import '/app/di.dart';
import '/presentation/login_page/cubit/login_cubit.dart';
import '/presentation/register_page/cubit/register_cubit.dart';
import '/firebase_options.dart';
import 'presentation/chat_page/cubit/chat_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.wait({
    // Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // ),
    initAppModule()
  });
  instance<NetworkInfo>().internetConnectivity();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => instance()),
        BlocProvider<RegisterCubit>(create: (context) => instance()),
        BlocProvider<ChatCubit>(create: (context) => instance()),
      ],
      child: MyApp(),
    ),
  );
}
