import 'package:equatable/equatable.dart';

class SignupData extends Equatable {
  final String ownerName;
  final String outletName;
  final String outletType;
  final List<String> selectedModules;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String pin;
  final String confirmPin;

  const SignupData({
    this.ownerName = '',
    this.outletName = '',
    this.outletType = '',
    this.selectedModules = const [],
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.pin = '',
    this.confirmPin = '',
  });

  SignupData copyWith({
    String? ownerName,
    String? outletName,
    String? outletType,
    List<String>? selectedModules,
    String? email,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    String? pin,
    String? confirmPin,
  }) {
    return SignupData(
      ownerName: ownerName ?? this.ownerName,
      outletName: outletName ?? this.outletName,
      outletType: outletType ?? this.outletType,
      selectedModules: selectedModules ?? this.selectedModules,
      email: email ?? this.email,
      phone: phoneNumber ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName,
      'outletName': outletName,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
  Map<String, dynamic> toPinJson() {
    return {
      'pin': pin,
    };
  }

  @override
  List<Object> get props => [
    ownerName,
    outletName,
    outletType,
    selectedModules,
    email,
    phone,
    password,
    confirmPassword,
    pin,
    confirmPin,
  ];
}
