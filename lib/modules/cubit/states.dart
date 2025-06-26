

import 'package:meta/meta.dart';
import 'package:shoppapp/models/change_cart_model.dart';

import 'package:shoppapp/models/home_model.dart';

import '../../models/change_favorites_model.dart';
import '../../models/login_model.dart';

abstract class ShopStates {}


class ShopInitialState extends ShopStates {
final bool isDark;

  ShopInitialState(Required , {this.isDark = false});

  // You can also add a constructor to initialize the HomeModel if needed
  // final HomeModel homeModel;
  // ShopInitialState({required this.homeModel});
}


class ShopChangeBottomNavState extends ShopStates {}


class ShopLoadingHomeDataState extends ShopStates {}


class ShopSuccessHomeDataState extends ShopStates {}


class ShopErrorHomeDataState extends ShopStates {
  final String error;

  ShopErrorHomeDataState(this.error);
}


class ShopSuccessCategoriesDataState extends ShopStates {}


class ShopErroCategoriesDataState extends ShopStates {
  final String error;

  ShopErroCategoriesDataState(this.error);
}


class ShopSuccessChangeFavoritesState extends ShopStates
{
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesState(this.model);
}


class ShopChangeFavoritesState extends ShopStates {}


class ShopErroChangeFavoritesState extends ShopStates {
  final String error;

  ShopErroChangeFavoritesState(this.error);
}

class ShopSuccessGetFavoritesDataState extends ShopStates {}


class ShopLoadingGetFavoritesDataState extends ShopStates {}


class ShopErroGetFavoritesDataState extends ShopStates {
  final String error;

  ShopErroGetFavoritesDataState(this.error);
}

class ShopSuccessGetUserDataState extends ShopStates
{
  final ShopLoginModel loginModel;

  ShopSuccessGetUserDataState(this.loginModel);
}


class ShopLoadingGetUserDataState extends ShopStates {}


class ShopErroGetUserDataState extends ShopStates {
  final String error;

  ShopErroGetUserDataState(this.error);
}
class ShopSuccessUpdateUserDataState extends ShopStates
{
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserDataState(this.loginModel);
}


class ShopLoadingUpdateUserDataState extends ShopStates {}


class ShopErroUpdateUserDataState extends ShopStates {
  final String error;

  ShopErroUpdateUserDataState(this.error);
}

class AppChangeThemeState extends ShopStates {}


class ShopSuccessChangeCartState extends ShopStates
{
  final ChangeCartModel model;

  ShopSuccessChangeCartState(this.model);
}


class ShopChangeCartState extends ShopStates {}


class ShopErroChangeCartState extends ShopStates {
  final String error;

  ShopErroChangeCartState(this.error);
}

class ShopSuccessGetCartDataState extends ShopStates {}


class ShopLoadingGetCartDataState extends ShopStates {}



class ShopLoadingUpdateCartQuantityState extends ShopStates {}


class ShopErroGetCartDataState extends ShopStates {
  final String error;

  ShopErroGetCartDataState(this.error);
}

class ShopSuccessUpdateCartQuantityState extends ShopStates
{

}

class ShopErroUpdateCartQuantityState extends ShopStates
{
  final String error;

  ShopErroUpdateCartQuantityState(this.error);
}
class ShopAppliedPromoState extends ShopStates {}

class ShopLoadingCategoryProductsState extends ShopStates {}
class ShopSuccessCategoryProductsState extends ShopStates {}
class ShopErrorCategoryProductsState extends ShopStates {
  final String error;
  ShopErrorCategoryProductsState(this.error);
}