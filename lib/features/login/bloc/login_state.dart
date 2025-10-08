part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.message = '',
    this.loginStatus = LoginStatus.initial,
    this.navigateToSignUp = false,
  });

  final String email;
  final String password;
  final String message;
  final LoginStatus loginStatus;
  final bool navigateToSignUp;

  LoginState copyWith({
    String? email,
    String? password,
    String? message,
    LoginStatus? loginStatus,
    bool? navigateToSignUp,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      loginStatus: loginStatus ?? this.loginStatus,
      navigateToSignUp: navigateToSignUp ?? this.navigateToSignUp,
    );
  }

  @override
  List<Object> get props => [
    email,
    password,
    message,
    loginStatus,
    navigateToSignUp,
  ];
}
