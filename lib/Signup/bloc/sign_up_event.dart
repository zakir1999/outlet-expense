part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserNameChanged extends SignUpEvent {
  final String woner_name;
  UserNameChanged(this.woner_name);

  @override
  List<Object?> get props => [woner_name];
}

class OutletNameChanged extends SignUpEvent {
  final String outlet_name;
  OutletNameChanged(this.outlet_name);

  @override
  List<Object?> get props => [outlet_name];
}

class OutletTypeChanged extends SignUpEvent {
  final String outletType;
  OutletTypeChanged(this.outletType);

  @override
  List<Object?> get props => [outletType];
}

class EmailChanged extends SignUpEvent {
  final String email;
  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PhoneChanged extends SignUpEvent {
  final String phone;
  PhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class PasswordChanged extends SignUpEvent {
  final String password;
  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class PinChanged extends SignUpEvent {
  final String pin;
  PinChanged(this.pin);

  @override
  List<Object?> get props => [pin];
}

class ConfirmPinChanged extends SignUpEvent {
  final String confirmPin;
  ConfirmPinChanged(this.confirmPin);

  @override
  List<Object?> get props => [confirmPin];
}

class NextStep extends SignUpEvent {}

class PreviousStep extends SignUpEvent {}

class SubmitSignUp extends SignUpEvent {}
