// part of 'sign_up_bloc.dart';

// abstract class SignUpEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class UserNameChanged extends SignUpEvent {
//   final String woner_name;
//   UserNameChanged(this.woner_name);

//   @override
//   List<Object?> get props => [woner_name];
// }

// class OutletNameChanged extends SignUpEvent {
//   final String outlet_name;
//   OutletNameChanged(this.outlet_name);

//   @override
//   List<Object?> get props => [outlet_name];
// }

// class OutletTypeChanged extends SignUpEvent {
//   final String outletType;
//   OutletTypeChanged(this.outletType);

//   @override
//   List<Object?> get props => [outletType];
// }

// class EmailChanged extends SignUpEvent {
//   final String email;
//   EmailChanged(this.email);

//   @override
//   List<Object?> get props => [email];
// }

// class PhoneChanged extends SignUpEvent {
//   final String phone;
//   PhoneChanged(this.phone);

//   @override
//   List<Object?> get props => [phone];
// }

// class PasswordChanged extends SignUpEvent {
//   final String password;
//   PasswordChanged(this.password);

//   @override
//   List<Object?> get props => [password];
// }

// class ConfirmPasswordChanged extends SignUpEvent {
//   final String confirmPassword;
//   ConfirmPasswordChanged(this.confirmPassword);

//   @override
//   List<Object?> get props => [confirmPassword];
// }

// class PinChanged extends SignUpEvent {
//   final String pin;
//   PinChanged(this.pin);

//   @override
//   List<Object?> get props => [pin];
// }

// class ConfirmPinChanged extends SignUpEvent {
//   final String confirmPin;
//   ConfirmPinChanged(this.confirmPin);

//   @override
//   List<Object?> get props => [confirmPin];
// }

// class SubmitPageData extends SignUpEvent {
//   final Map<String, dynamic> data;
//   SubmitPageData(this.data);
// }

// class NextStep extends SignUpEvent {}

// class PreviousStep extends SignUpEvent {}

// class SubmitSignUp extends SignUpEvent {}
import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserName extends SignupEvent {
  final String userName;

  const UpdateUserName(this.userName);

  @override
  List<Object> get props => [userName];
}

class UpdateOutletName extends SignupEvent {
  final String outletName;

  const UpdateOutletName(this.outletName);

  @override
  List<Object> get props => [outletName];
}

class UpdateOutletType extends SignupEvent {
  final String outletType;

  const UpdateOutletType(this.outletType);

  @override
  List<Object> get props => [outletType];
}

class UpdateSelectedModules extends SignupEvent {
  final List<String> selectedModules;

  const UpdateSelectedModules(this.selectedModules);

  @override
  List<Object> get props => [selectedModules];
}

class UpdateEmail extends SignupEvent {
  final String email;

  const UpdateEmail(this.email);

  @override
  List<Object> get props => [email];
}

class UpdatePhoneNumber extends SignupEvent {
  final String phoneNumber;

  const UpdatePhoneNumber(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class UpdatePassword extends SignupEvent {
  final String password;

  const UpdatePassword(this.password);

  @override
  List<Object> get props => [password];
}

class UpdateConfirmPassword extends SignupEvent {
  final String confirmPassword;

  const UpdateConfirmPassword(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class UpdatePin extends SignupEvent {
  final String pin;

  const UpdatePin(this.pin);

  @override
  List<Object> get props => [pin];
}

class UpdateConfirmPin extends SignupEvent {
  final String confirmPin;

  const UpdateConfirmPin(this.confirmPin);

  @override
  List<Object> get props => [confirmPin];
}

class SubmitSignup extends SignupEvent {
  const SubmitSignup();
}
