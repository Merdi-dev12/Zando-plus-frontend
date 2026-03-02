/// Exceptions levées UNIQUEMENT dans la couche [data].
/// Elles sont ensuite converties en [Failure] par les repositories.

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, message: $message)';
}

/// Levée quand Dio ne peut pas joindre le serveur (timeout, no internet…)
class NetworkException implements Exception {
  const NetworkException();

  @override
  String toString() => 'NetworkException: pas de connexion internet';
}

/// Levée lors d'une erreur de lecture/écriture cache local (Hive, SharedPrefs…)
class CacheException implements Exception {
  const CacheException();

  @override
  String toString() => 'CacheException: erreur de données locales';
}