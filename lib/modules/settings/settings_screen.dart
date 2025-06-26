import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';


class SettingsScreen extends StatelessWidget {
  var FormKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        nameController.text = model.data.name!;
        emailController.text = model.data.email!;
        phoneController.text = model.data.phone!;

        return AnimatedConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder:
              (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: FormKey,
                  child: Column(
                    children: [
                      if(state is ShopLoadingUpdateUserDataState)
                      LinearProgressIndicator(),
                      SizedBox(height: 20.0),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Name must not be empty';
                          }
                          return null;
                        },
                        label: "Name",
                        prefix: Icons.person,
                        obsecure: null,
                          textColor: ShopCubit.get(context).isDark ? Colors.black : Colors.white

                      ),
                      SizedBox(height: 20.0),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Email must not be empty';
                          }
                          return null;
                        },
                        label: "Email Address",
                        prefix: Icons.email,
                        obsecure: null,
                          textColor: ShopCubit.get(context).isDark ? Colors.black : Colors.white

                      ),
                      SizedBox(height: 20.0),
                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Phone must not be empty';
                          }
                          return null;
                        },
                        label: "Phone",
                        prefix: Icons.phone,
                        obsecure: null,
                          textColor: ShopCubit.get(context).isDark ? Colors.black : Colors.white

                      ),
                      SizedBox(height: 20.0),
                      defaultButton(
                        function: () {
                          if (FormKey.currentState!.validate()) {
                            ShopCubit.get(context).UpdateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                        text: 'Update',
                        background: Colors.greenAccent,
                      ),
                      SizedBox(height: 20.0),
                      defaultButton(
                        function: () {
                          signOut(context);
                        },
                        text: 'Logout',
                        background: Colors.greenAccent,
                      ),

                    ],
                  ),
                ),
              ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
