import '../../data/repository/top_selling_reports_repository.dart';

class TopSellingReportsService {
  final TopSellingReportsRepository reportsRepository;

  TopSellingReportsService(this.reportsRepository);

  Map<String, int> topSellingItems() => reportsRepository.topSellingItems();
}