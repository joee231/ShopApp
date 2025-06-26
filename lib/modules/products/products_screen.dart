import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/categories_model.dart';
import '../../models/home_model.dart';
import '../../shared/components/components.dart';
import '../../shared/style/colors.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';


class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state)
      {
        if(state is ShopSuccessChangeFavoritesState)
        {
          if (!state.model.status == false) {
           showToast(
               text: state.model.message,
               state: ToastStates.ERROR
           );
          } else {
            showToast(
                text: state.model.message,
                state: ToastStates.SUCCESS,
            );
          }  
        }
      },
      builder: (context, state) {
        return AnimatedConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null,
          builder:
              (context) => productBuilder(ShopCubit.get(context).homeModel! ,ShopCubit.get(context).categoriesModel! , context),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productBuilder(HomeModel model , CategoriesModel categoriesModel, BuildContext context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items:
              model.data.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
          options: CarouselOptions(
            height: 250.0,
            initialPage: 0,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 100.0,
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context , index) => buildCategoryItem(categoriesModel.data!.data![index]),
                    separatorBuilder: (cotext , index) => SizedBox(width: 10.0),
                    itemCount: categoriesModel.data!.data!.length,
                    scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'NEW PRODUCTS',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          color: ShopCubit.get(context).isDark ? Colors.grey[200] : Colors.grey[800],
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.58,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            children: List.generate(
              model.data.products.length,
              (index) => buildGridProduct(model.data.products[index] , context),
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildGridProduct(ProductModel model , context) => Container(
    color: ShopCubit.get(context).isDark ? Colors.white : Colors.grey[800],
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage('${model.image}'),
                    height: 200.0,
                    width: double.infinity,
                  ),
                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        "DISCOUNT",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${model.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.3, fontSize: 14.0,
                color: ShopCubit.get(context).isDark ? Colors.black : Colors.white),
              ),
              Row(
                children: [
                  Text(
                    '${model.price.round()}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: defaultColor),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    '${model.old_price.round()}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () 
                    {
                      ShopCubit.get(context).changeFavorites(model.id);
                      print(model.id);
                    },
                    icon: CircleAvatar(
                     radius: 15.0,
                      backgroundColor:ShopCubit.get(context).favorites[model.id]! ? defaultColor  : Colors.grey,
                      child: Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: ()  async {
                      final isAdded =  ShopCubit.get(context).changeCart(model.id!);

                      showToast(
                        text: await isAdded ?  'Removed from cart' : 'Added to cart' ,
                        state: await isAdded ? ToastStates.WARNING : ToastStates.SUCCESS,
                      );

                      print(model.id);
                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.grey,
                      child: const Icon(
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
      ],
    ),
  );
}
Widget buildCategoryItem(DataModel model) => Stack(
  alignment: AlignmentDirectional.bottomCenter,
  children: [
    Image(
      image: NetworkImage(
        model.image,
      ),
      height: 100.0,
      width: 100.0,
      fit: BoxFit.cover,
    ),
    Container(
      color: Colors.black.withOpacity(0.8),
      width: 100.0,
      child: Text(
        model.name,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
);
