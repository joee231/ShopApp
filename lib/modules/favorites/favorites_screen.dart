import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // Filter products that are marked as favorites

        return AnimatedConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesDataState,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: ShopCubit.get(context).favoritesModel!.data!.data!.length,
            separatorBuilder: (context, index) => myDividor(),
            itemBuilder:
                (context, index) => buildListProduct(
              ShopCubit.get(context).favoritesModel!.data!.data![index].product!,
              context,
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}
