// import 'dart:convert';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;

// part 'sign_up_event.dart';
// part 'sign_up_state.dart';

// class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
//   SignUpBloc() : super(const SignUpState()) {
//     on<UserNameChanged>(
//       (event, emit) => emit(state.copyWith(woner_name: event.woner_name)),
//     );
//     on<OutletNameChanged>(
//       (event, emit) => emit(state.copyWith(outlet_name: event.outlet_name)),
//     );
//     on<OutletTypeChanged>(
//       (event, emit) => emit(state.copyWith(outletType: event.outletType)),
//     );
//     on<EmailChanged>((event, emit) => emit(state.copyWith(email: event.email)));
//     on<PhoneChanged>((event, emit) => emit(state.copyWith(phone: event.phone)));
//     on<PasswordChanged>(
//       (event, emit) => emit(state.copyWith(password: event.password)),
//     );
//     on<ConfirmPasswordChanged>(
//       (event, emit) =>
//           emit(state.copyWith(confirmPassword: event.confirmPassword)),
//     );
//     on<PinChanged>((event, emit) => emit(state.copyWith(pin: event.pin)));
//     on<ConfirmPinChanged>(
//       (event, emit) => emit(state.copyWith(confirmPin: event.confirmPin)),
//     );
//     on<NextStep>((event, emit) {
//       if (state.step < 5) {
//         emit(state.copyWith(step: state.step + 1));
//       }
//     });
//     on<PreviousStep>((event, emit) {
//       if (state.step > 0) {
//         emit(state.copyWith(step: state.step - 1));
//       }
//     });
//     on<SubmitSignUp>(_onSubmitSignUp);
//   }

//   Future<void> _onSubmitSignUp(
//     SubmitSignUp event,
//     Emitter<SignUpState> emit,
//   ) async {
//     emit(state.copyWith(status: SignUpStatus.loading));

//     try {
//       final regResponse = await http.post(
//         Uri.parse("https://www.outletexpense.xyz/api/user-registration"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "user_name": state.woner_name,
//           "outlet_name": state.outlet_name,
//           "outlet_type": state.outletType,
//           "email": state.email,
//           "phone": state.phone,
//           "password": state.password,
//           "password_confirmation": state.confirmPassword,
//         }),
//       );

//       if (regResponse.statusCode != 200) {
//         emit(state.copyWith(status: SignUpStatus.failure));
//         return;
//       }

//       final regData = jsonDecode(regResponse.body);
//       final userId = regData["user"]["id"];

//       final pinResponse = await http.post(
//         Uri.parse("https://www.outletexpense.xyz/api/set-pin"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "user_id": userId,
//           "pin": state.pin,
//           "pin_confirmation": state.confirmPin,
//         }),
//       );

//       if (pinResponse.statusCode != 200) {
//         emit(state.copyWith(status: SignUpStatus.failure));
//         return;
//       }

//       emit(state.copyWith(status: SignUpStatus.success));
//     } catch (e) {
//       emit(state.copyWith(status: SignUpStatus.failure));
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api/api_service.dart';
import '../models/signup_data.dart';
import 'signup_event.dart';
import 'signup_state.dart';


class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final ApiService apiService;

  SignupBloc(this.apiService) : super(SignupInitial(const SignupData())) {
    on<UpdateUserName>(_onUpdateUserName);
    on<UpdateOutletName>(_onUpdateOutletName);
    on<UpdateOutletType>(_onUpdateOutletType);
    on<UpdateSelectedModules>(_onUpdateSelectedModules);
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdatePhoneNumber>(_onUpdatePhoneNumber);
    on<UpdatePassword>(_onUpdatePassword);
    on<UpdateConfirmPassword>(_onUpdateConfirmPassword);
    on<UpdatePin>(_onUpdatePin);
    on<UpdateConfirmPin>(_onUpdateConfirmPin);
    on<SubmitSignup>(_onSubmitSignup);
  }

  SignupData get currentData {
    if (state is SignupInitial) {
      return (state as SignupInitial).data;
    } else if (state is SignupUpdated) {
      return (state as SignupUpdated).data;
    } else if (state is SignupSubmitting) {
      return (state as SignupSubmitting).data;
    } else if (state is SignupSuccess) {
      return (state as SignupSuccess).data;
    } else if (state is SignupError) {
      return (state as SignupError).data;
    }
    return const SignupData();
  }

  void _onUpdateUserName(UpdateUserName event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(userName: event.userName);
    emit(SignupUpdated(updatedData));
  }

  void _onUpdateOutletName(UpdateOutletName event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(outletName: event.outletName);
    emit(SignupUpdated(updatedData));
  }

  void _onUpdateOutletType(UpdateOutletType event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(outletType: event.outletType);
    emit(SignupUpdated(updatedData));
  }

  void _onUpdateSelectedModules(
    UpdateSelectedModules event,
    Emitter<SignupState> emit,
  ) {
    final updatedData = currentData.copyWith(
      selectedModules: event.selectedModules,
    );
    emit(SignupUpdated(updatedData));
  }

  void _onUpdateEmail(UpdateEmail event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(email: event.email);
    emit(SignupUpdated(updatedData));
  }

  void _onUpdatePhoneNumber(
    UpdatePhoneNumber event,
    Emitter<SignupState> emit,
  ) {
    final updatedData = currentData.copyWith(phoneNumber: event.phoneNumber);
    emit(SignupUpdated(updatedData));
  }

  void _onUpdatePassword(UpdatePassword event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(password: event.password);
    emit(SignupUpdated(updatedData));
  }

  void _onUpdateConfirmPassword(
    UpdateConfirmPassword event,
    Emitter<SignupState> emit,
  ) {
    final updatedData = currentData.copyWith(
      confirmPassword: event.confirmPassword,
    );
    emit(SignupUpdated(updatedData));
  }

  void _onUpdatePin(UpdatePin event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(pin: event.pin);
    emit(SignupUpdated(updatedData));
  }

  void _onUpdateConfirmPin(UpdateConfirmPin event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(confirmPin: event.confirmPin);
    emit(SignupUpdated(updatedData));
  }

  void _onSubmitSignup(SubmitSignup event, Emitter<SignupState> emit) async {
    emit(SignupSubmitting(currentData));

    try {
      await apiService.submitSignupData(currentData);
      emit(SignupSuccess(currentData));
    } catch (e) {
      emit(SignupError(currentData, e.toString()));
    }
  }
}
