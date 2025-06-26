import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/style/colors.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../search/search_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // Filter products that are marked as favorites

        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Cart'
            ),
            actions: [
              IconButton(
                onPressed: ()
                {
                  navigateTo(context, CartScreen());
                },
                icon: Icon(Icons.shopping_cart),
              ),
              IconButton(
                  onPressed: ()
                  {
                    ShopCubit.get(context).changeAppMode();
                  },
                  icon: Icon(
                    ShopCubit.get(context).isDark ? Icons.brightness_2 : Icons.brightness_7,
                  )
              ),
              IconButton(
                onPressed: ()
                {
                  navigateTo(context, SearchScreen());
                },
                icon: Icon(Icons.search),
              ),

            ],
          ),
          body: AnimatedConditionalBuilder(
            condition: state is! ShopLoadingGetCartDataState &&
                ShopCubit.get(context).cartModel != null &&
                ShopCubit.get(context).cartModel!.data != null &&
                ShopCubit.get(context).cartModel!.data!.data != null,
            builder: (context) {
              final cartItems = ShopCubit.get(context).cartModel!.data!.data!;

              if (cartItems.isEmpty) {
                return Center(child: Text("Your cart is empty."));
              }

              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: cartItems.length,
                separatorBuilder: (context, index) => myDividor(),
                itemBuilder: (context, index) {
                  final product = cartItems[index].data!;
                  return buildCartProduct(product, context, cartItems[index].id);
                },
              );
            },
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }




}
