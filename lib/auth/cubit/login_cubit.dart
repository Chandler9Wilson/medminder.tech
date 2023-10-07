import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medminder/auth/auth_service.dart';
import 'package:medminder/constants.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : _authService = GetIt.I<AuthService>(),
        super(LoginInitial());

  final AuthService _authService;

  Future<void> isUserLoggedIn() async {
    final isUserLoggedIn = await _authService.isUserLoggedIn();
    if (isUserLoggedIn) {
      emit(LoginSuccess());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(LoginLoading(message: 'Logging you in'));
      final creds = await GoogleSignIn().signIn();

      if (creds == null) {
        emit(LoginInitial());
        return;
      }
      final googleAuthentication = await creds.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);

      await _setPref<String>(Constants.uid, userCredential.user!.uid);
      emit(
        LoginLoading(message: 'Loggin In'),
      );
    } on PlatformException catch (pe) {
      emit(LoginError(pe.message ?? 'Something went wrong '));
      return;
    } on FirebaseAuthException catch (fae) {
      emit(LoginError(fae.message ?? 'Something went wrong '));
      return;
    }
    emit(LoginSuccess());
  }

  Future<void> _setPref<T>(String key, T value) async {
    final sp = GetIt.I<SharedPreferences>();
    if (T == String) {
      await sp.setString(key, value as String);
    } else if (T == int) {
      await sp.setInt(key, value as int);
    } else if (T == double) {
      await sp.setDouble(key, value as double);
    } else if (T == bool) {
      await sp.setBool(key, value as bool);
    }
  }

  void tryLogin() {
    emit(LoginInitial());
  }
}
