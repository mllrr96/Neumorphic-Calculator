// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:neumorphic_calculator/bloc/calculator_bloc/calculator_bloc.dart'
    as _i4;
import 'package:neumorphic_calculator/bloc/history_bloc/history_bloc.dart'
    as _i8;
import 'package:neumorphic_calculator/bloc/page_cubit/page_cubit.dart' as _i5;
import 'package:neumorphic_calculator/di/module.dart' as _i9;
import 'package:neumorphic_calculator/repo/database.dart' as _i7;
import 'package:neumorphic_calculator/service/preference_service.dart' as _i6;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    gh.factory<_i4.CalculatorBloc>(() => _i4.CalculatorBloc());
    gh.factory<_i5.PageCubit>(() => _i5.PageCubit());
    gh.singleton<_i6.PreferencesService>(() => _i6.PreferencesService.init());
    gh.singleton<_i7.Database>(() => _i7.Database(gh<_i3.SharedPreferences>()));
    gh.factory<_i8.HistoryBloc>(() => _i8.HistoryBloc(gh<_i7.Database>()));
    return this;
  }
}

class _$RegisterModule extends _i9.RegisterModule {}
