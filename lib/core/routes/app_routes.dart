abstract final class AppRoutes {
  static const String posts = '/posts';
  static const String postDetails = '/posts/:id';

  static String postDetailsPath(int id) => '/posts/$id';
}
