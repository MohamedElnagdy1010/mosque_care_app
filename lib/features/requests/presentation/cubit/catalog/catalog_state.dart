import '../../../data/models/service_catalog_model.dart';

sealed class CatalogState {
  const CatalogState();
}

class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

class CatalogLoaded extends CatalogState {
  const CatalogLoaded(this.catalog);

  final ServiceCatalogModel catalog;
}

class CatalogError extends CatalogState {
  const CatalogError(this.message);

  final String message;
}
