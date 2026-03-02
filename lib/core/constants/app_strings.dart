class AppStrings {
  AppStrings._();

  static const String appName    = 'Zando Plus';
  static const String appTagline = 'Votre boutique en ligne';

  static const String baseUrl              = 'https://zando-plus-backend-production.up.railway.app/api';
  static const String productsEndpoint     = '/products';
  static const String categoriesEndpoint   = '/categories';

  static const List<String> carouselImages = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1472851294608-062f824d29cc?auto=format&fit=crop&w=800&q=80',
  ];

  static const String searchHint      = 'Rechercher';
  static const String categories      = 'Catégorie';
  static const String popularProducts = 'Produits populaires';
  static const String seeAll          = 'voir tout';

  static const String navHome    = 'Accueil';
  static const String navCart    = 'Panier';
  static const String navExplore = 'Exeple';
  static const String navAccount = 'Compte';

  static const String retry         = 'Réessayer';
  static const String errorServer   = 'Erreur serveur, veuillez réessayer.';
  static const String errorNetwork  = 'Pas de connexion internet.';
  static const String emptyCart     = 'Votre panier est vide';
  static const String loginPrompt   = 'Connectez-vous pour accéder à votre compte';
}