import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/shared/search/model.dart';

import '../../core/dio_manager/dio_manager.dart';

part 'states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInit());

  static SearchCubit of(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  List<String> history = [];
  bool nearest = false;
  String? _lastWordSearch;

  Future<void> search(String search, {bool cache = true}) async {
    if (search.isEmpty) return;
    closeKeyboard();
    if (cache) cacheHistory(search);
    searchModel = null;
    emit(SearchLoading());
    final response = await DioHelper.post(
      'common/product/search',
      data: {
        "search_txt": search,
        "start": 0,
        "limit": 1000 * 1000 * 1000 * 1000,
        if (AppStorage.isLogged) "customer_id": AppStorage.customerID,
        if (AppStorage.isLogged) "nearest": nearest,
      },
    );
    _lastWordSearch = search;
    searchModel = SearchModel.fromJson(response.data);
    emit(searchModel == null || searchModel?.products.isEmpty == true
        ? SearchEmpty()
        : SearchInit());
  }

  Future<void> getHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    history.clear();
    history = sharedPreferences.getStringList('history') ?? [];
    emit(SearchInit());
  }

  Future<void> cacheHistory(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> historyList = sharedPreferences.getStringList('history') ?? [];
    historyList.insert(0, value);
    history.clear();
    history.addAll(historyList);
    sharedPreferences.setStringList('history', historyList);
  }

  Future<void> clearHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('history');
    history.clear();
    emit(SearchInit());
  }

  Future<void> toggleNearestButton() async {
    nearest = !nearest;
    emit(SearchInit());
    if (_lastWordSearch != null) {
      search(_lastWordSearch!, cache: false);
    }
  }
}
