import 'package:get_it/get_it.dart';
import '../../presentations/Home/controller/controller.dart';
import '../../presentations/Home/service/product_repo.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepository());
  getIt.registerLazySingleton<ProductController>(() => ProductController());
}