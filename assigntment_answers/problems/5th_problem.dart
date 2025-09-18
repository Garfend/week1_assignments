abstract class LocalNotificationService {
  void send(String message);
}

class AppNotifier {
  final LocalNotificationService service;

  AppNotifier(this.service);

  void notifyUser(String message) {
    service.send(message);
  }
}
