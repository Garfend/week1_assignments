

abstract class LifecycleController {
  void initState();
  void dispose();
}

abstract class AnimationHandler {
  void handleAnimation();
}

abstract class NetworkHandler {
  void handleNetwork();
}

class SimpleButtonController implements LifecycleController {
  @override
  void initState() => print('Init simple button');

  @override
  void dispose() => print('Dispose simple button');
}

class ComplexListController
    implements LifecycleController, AnimationHandler, NetworkHandler {
  @override
  void initState() {
    print('Init complex list');
    handleNetwork();
  }

  @override
  void handleNetwork() => print('Fetching data for the list...');

  @override
  void handleAnimation() => print('Performing list animations...');

  @override
  void dispose() => print('Dispose complex list');
}

class AnimatedIconController implements LifecycleController, AnimationHandler {
  @override
  void initState() => print('Init animated icon');

  @override
  void handleAnimation() => print('Running icon animation...');

  @override
  void dispose() => print('Dispose animated icon');
}