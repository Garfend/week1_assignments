import '../../data/repository/daily_reports_repository.dart';

class DailyReportsUsecase {
  final DailyReportsRepository reportsRepository;

  DailyReportsUsecase(this.reportsRepository);

  double totalSales() => reportsRepository.totalSales();

  int totalItemsSold() => reportsRepository.totalItemsSold();
}