import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medminder/app_theme.dart';
import 'package:medminder/auth/auth_service.dart';
import 'package:medminder/auth/cubit/login_cubit.dart';
import 'package:medminder/auth/view/login_view.dart';
import 'package:medminder/contact/cubit/emergency_contact_cubit.dart';
import 'package:medminder/contact/view/emergency_contact_view.dart';
import 'package:medminder/medicine/cubit/medicine_cubit.dart';
import 'package:medminder/medicine/view/medicine_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit()..isUserLoggedIn(),
        child: const LoginInView(),
      ),
    ),
    GoRoute(
      path: '/add-primary-contact',
      builder: (context, state) => BlocProvider(
        create: (context) => EmergencyContactCubit(),
        child: const EmergencyContactView(),
      ),
    ),
    GoRoute(
      path: '/create-medicine',
      builder: (context, state) => BlocProvider(
        create: (context) => MedicineCubit(),
        child: const MedicineFormView(),
      ),
    )
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final getIt = GetIt.instance;

  final firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
  final authService = AuthService(firebaseAuth: firebaseAuth);
  final sp = await SharedPreferences.getInstance();

  getIt.registerSingleton<AuthService>(authService);
  getIt.registerSingleton<SharedPreferences>(sp);
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ScrollConfiguration(
        behavior: CustomScrollBehaviour(),
        child: child ?? Container(),
      ),
      theme: AppColor.lightMode,
      routerConfig: goRouter,
    ),
  );
}

class CustomScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
