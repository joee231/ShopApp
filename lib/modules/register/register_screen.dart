import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cash_helper.dart';
import '../cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var namecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var phonecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isPassword;
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit , ShopRegisterStates>(
          listener: (context , state)
          {
            if (state is ShopRegisterSuccessState) {
              if (state.loginModel.status) {
                print(state.loginModel.message);
                print(state.loginModel.data.access_token);

                CashHelper.saveData(
                    key: 'access_token',
                    value: state.loginModel.data.access_token
                ).then((value)
                {

                  token = state.loginModel.data.access_token!;

                  ShopCubit.get(context).getHomeData();
                  ShopCubit.get(context).getCategories();
                  ShopCubit.get(context).getFavorites();
                  ShopCubit.get(context).getUserData();


                  navigateAndFinish(context, ShopLayout());
                });
              } else {
                print(state.loginModel.message);

                showToast(
                  text: state.loginModel.message,
                  state: ToastStates.ERROR,
                );
              }
            }
          },
          builder: (context , state)
          {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register to our Application",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color: ShopCubit.get(context).isDark ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Register now to browse our hot offers",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 30.0),
                          defaultFormField(
                            controller: namecontroller,
                            type: TextInputType.name,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Name must not be empty';
                              }
                              return null;
                            },
                            label: 'Name',
                            prefix: Icons.person,
                            obsecure: isPassword = false,
                              textColor: ShopCubit.get(context).isDark ? Colors.black : Colors.white

                          ),
                          SizedBox(height: 15.0),
                          defaultFormField(

                            controller: emailcontroller,
                            type: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Email must not be empty';
                              }
                              return null;
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined,
                            obsecure: isPassword = false,
                              textColor: ShopCubit.get(context).isDark ? Colors.black : Colors.white

                          ),
                          SizedBox(height: 15.0),
                          defaultFormField(
                            controller: passwordcontroller,
                            type: TextInputType.visiblePassword,
                            suffix: ShopRegisterCubit.get(context).suffix,
                            isPassword: ShopRegisterCubit.get(context).isPassword,
                            suffixPressed: () {
                              ShopRegisterCubit.get(
                                context,
                              ).ChangePasswordVisibility();
                            },

                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Password must not be empty';
                              }
                              return null;
                            },
                            label: 'password',
                            prefix: Icons.lock_outline,
                            obsecure: null,
                              textColor: ShopCubit.get(context).isDark ? Colors.black : Colors.white

                          ),
                          SizedBox(height: 15.0),
                          defaultFormField(
                            controller: phonecontroller,
                            type: TextInputType.phone,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              return null;
                            },
                            label: 'Phone',
                            prefix: Icons.phone,
                            obsecure: null,
                            textColor: ShopCubit.get(context).isDark ? Colors.black : Colors.white
                          ),
                          SizedBox(height: 30.0),
                          AnimatedConditionalBuilder(
                            condition: state is! ShopRegisterLoadingState,
                            builder:
                                (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: namecontroller.text.trim(),
                                    email: emailcontroller.text.trim(),
                                    password: passwordcontroller.text,
                                    phone: phonecontroller.text.trim(),
                                  );
                                }
                              },
                              text: 'Register',

                              isUpperCase: true,
                              background: Colors.greenAccent,
                            ),
                            fallback:
                                (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
