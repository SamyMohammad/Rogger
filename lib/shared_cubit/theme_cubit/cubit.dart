import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/shared_cubit/theme_cubit/states.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeInitState());

  static ThemeCubit of(context) => BlocProvider.of(context);
  // static ThemeCubit get(context) => BlocProvider.of<ThemeCubit>(context);

  bool isDark = false;

// //Switching the themes
//   setThemes(bool value) {
//     // isDark = value;
//     AppStorage.cacheTheme(value);
//     emit(SetThemeState());
//   }
//
//   getThemes() {
//     // isDark = AppStorage.getTheme() ?? false;
//     emit(GetThemeState());
//   }

  ThemeMode appTheme = ThemeMode.light;

  void changeTheme(ThemeMode newMode) async {
    if (appTheme == newMode) {
      return;
    }
    print(newMode);
    appTheme = newMode;
    AppStorage.cacheTheme(newMode);
    emit(SetThemeState());
  }

  bool isDarkMode() {
    isDark = (appTheme == ThemeMode.dark);
    return appTheme == ThemeMode.dark;
  }
}
