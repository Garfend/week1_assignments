import 'package:flutter/material.dart';
abstract class Navigation {
  String get destination;

  void navigate(BuildContext context);
}

class PushNavigation implements Navigation {
  final Object builder;
  @override
  final String destination;

  PushNavigation({required this.builder, required this.destination});

  @override
  void navigate(BuildContext context) {
    print('Push to $destination');
    //push logic
  }
}

class ReplaceNavigation implements Navigation {
  final Object builder;
  @override
  final String destination;

  ReplaceNavigation({required this.builder, required this.destination});

  @override
  void navigate(BuildContext context) {
    print('Replace with $destination');
    //Replacement Logic
  }
}

class HomeScreen{
  HomeScreen();
}

class SettingsScreen{
  SettingsScreen();
}

class NavigationButton extends StatelessWidget {
  final Navigation navigation;
  final String buttonText;

  const NavigationButton({
    Key? key,
    required this.navigation,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => navigation.navigate(context),
      child: Text(buttonText),
    );
  }
}

class HomeNavigationButton extends StatelessWidget {
  const HomeNavigationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationButton(
      navigation: ReplaceNavigation(
        builder: HomeScreen(),
        destination: 'Home Screen',
      ),
      buttonText: 'Go to Home',
    );
  }
}

class SettingsNavigationButton extends StatelessWidget {
  const SettingsNavigationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationButton(
      navigation: PushNavigation(
        builder: HomeScreen(),
        destination: 'Settings Screen',
      ),
      buttonText: 'Go to Settings',
    );
  }
}
