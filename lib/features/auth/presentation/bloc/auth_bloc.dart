import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_user.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required LoginUser loginUser})
      : _loginUser = loginUser,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  final LoginUser _loginUser;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _loginUser(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthFailure(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
