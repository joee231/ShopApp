import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/cart/cart_screen.dart';
import '../modules/cubit/cubit.dart';
import '../modules/cubit/states.dart';
import '../modules/search/search_screen.dart';
import '../shared/components/components.dart';


class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state){},
      builder: (context , state) {

        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
                'matgarak'
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
          body: cubit.bottomscreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottom(index);
            },
          ),
        );
      },
    );
  }
}
