import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppapp/modules/cubit/states.dart';

import '../../models/FavoritesModel.dart';
import '../../models/cart_model.dart';
import '../../models/categories_model.dart';
import '../../models/category_product_model.dart';
import '../../models/change_cart_model.dart';
import '../../models/change_favorites_model.dart';
import '../../models/home_model.dart';
import '../../models/login_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/end_points.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../categories/categories_screen.dart';
import '../favorites/favorites_screen.dart';
import '../products/products_screen.dart';
import '../settings/settings_screen.dart';


class ShopCubit extends Cubit<ShopStates> {
  ShopCubit({required bool isDark}) : super(ShopInitialState(isDark));

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomscreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  Map<int, bool> cart = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    //print('BASE: ${DioHelper.dio?.options.baseUrl}');
    //print('ENDPOINT: $HOME');
    //print('FULL: ${DioHelper.dio?.options.baseUrl}$HOME');
    //print('TOKEN: $token');

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      //print('RESPONSE DATA: ${value?.data}');

      // ✅ Check if response was successful
      if (value != null && value.data['status'] == true) {
        // ✅ Safely parse the model
        try {
          homeModel = HomeModel.fromJson(value.data);


          homeModel?.data.products.forEach((element) {
            favorites[element.id] = element.in_favorites;
            cart[element.id] = false; // Initialize cart map safely
          });


          //print(favorites.toString());

          emit(ShopSuccessHomeDataState());
        } catch (e) {
          //print('❌ JSON parsing failed: $e');
          emit(ShopErrorHomeDataState('Failed to parse home data'));
        }
      } else {
        emit(ShopErrorHomeDataState(
            'Invalid response format or status = false'));
      }
    }).catchError((error) {
      if (error is DioError) {
        //print('❌ Status Code: ${error.response?.statusCode}');
        //print('❌ URI: ${error.requestOptions.uri}');
        //print('❌ Body: ${error.response?.data}');
      }
      emit(ShopErrorHomeDataState(error.toString()));
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    //print('BASE: ${DioHelper.dio?.options.baseUrl}');
    //print('ENDPOINT: $HOME');
    //print('FULL: ${DioHelper.dio?.options.baseUrl}$HOME');
    //print('TOKEN: $token');

    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      //print('RESPONSE DATA: ${value?.data}');

      // ✅ Check if response was successful
      if (value != null && value.data['status'] == true) {
        // ✅ Safely parse the model
        try {
          categoriesModel = CategoriesModel.fromJson(value.data);

          emit(ShopSuccessCategoriesDataState());
        } catch (e) {
          //print('❌ JSON parsing failed: $e');
          emit(ShopErroCategoriesDataState('Failed to parse home data'));
        }
      } else {
        emit(ShopErroCategoriesDataState(
            'Invalid response format or status = false'));
      }
    }).catchError((error) {
      if (error is DioError) {
        //print('❌ Status Code: ${error.response?.statusCode}');
        //print('❌ URI: ${error.requestOptions.uri}');
        //print('❌ Body: ${error.response?.data}');
      }
      emit(ShopErroCategoriesDataState(error.toString()));
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int producId) {
    favorites[producId] = !favorites[producId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data:
      {
        'product_id': producId,
      },
      token: token,
    )
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value!.data);
      //print('ChangeFavoritesModel: ${value.data}');

      if (!changeFavoritesModel!.status) {
        favorites[producId] = !favorites[producId]!;
        //print('Error: ${changeFavoritesModel!.message}');
        emit(ShopErroChangeFavoritesState(changeFavoritesModel!.message));
        return;
      } else {
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    })
        .catchError((error) {
      favorites[producId] = !favorites[producId]!;


      emit(ShopErroChangeFavoritesState(error.toString()));
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesDataState());

    print('BASE: ${DioHelper.dio?.options.baseUrl}');
    print('ENDPOINT: $HOME');
    print('FULL: ${DioHelper.dio?.options.baseUrl}$HOME');
    print('TOKEN: $token');

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      print('RESPONSE DATA: ${value?.data}');

      // ✅ Check if response was successful
      if (value != null && value.data['status'] == true) {
        // ✅ Safely parse the model
        try {
          favoritesModel = FavoritesModel.fromJson(value.data);
          //printFullText(value.data.toString());

          emit(ShopSuccessGetFavoritesDataState());
        } catch (e) {
          //print('❌ JSON parsing failed: $e');
          emit(ShopErroGetFavoritesDataState('Failed to parse home data'));
        }
      } else {
        emit(ShopErroGetFavoritesDataState(
            'Invalid response format or status = false'));
      }
    }).catchError((error) {
      if (error is DioError) {
        //print('❌ Status Code: ${error.response?.statusCode}');
        //print('❌ URI: ${error.requestOptions.uri}');
        //print('❌ Body: ${error.response?.data}');
      }
      emit(ShopErroGetFavoritesDataState(error.toString()));
    });
  }

  late ShopLoginModel userModel;

  void getUserData() {
    emit(ShopLoadingGetUserDataState());

    //print('BASE: ${DioHelper.dio?.options.baseUrl}');
    //print('ENDPOINT: $HOME');
    //print('FULL: ${DioHelper.dio?.options.baseUrl}$HOME');
    //print('TOKEN: $token');

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      //print('RESPONSE DATA: ${value?.data}');

      // ✅ Check if response was successful
      if (value != null && value.data['status'] == true) {
        // ✅ Safely parse the model
        try {
          userModel = ShopLoginModel.fromJson(value.data);
          //printFullText(userModel!.data!.name!);
          emit(ShopSuccessGetUserDataState(userModel));
        } catch (e) {
          ////print('❌ JSON parsing failed: $e');
          emit(ShopErroGetUserDataState('Failed to parse home data'));
        }
      } else {
        emit(ShopErroGetUserDataState(
            'Invalid response format or status = false'));
      }
    }).catchError((error) {
      if (error is DioError) {
        //print('❌ Status Code: ${error.response?.statusCode}');
        //print('❌ URI: ${error.requestOptions.uri}');
        //print('❌ Body: ${error.response?.data}');
      }
      emit(ShopErroGetUserDataState(error.toString()));
    });
  }

  void UpdateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserDataState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      if (value != null && value.data['status'] == true) {
        try {
          userModel = ShopLoginModel.fromJson(value.data);

          // 🚫 DO NOT update token unless you're rotating intentionally
          final newToken = value.data['data']['access_token'];
          if (newToken != null &&
              newToken
                  .toString()
                  .isNotEmpty &&
              newToken != token) {
            // Only update if you're sure it's needed, otherwise just log
            print('ℹ️ Ignoring new token: $newToken');
            // token = newToken; // ❌ Do not override unless you really need to
          }

          getUserData(); // Use the existing valid token
          emit(ShopSuccessUpdateUserDataState(userModel));
        } catch (e) {
          emit(ShopErroUpdateUserDataState('Parsing error: $e'));
        }
      } else {
        emit(ShopErroUpdateUserDataState('Update failed: status false'));
      }
    }).catchError((error) {
      print('❌ Error during update: $error');
      emit(ShopErroUpdateUserDataState('Error during update: $error'));
    });
  }

  bool isDark = false;


  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeThemeState());
    } else {
      isDark = !isDark;
      CashHelper.saveData(key: 'isDark', value: isDark);
      emit(AppChangeThemeState());
    }
  }

  ChangeCartModel? changeCartModel;

  bool  changeCart(int producId) {
    cart[producId] = !cart[producId]!;

    emit(ShopChangeCartState());

    DioHelper.postData(
      url: CART,
      data:
      {
        'product_id': producId,
      },
      token: token,
    )
        .then((value) {
      changeCartModel = ChangeCartModel.fromJson(value!.data);
      print('ChangeCartModel: ${value.data}');

      if (!changeCartModel!.status) {
        cart[producId] = !cart[producId]!;
        print('Error: ${changeCartModel!.message}');
        emit(ShopErroChangeCartState(changeCartModel!.message));
        return false;
      } else {
        getCart();

      }

      emit(ShopSuccessChangeCartState(changeCartModel!));
      return true;
    })
        .catchError((error) {
      cart[producId] = !cart[producId]!;


      emit(ShopErroChangeCartState(error.toString()));
      return false;
    });

    return false;
  }

  CartModel? cartModel;

  void getCart() {
    emit(ShopLoadingGetCartDataState());

    print('BASE: ${DioHelper.dio?.options.baseUrl}');
    print('ENDPOINT: $HOME');
    print('FULL: ${DioHelper.dio?.options.baseUrl}$HOME');
    print('TOKEN: $token');


    DioHelper.getData(
      url: CART,
      token: token,
    ).then((value) {
      print('RESPONSE DATA: ${value?.data}');

      // ✅ Check if response was successful
      if (value!.data['status'] == true) {
        // ✅ Safely parse the model
        try {
          cartModel = CartModel.fromJson(value.data);
          printFullText(value.data.toString());

          emit(ShopSuccessGetCartDataState());
        } catch (e) {
          print('❌ JSON parsing failed: $e');
          emit(ShopErroGetCartDataState('Failed to parse home data'));
        }
      } else {
        emit(ShopErroGetCartDataState(
            'Invalid response format or status = false'));
      }
    }).catchError((error) {
      if (error is DioError) {
        print('❌ Status Code: ${error.response?.statusCode}');
        print('❌ URI: ${error.requestOptions.uri}');
        print('❌ Body: ${error.response?.data}');
      }
      emit(ShopErroGetCartDataState(error.toString()));
    });
  }

  void updateCartQuantity({
    required int productId,
    required int quantity,
  }) {
    emit(ShopLoadingUpdateCartQuantityState());

    DioHelper.putData(
      url: '$CART/$productId',
      token: token,
      data: {
        'quantity': quantity,
      },
    ).then((value) {
      if (value != null && value.data['status'] == true) {
        getCart();
        emit(ShopSuccessUpdateCartQuantityState());
      } else {
        emit(ShopErroUpdateCartQuantityState('Failed to update cart quantity'));
      }
    }).catchError((error) {
      print('❌ Error during update: $error');
      emit(ShopErroUpdateCartQuantityState('Error during update: $error'));
    });
  }
  CategoryProductModel? categoryProductsModel;

  void getCategoryProducts(int categoryId) {
    emit(ShopLoadingCategoryProductsState());

    DioHelper.getData(
      url: 'products?category_id=$categoryId',
      token: token,
    ).then((value) {
      try {
        categoryProductsModel = CategoryProductModel.fromJson(value!.data);
        emit(ShopSuccessCategoryProductsState());
      } catch (e) {
        emit(ShopErrorCategoryProductsState('Parsing error: $e'));
      }
    }).catchError((error) {
      emit(ShopErrorCategoryProductsState(error.toString()));
    });
  }

}

