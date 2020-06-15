/// A class to handle users experience
///
/// Things Possibly handled by this class:
/// * Anything relating too or affecting how user will experience th eapp itself
/// * Whether user is user dark or light theme
/// * Whether user is to be shown onboarding screen
abstract class MiscRepo {
  /// Returns a [bool] indicating if app is launched for the first time
  bool isFirstAppLaunch();

  /// Sets [isFirstAppLaunch] to return [false] on future calls
  Future<void> setFirstAppLaunchFalse();
}
