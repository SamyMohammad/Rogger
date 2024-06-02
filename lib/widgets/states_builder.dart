import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'error_view.dart';
import 'loading_indicator.dart';
import 'no_content.dart';

class StatesBuilder<B extends BlocBase<S>, S> extends StatelessWidget {
  StatesBuilder({
    this.onInit,
    this.onSuccess,
    this.cubit,
    this.onLoading,
    this.onEmpty,
    this.onError,
    this.builder,
    this.buildWhen,
  });
  // : assert(onSuccess == null || onSuccess is Function || onSuccess is Widget, 'onSuccess Must be a Function returns Widget or Widget');
  final Widget? onInit;
  final Widget Function(BuildContext context)? onSuccess;
  final Widget? onLoading;
  final Widget? onError;
  final Widget? onEmpty;
  final B? Function(BuildContext context)? cubit;
  final Widget Function(BuildContext, S)? builder;
  final bool Function(S, S)? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: cubit == null ? null : cubit!(context),
      buildWhen: buildWhen != null
          ? buildWhen!
          : (previous, current) => builder != null || current is BaseStates,
      builder: builder == null
          ? (context, state) {
              if (state is BaseLoadingState)
                return onLoading ?? LoadingIndicator();
              else if (state is BaseErrorState)
                return onError ?? ErrorView();
              else if (state is BaseSuccessState)
                return onSuccess == null ? SizedBox() : onSuccess!(context);
              else if (state is BaseEmptyState) return onEmpty ?? NoContent();
              return onInit ?? Center(child: Text('Init State'));
              /*
        if(state is BaseLoadingState)
          return onLoading ?? SizedBox();
        else if(state is BaseErrorState)
          return onError ?? SizedBox();
        else if(state is BaseSuccessState)
          return onSuccess ?? SizedBox();
        else if(state is BaseEmptyState)
          return onEmpty ?? SizedBox();
        return onInit ?? SizedBox();
         */
            }
          : builder!,
    );
  }
}

abstract class BaseStates {}

class BaseInitState extends BaseStates {}

class BaseLoadingState extends BaseStates {}

class BaseSuccessState extends BaseStates {}

class BaseErrorState extends BaseStates {}

class BaseEmptyState extends BaseStates {}
