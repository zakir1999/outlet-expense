part of 'sign_up_bloc.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  final String woner_name;
  final String outlet_name;
  final String outletType;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String pin;
  final String confirmPin;
  final int step;
  final SignUpStatus status;

  const SignUpState({
    this.woner_name = '',
    this.outlet_name = '',
    this.outletType = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.pin = '',
    this.confirmPin = '',
    this.step = 1,
    this.status = SignUpStatus.initial,
  });

  SignUpState copyWith({
    String? woner_name,
    String? outlet_name,
    String? outletType,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? pin,
    String? confirmPin,
    int? step,
    SignUpStatus? status,
  }) {
    return SignUpState(
      woner_name: woner_name ?? this.woner_name,
      outlet_name: outlet_name ?? this.outlet_name,
      outletType: outletType ?? this.outletType,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
      step: step ?? this.step,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    woner_name,
    outlet_name,
    outletType,
    email,
    phone,
    password,
    confirmPassword,
    pin,
    confirmPin,
    step,
    status,
  ];
}
