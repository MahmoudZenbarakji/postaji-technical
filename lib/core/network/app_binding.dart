import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../data/repositories/post_repository.dart';
import '../../data/services/post_service.dart';
import '../controllers/favorites_controller.dart';
import 'dio_client.dart';

final class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
    Get.put<Dio>(DioClient.instance.dio, permanent: true);
    Get.lazyPut<PostService>(
      () => DioPostService(Get.find<Dio>()),
      fenix: true,
    );
    Get.lazyPut<PostRepository>(
      () => PostRepositoryImpl(Get.find<PostService>()),
      fenix: true,
    );
  }
}
