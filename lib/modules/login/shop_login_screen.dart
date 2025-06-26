import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../layout/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cash_helper.dart';
import '../cubit/cubit.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class ShopLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
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

                navigateAndFinish(context, BlocProvider.value(value: ShopCubit.get(context)..getHomeData()..getFavorites()..getCategories()..getUserData(), child: ShopLayout()));
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
        builder: (context, state) {
          bool isPassword;
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
                          "Login to Your Account",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: ShopCubit.get(context).isDark ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Login now to browse our hot offers",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 30.0),
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
                          suffix: ShopLoginCubit.get(context).suffix,
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopLoginCubit.get(
                              context,
                            ).ChangePasswordVisibility();
                          },
                          onSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailcontroller.text.trim(),
                                password: passwordcontroller.text,
                              );
                            }
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
                        SizedBox(height: 30.0),
                        AnimatedConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder:
                              (context) => defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                      email: emailcontroller.text.trim(),
                                      password: passwordcontroller.text,
                                    );
                                  }
                                },
                                text: 'Login',

                                isUpperCase: true,
                                background: Colors.greenAccent,
                              ),
                          fallback:
                              (context) =>
                                  Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("don't have an account?"),
                            defaultTextButton(
                              function: () {
                                navigateTo(
                                  context,
                                  RegisterScreen(),
                                ); // Navigate to the register screen
                              },
                              text: 'Register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
