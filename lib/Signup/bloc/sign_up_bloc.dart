import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:outlet_expense/Signup/bloc/sign_up_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<UserNameChanged>(
      (event, emit) => emit(state.copyWith(woner_name: event.woner_name)),
    );
    on<OutletNameChanged>(
      (event, emit) => emit(state.copyWith(outlet_name: event.outlet_name)),
    );
    on<OutletTypeChanged>(
      (event, emit) => emit(state.copyWith(outletType: event.outletType)),
    );
    on<EmailChanged>((event, emit) => emit(state.copyWith(email: event.email)));
    on<PhoneChanged>((event, emit) => emit(state.copyWith(phone: event.phone)));
    on<PasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<ConfirmPasswordChanged>(
      (event, emit) =>
          emit(state.copyWith(confirmPassword: event.confirmPassword)),
    );
    on<PinChanged>((event, emit) => emit(state.copyWith(pin: event.pin)));
    on<ConfirmPinChanged>(
      (event, emit) => emit(state.copyWith(confirmPin: event.confirmPin)),
    );
    on<NextStep>((event, emit) => emit(state.copyWith(step: state.step + 1)));
    on<PreviousStep>(
      (event, emit) => emit(state.copyWith(step: state.step - 1)),
    );
    on<SubmitSignUp>(_onSubmitSignUp);
  }

  Future<void> _onSubmitSignUp(
    SubmitSignUp event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(status: SignUpStatus.loading));

    try {
      final regResponse = await http.post(
        Uri.parse("https://www.outletexpense.xyz/api/user-registration"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_name": state.woner_name,
          "outlet_name": state.outlet_name,
          "outlet_type": state.outletType,
          "email": state.email,
          "phone": state.phone,
          "password": state.password,
          "password_confirmation": state.confirmPassword,
        }),
      );

      if (regResponse.statusCode != 200) {
        emit(state.copyWith(status: SignUpStatus.failure));
        return;
      }

      final regData = jsonDecode(regResponse.body);
      final userId = regData["user"]["id"];

      final pinResponse = await http.post(
        Uri.parse("https://www.outletexpense.xyz/api/set-pin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "pin": state.pin,
          "pin_confirmation": state.confirmPin,
        }),
      );

      if (pinResponse.statusCode != 200) {
        emit(state.copyWith(status: SignUpStatus.failure));
        return;
      }

      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SignUpStatus.failure));
    }
  }
}
