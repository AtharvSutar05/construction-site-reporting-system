class PaginationModel {
  final int page;
  final int limit;
  final bool hasNextPage;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.hasNextPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] as int,
      limit: json['limit'] as int,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }
}
