import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../core/api/api_client.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiClient apiClient;

  LoginBloc({required this.apiClient}) : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginApi>(_loginApi);
  }


  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _loginApi(LoginApi event, Emitter<LoginState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    final data = {'email': state.email, 'password': state.password};

    try {
      final response = await apiClient.post('user-login', data);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['authorisation']?['token'] as String?;
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
        }
        emit(
          state.copyWith(
            loginStatus: LoginStatus.success,
            message: jsonResponse['message'] ?? 'Login Successfully',
          ),
        );
      } else {
        emit(
          state.copyWith(
            loginStatus: LoginStatus.error,
            message: 'Something went wrong, try again',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(loginStatus: LoginStatus.error, message: e.toString()),
      );
    }
  }
}
