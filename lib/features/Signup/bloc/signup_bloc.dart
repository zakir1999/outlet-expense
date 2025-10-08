

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/signup_data.dart';
import '../repository/signup_respository.dart';
import 'signup_event.dart';
import 'signup_state.dart';


class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final ApiService apiService;

  SignupBloc(this.apiService) : super(SignupInitial(const SignupData())) {
    on<UpdateWonerName>(_onUpdateWonerName);
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
    on<SubmitPinEvent>(_onSubmitPin);
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

  void _onUpdateWonerName(UpdateWonerName event, Emitter<SignupState> emit) {
    final updatedData = currentData.copyWith(ownerName: event.wonerName);
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
    final updatedData = currentData.copyWith(phoneNumber: event.phone);
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
      final filteredData = SignupData(
        ownerName: currentData.ownerName,
        outletName: currentData.outletName,
        email: currentData.email,
        phone: currentData.phone,
        password: currentData.password,
      );

      await apiService.submitSignupData(filteredData);
      emit(SignupSuccess(currentData));
    } catch (e) {
      emit(SignupError(currentData, e.toString()));
    }
  }
  void _onSubmitPin(SubmitPinEvent event, Emitter<SignupState> emit) async {
    emit(SignupSubmitting(currentData));
    try {
      await apiService.setPin(currentData);
      emit(SignupSuccess(currentData));
    } catch (e) {
      emit(SignupError(currentData, e.toString()));
    }
  }

}
