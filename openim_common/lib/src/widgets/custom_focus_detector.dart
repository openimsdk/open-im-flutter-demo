import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fires callbacks every time the widget appears or disappears from the screen.
/// Adapter to flutter 3.0
class FocusDetector extends StatefulWidget {
  const FocusDetector({
    required this.child,
    this.onFocusGained,
    this.onFocusLost,
    this.onVisibilityGained,
    this.onVisibilityLost,
    this.onForegroundGained,
    this.onForegroundLost,
    Key? key,
  }) : super(key: key);

  /// Called when the widget becomes visible or enters foreground while visible.
  final VoidCallback? onFocusGained;

  /// Called when the widget becomes invisible or enters background while visible.
  final VoidCallback? onFocusLost;

  /// Called when the widget becomes visible.
  final VoidCallback? onVisibilityGained;

  /// Called when the widget becomes invisible.
  final VoidCallback? onVisibilityLost;

  /// Called when the app entered the foreground while the widget is visible.
  final VoidCallback? onForegroundGained;

  /// Called when the app is sent to background while the widget was visible.
  final VoidCallback? onForegroundLost;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<FocusDetector> createState() => _FocusDetectorState();
}

class _FocusDetectorState extends State<FocusDetector>
    with WidgetsBindingObserver {
  final _visibilityDetectorKey = UniqueKey();

  /// Whether this widget is currently visible within the app.
  bool _isWidgetVisible = false;

  /// Whether the app is in the foreground.
  bool _isAppInForeground = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _notifyPlaneTransition(state);
  }

  /// Notifies app's transitions to/from the foreground.
  void _notifyPlaneTransition(AppLifecycleState state) {
    if (!_isWidgetVisible) {
      return;
    }

    final isAppResumed = state == AppLifecycleState.resumed;
    final wasResumed = _isAppInForeground;
    if (isAppResumed && !wasResumed) {
      _isAppInForeground = true;
      _notifyFocusGain();
      _notifyForegroundGain();
      return;
    }

    final isAppPaused = state == AppLifecycleState.paused;
    if (isAppPaused && wasResumed) {
      _isAppInForeground = false;
      _notifyFocusLoss();
      _notifyForegroundLoss();
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: _visibilityDetectorKey,
        onVisibilityChanged: (visibilityInfo) {
          try {
            // 当widget高度超过一屏时visibilityInfo.visibleFraction的值达不到1
            final visibleBoundsBottom = visibilityInfo.visibleBounds.bottom;
            final height = visibilityInfo.size.height;
            final fraction = visibleBoundsBottom / height;
            _notifyVisibilityStatusChange(fraction);
          } catch (_) {
            final visibleFraction = visibilityInfo.visibleFraction;
            _notifyVisibilityStatusChange(visibleFraction);
          }
        },
        child: widget.child,
      );

  /// Notifies changes in the widget's visibility.
  void _notifyVisibilityStatusChange(double newVisibleFraction) {
    if (!_isAppInForeground) {
      return;
    }

    final wasFullyVisible = _isWidgetVisible;
    final isFullyVisible = newVisibleFraction == 1;
    if (!wasFullyVisible && isFullyVisible) {
      _isWidgetVisible = true;
      _notifyFocusGain();
      _notifyVisibilityGain();
    }

    final isFullyInvisible = newVisibleFraction == 0;
    if (wasFullyVisible && isFullyInvisible) {
      _isWidgetVisible = false;
      _notifyFocusLoss();
      _notifyVisibilityLoss();
    }
  }

  void _notifyFocusGain() {
    final onFocusGained = widget.onFocusGained;
    if (onFocusGained != null) {
      onFocusGained();
    }
  }

  void _notifyFocusLoss() {
    final onFocusLost = widget.onFocusLost;
    if (onFocusLost != null) {
      onFocusLost();
    }
  }

  void _notifyVisibilityGain() {
    final onVisibilityGained = widget.onVisibilityGained;
    if (onVisibilityGained != null) {
      onVisibilityGained();
    }
  }

  void _notifyVisibilityLoss() {
    final onVisibilityLost = widget.onVisibilityLost;
    if (onVisibilityLost != null) {
      onVisibilityLost();
    }
  }

  void _notifyForegroundGain() {
    final onForegroundGained = widget.onForegroundGained;
    if (onForegroundGained != null) {
      onForegroundGained();
    }
  }

  void _notifyForegroundLoss() {
    final onForegroundLost = widget.onForegroundLost;
    if (onForegroundLost != null) {
      onForegroundLost();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
