import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppapp/modules/register/cubit/states.dart';

import '../../../models/login_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/local/cash_helper.dart';
import '../../../shared/network/remote/dio_helper.dart';


class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(BuildContext context) => BlocProvider.of(context);

   late ShopLoginModel RegisterModel;
  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(ShopRegisterLoadingState());

    print('📨 Sending Register request...');
    print('Email: $email');
    print('Password: $password');

    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      print('✅ Register Success → ${value?.data}');
      RegisterModel = ShopLoginModel.fromJson(value?.data);
      emit(ShopRegisterSuccessState(RegisterModel));
      token = 'Bearer ${RegisterModel.data.access_token!}';
      CashHelper.saveData(
          key: 'access_token',
          value: token
      );
    }).catchError((error) {
      if (error is DioError) {
        print('❌ Status Code: ${error.response?.statusCode}');
        print('❌ Error Body: ${error.response?.data}');
      }
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  void ChangePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
