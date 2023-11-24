import 'package:flutter/material.dart';
import 'package:loginapp/login_screen.dart';
import 'package:loginapp/main_screen.dart';
import 'package:loginapp/register_screen.dart';
import 'package:loginapp/screen_tk/doimatkhau.dart';
import 'package:loginapp/screen_tk/huongdan_screen.dart';
import 'package:loginapp/screen_tk/lichsugiaodich.dart';
import 'package:loginapp/screen_tk/lienhe.dart';
import 'package:loginapp/screen_tk/suathongtin.dart';
import 'package:loginapp/screen_tk/themtienthach.dart';
import 'package:loginapp/screen_tk/xoataikhoan.dart';
import 'package:loginapp/screens/introsignin.dart';
import 'package:loginapp/screens/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  IntroSigin.routeName: (context) => const IntroSigin(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  HuongDanScreen.routeName: (context) => const HuongDanScreen(),
  SuaThongTin.routeName: (context) => const SuaThongTin(),
  LienHe.routeName: (context) => const LienHe(),
  XoaTaiKhoan.routeName: (context) => const XoaTaiKhoan(),
  ThemTienThach.routeName: (context) => ThemTienThach(),
};
class CustomPageRouteBuilder<T> extends PageRoute<T> {
  final RoutePageBuilder pageBuilder;
  final PageTransitionsBuilder matchingBuilder =
      const CupertinoPageTransitionsBuilder(); // Default iOS/macOS (to get the swipe right to go back gesture)
  // final PageTransitionsBuilder matchingBuilder = const FadeUpwardsPageTransitionsBuilder(); // Default Android/Linux/Windows

  CustomPageRouteBuilder({required this.pageBuilder});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return pageBuilder(context, animation, secondaryAnimation);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(
      milliseconds:
          900); // Can give custom Duration, unlike in MaterialPageRoute

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return matchingBuilder.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }
}
class RouteUtil{
    static Route _createRouteByName(
      String routeName, Widget toScreen, bool isFullscreenDialog) {
    return CustomPageRouteBuilder(
      pageBuilder: (context, animation, _) => toScreen,
    );
      }
    static bool redirectToLoginScreen(BuildContext context) {
    try {
      Navigator.of(context).push(
          _createRouteByName(MainScreen.routeName, LoginScreen(), false));
      return true;
    } catch (e) {
      return false;
    }
  }
    static bool redirectToRegisterScreen(BuildContext context) {
    try {
      Navigator.of(context).push(_createRouteByName(
          MainScreen.routeName, const RegisterScreen(), false));
      return true;
    } catch (e) {
      return false;
    }
  }
  }
