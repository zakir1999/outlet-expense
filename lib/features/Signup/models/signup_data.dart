import 'package:equatable/equatable.dart';

class SignupData extends Equatable {
  final String userName;
  final String outletName;
  final String outletType;
  final List<String> selectedModules;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String pin;
  final String confirmPin;

  const SignupData({
    this.userName = '',
    this.outletName = '',
    this.outletType = '',
    this.selectedModules = const [],
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.pin = '',
    this.confirmPin = '',
  });

  SignupData copyWith({
    String? userName,
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
      userName: userName ?? this.userName,
      outletName: outletName ?? this.outletName,
      outletType: outletType ?? this.outletType,
      selectedModules: selectedModules ?? this.selectedModules,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'outletName': outletName,
      'outletType': outletType,
      'selectedModules': selectedModules,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'pin': pin,
    };
  }

  @override
  List<Object> get props => [
    userName,
    outletName,
    outletType,
    selectedModules,
    email,
    phoneNumber,
    password,
    confirmPassword,
    pin,
    confirmPin,
  ];
}
