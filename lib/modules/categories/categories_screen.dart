import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppapp/models/categories_model.dart';

import '../../shared/components/components.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'category_product_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ShopCubit.get(context);
        final model = cubit.categoriesModel;

        if (model == null || model.data == null || model.data!.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = model.data!.data!;

        return ListView.separated(
          itemBuilder: (context, index) =>
              buildCatItem(categories[index], context),
          separatorBuilder: (context, index) => myDividor(),
          itemCount: categories.length,
        );
      },
    );
  }
}

Widget buildCatItem(DataModel model, BuildContext context) => InkWell(
  onTap: () {
    ShopCubit.get(context).getCategoryProducts(model.id!);
    navigateTo(
      context,
      CategoryDetailsScreen(
        categoryId: model.id!,
        categoryName: model.name!,
      ),
    );
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(
          image: NetworkImage(model.image),
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Text(
            model.name,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Icon(Icons.arrow_forward_ios),
      ],
    ),
  ),
);
