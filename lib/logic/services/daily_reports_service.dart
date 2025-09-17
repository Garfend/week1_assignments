import '../../data/repository/daily_reports_repository.dart';

class DailyReportsService {
  final DailyReportsRepository reportsRepository;

  DailyReportsService(this.reportsRepository);

  double totalSales() => reportsRepository.totalSales();

  int totalItemsSold() => reportsRepository.totalItemsSold();
}