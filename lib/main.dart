import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:jiffy/jiffy.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/bloc_observer.dart';
import 'package:silah/core/cities/cubit/cubit.dart';
import 'package:silah/core/customer_groups/cubit/cubit.dart';
import 'package:silah/core/dio_manager/dio_manager.dart';
import 'package:silah/shared_cubit/home_products/cubit.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/shared_cubit/theme_cubit/states.dart';

import 'constants.dart';
import 'core/firebase_options.dart';
import 'core/router/router.dart';
import 'shared/splash/view.dart';
import 'shared_cubit/category_cubit/cubit.dart';
import 'widgets/pop_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();

  await DownloadCacheManager.setExpireDate(daysToExpire: 3);
  await AppStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterBranchSdk.init().then((value) {
    FlutterBranchSdk.validateSDKIntegration();
  });
  initializeFirebaseCrashlytics();

  Jiffy.setLocale('ar');
  // getUserAndCache(185, 1);
  // getUserAndCache(186, 2);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late ThemeCubit themeCubit;
  initSharedPref(BuildContext context) async {
    String? theme = AppStorage.getTheme();

    if (theme == 'light') {
      themeCubit.changeTheme(ThemeMode.light);
    } else if (theme == 'dark') {
      themeCubit.changeTheme(ThemeMode.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CitiesCubit()..getCities(), lazy: false),
        BlocProvider(
            create: (context) => CategoryCubit()
              ..getCategories()
              ..getPaidCategories()
              ,
            lazy: false),
        BlocProvider(
            create: (context) => HomeProductsCubit()
              ..getHomeProductsData()
              ..checkIfUserBanned(),
            lazy: false),
        // BlocProvider(create: (context) => ProductCubit()..getProductData(),),
        BlocProvider(
            create: (context) => CustomerGroupsCubit()..getCustomGroup()),
        BlocProvider(create: (context) => ThemeCubit())
      ],
      child: BlocConsumer<ThemeCubit, ThemeStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          themeCubit = ThemeCubit.of(context);
          initSharedPref(context);
          return MaterialApp(
            navigatorKey: navigatorKey,
            onGenerateRoute: onGenerateRoute,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeCubit.appTheme,
            builder: (context, child) => PopScaffold(child: child!),
            home: SplashView(),
          );
        },
      ),
    );
  }
}
