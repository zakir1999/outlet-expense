abstract class MostSellingEvent {}

class FetchMostSellingProducts extends MostSellingEvent {}

class SearchMostSellingProducts extends MostSellingEvent {
  final String query;
  SearchMostSellingProducts(this.query);
}

class RefreshMostSellingProducts extends MostSellingEvent {}
