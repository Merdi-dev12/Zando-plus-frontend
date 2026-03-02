/// Failures remontées de la couche [data] vers [domain] puis [presentation].
/// Le repository attrape les [Exception] et les convertit en [Failure].
/// Ainsi, la présentation ne connaît jamais Dio ni les codes HTTP.

abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Réponse d'erreur du serveur (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erreur serveur, veuillez réessayer.']);
}

/// Absence de connexion réseau
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Pas de connexion internet.']);
}

/// Erreur de cache local
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de données locales.']);
}