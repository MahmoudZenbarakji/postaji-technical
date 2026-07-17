import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../data/repositories/post_repository.dart';
import '../../data/services/post_service.dart';
import 'dio_client.dart';

final class AppBinding extends Bindings {
  @override
  void dependencies() {
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
