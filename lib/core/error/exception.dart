class ServerException implements Exception {}

class NoUserException implements Exception {}

class CacheException implements Exception {}

class FileException implements Exception {}

class AuthenticationException implements Exception {
  AuthenticationException(this.authError);
  final String authError;
}
