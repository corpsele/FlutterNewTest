
import 'package:get_it/get_it.dart';

typedef LazyFactory<T> = T Function();

/// GetIt 全局单例，替代InheritedWidget/context查依赖
abstract class ServiceLocator {
  static final GetIt _instance = GetIt.instance;

  /// 注册单例 （常驻全局）
  static void registerSingletor<T extends Object>(T instance) => _instance.registerSingleton(instance);

  /// 注册工厂（每次new）
  static void registerFactory<T extends Object>(FactoryFunc<T> factoryFunc) => _instance.registerFactory(factoryFunc);

  /// 注册懒加载单例
  static void registerLazySingletor<T extends Object>(LazyFactory<T> func, {
    String? instanceName,
  }) => _instance.registerLazySingleton(func, instanceName: instanceName);

  /// 获取
  static T get<T extends Object>() => _instance.get<T>();

  /// 注册命名
  static void registerFactorNamed<T extends Object>(
    String name,
    FactoryFunc<T> factory,
  ) => _instance.registerFactory<T>(factory, instanceName: name);

  /// 通过名称获取单例
  static T getNamed<T extends Object>(String name) => _instance.get<T>(instanceName: name);

  /// 释放某个示例
  static void unregister<T extends Object>() => _instance.unregister<T>();
}
