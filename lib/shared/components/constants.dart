

import '../../modules/login/shop_login_screen.dart';
import '../network/local/cash_helper.dart';
import 'components.dart';

void signOut(context)
{
  CashHelper.removeData(key: 'access_token').then((value)
  {
    if (value)
    {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the max length of each line
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}


String token = '';