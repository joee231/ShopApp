import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/home_model.dart';
import '../../shared/components/components.dart';
import '../../shared/style/colors.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const CategoryDetailsScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = ShopCubit.get(context);
    final allProducts = cubit.homeModel?.data.products ?? [];

    final categoryProducts = allProducts.where((product) => product.cat_id == categoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: categoryProducts.isEmpty
          ? const Center(child: Text('No products found in this category.'))
          : ListView.separated(
        itemCount: categoryProducts.length,
        separatorBuilder: (context, index) => myDividor(),
        itemBuilder: (context, index) => buildGridProduct(categoryProducts[index], context),
      ),
    );
  }

  Widget buildGridProduct(ProductModel model, BuildContext context) => Container(
    color: ShopCubit.get(context).isDark ? Colors.white : Colors.grey[800],
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: const Text(
                    "DISCOUNT",
                    style: TextStyle(color: Colors.white, fontSize: 10.0),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            model.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.3,
              fontSize: 14.0,
              color: ShopCubit.get(context).isDark ? Colors.black : Colors.white,
            ),
          ),
          Row(
            children: [
              Text(
                '${model.price}',
                style: TextStyle(fontSize: 14.0, color: defaultColor),
              ),
              const SizedBox(width: 5.0),
              if (model.discount != 0)
                Text(
                  '${model.old_price}',
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ShopCubit.get(context).changeFavorites(model.id);
                  print(model.id);
                },
                icon: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: ShopCubit.get(context).favorites[model.id]! ? defaultColor : Colors.grey,
                  child: const Icon(
                    Icons.favorite_border,
                    size: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final isAdded = ShopCubit.get(context).changeCart(model.id);
                  showToast(
                    text: isAdded ? 'Removed from cart' : 'Added to cart',
                    state: isAdded ? ToastStates.WARNING : ToastStates.SUCCESS,
                  );
                  print(model.id);
                },
                icon: const CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.add_shopping_cart,
                    size: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
