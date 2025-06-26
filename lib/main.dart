import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppapp/shared/components/constants.dart';
import 'package:shoppapp/shared/network/bloc_observer.dart';
import 'package:shoppapp/shared/network/local/cash_helper.dart';
import 'package:shoppapp/shared/network/remote/dio_helper.dart';
import 'package:shoppapp/shared/style/themes.dart';

import 'layout/shop_layout.dart';
import 'modules/cubit/cubit.dart';
import 'modules/cubit/states.dart';
import 'modules/login/shop_login_screen.dart';
import 'modules/onboard/onboarding_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await CashHelper.init();
  DioHelper.init();

  // Load settings
  bool isDark = CashHelper.getData(key: 'isDark') ?? false;
  final bool onBoarding = CashHelper.getData(key: 'onboarding') ?? false;
  token = CashHelper.getData(key: 'access_token') ?? '';

  Widget startWidget;

  if (onBoarding) {
    startWidget = token.isNotEmpty ? ShopLayout() : ShopLoginScreen();

  } else {
    startWidget = OnBoardingScreen();
    isDark = false;
  }
  runApp(MyApp(isDark: isDark, startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  const MyApp({
    Key? key,
    required this.isDark,
    required this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /*BlocProvider(
          create: (context) =>
          NewsCubit()..getBusiness()..getScience()..getSports()..changeAppMode(fromShared: isDark),
        ),*/
        BlocProvider(
          create: (context) => ShopCubit(isDark : isDark)..getHomeData()..getCategories()..getFavorites()..getUserData()..isDark..getCart(),
        ),
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lighttheme,
            darkTheme: darktheme,
            themeMode:  (ShopCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light),
            home: startWidget,
          );
        },
      ),
    );
  }
}
