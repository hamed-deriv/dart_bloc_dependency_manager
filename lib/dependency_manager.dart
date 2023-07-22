/// A base class for state listeners,
/// each state listener should implement this class and define its own method to receive state updates.
abstract class BaseStateListener {}

/// A base class for dependency managers,
/// each dependency manager should extend this class and override the [notify] method to notify its listeners.
abstract class BaseDependencyManager {
  /// A list of listeners that will be notified when [notify] method is called.
  final List<BaseStateListener> _listeners = <BaseStateListener>[];

  /// A getter for accessing the list of listeners.
  List<BaseStateListener> get listeners => _listeners;

  /// Registers a listener to the list of listeners.
  void register(BaseStateListener listener) => _listeners.add(listener);

  /// Unregisters a listener from the list of listeners.
  void unregister(BaseStateListener listener) => _listeners.remove(listener);

  /// Notifies all listeners in the list of listeners.
  void notify(Object? state);

  /// Disposes [BaseDependencyManager] by clearing the list of listeners.
  void dispose() => _listeners.clear();
}
