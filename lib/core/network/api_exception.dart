sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class RequestTimeoutException extends ApiException {
  const RequestTimeoutException()
    : super('The request timed out. Please try again.');
}

final class HttpStatusException extends ApiException {
  const HttpStatusException({required this.statusCode, required String message})
    : super(message);

  final int statusCode;
}

final class NetworkException extends ApiException {
  const NetworkException(super.message);
}

final class UnexpectedApiException extends ApiException {
  const UnexpectedApiException()
    : super('An unexpected error occurred while processing the request.');
}
