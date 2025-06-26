import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppapp/modules/login/cubit/states.dart';

import '../../../models/login_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/local/cash_helper.dart';
import '../../../shared/network/remote/dio_helper.dart';


class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(BuildContext context) => BlocProvider.of(context);

   late ShopLoginModel loginModel;
  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());

    print('📨 Sending login request...');
    print('Email: $email');
    print('Password: $password');

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value?.data);
      emit(ShopLoginSuccessState(loginModel));
      token = 'Bearer ${loginModel.data.access_token!}';
      CashHelper.saveData(
          key: 'access_token',
          value: token
      );
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  void ChangePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopLoginChangePasswordVisibilityState());
  }
}
