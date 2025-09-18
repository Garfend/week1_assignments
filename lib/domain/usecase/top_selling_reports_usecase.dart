import '../../data/repository/top_selling_reports_repository.dart';

class TopSellingReportsUsecase {
  final TopSellingReportsRepository reportsRepository;

  TopSellingReportsUsecase(this.reportsRepository);

  Map<String, int> topSellingItems() => reportsRepository.topSellingItems();
}