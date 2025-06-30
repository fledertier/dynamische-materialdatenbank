import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector3;

class FocusableInteractiveViewer extends StatefulWidget {
  final FocusableTransformationController controller;
  final Widget child;
  final Duration defaultDuration;
  final Curve defaultCurve;

  final GlobalKey? initialFocusKey;
  final List<GlobalKey>? initialFocusKeys;
  final Duration? initialDuration;
  final Curve? initialCurve;

  final double minScale;
  final double maxScale;
  final double scaleFactor;
  final bool scaleEnabled;
  final bool panEnabled;
  final double viewPaddingExponent;

  const FocusableInteractiveViewer({
    super.key,
    required this.controller,
    required this.child,
    this.defaultDuration = const Duration(milliseconds: 500),
    this.defaultCurve = Curves.easeInOut,
    this.initialFocusKey,
    this.initialFocusKeys,
    this.initialDuration,
    this.initialCurve,
    this.minScale = 1.0,
    this.maxScale = 100.0,
    this.scaleFactor = 100.0,
    this.scaleEnabled = true,
    this.panEnabled = true,
    this.viewPaddingExponent = 20.0,
  });

  @override
  State<FocusableInteractiveViewer> createState() =>
      _FocusableInteractiveViewerState();
}

class _FocusableInteractiveViewerState extends State<FocusableInteractiveViewer>
    with SingleTickerProviderStateMixin {
  final GlobalKey _viewerKey = GlobalKey();
  late final AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();

    widget.controller._attachCallbacks(
      requestFocus: _focusOn,
      requestFocusMultiple: _focusOnMultiple,
      reset: _reset,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: widget.defaultDuration,
    );

    _animationController.addListener(() {
      if (_animation != null) {
        widget.controller.value = _animation!.value;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialFocus();
    });
  }

  void _handleInitialFocus() {
    if (widget.initialFocusKey != null) {
      _focusOn(
        widget.initialFocusKey!,
        duration: widget.initialDuration,
        curve: widget.initialCurve,
      );
    } else if (widget.initialFocusKeys != null &&
        widget.initialFocusKeys!.isNotEmpty) {
      _focusOnMultiple(
        widget.initialFocusKeys!,
        duration: widget.initialDuration,
        curve: widget.initialCurve,
      );
    }
  }

  void _animateTo(Matrix4 targetMatrix, {Duration? duration, Curve? curve}) {
    final d = duration ?? widget.defaultDuration;
    final c = curve ?? widget.defaultCurve;

    _animation = Matrix4Tween(
      begin: widget.controller.value,
      end: targetMatrix,
    ).animate(CurvedAnimation(parent: _animationController, curve: c));

    _animationController.duration = d;
    _animationController.forward(from: 0.0);
  }

  void _focusOn(GlobalKey targetKey, {Duration? duration, Curve? curve}) {
    final RenderBox? targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? viewerBox =
        _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (targetBox == null || viewerBox == null) return;

    final Size targetSize = targetBox.size;
    final Offset targetGlobal = targetBox.localToGlobal(Offset.zero);
    final Size viewerSize = viewerBox.size;
    final Offset viewerGlobal = viewerBox.localToGlobal(Offset.zero);

    final Offset targetRelativeToViewer = targetGlobal - viewerGlobal;

    final Matrix4 currentMatrix = widget.controller.value.clone();
    final Matrix4 inverseMatrix = Matrix4.inverted(currentMatrix);

    final Vector3 transformed = inverseMatrix.transform3(
      Vector3(targetRelativeToViewer.dx, targetRelativeToViewer.dy, 0),
    );

    final double scale =
        targetSize.aspectRatio < viewerSize.aspectRatio
            ? viewerSize.height / targetSize.height
            : viewerSize.width / targetSize.width;

    final double desiredScale = _smoothClamp(scale, widget.viewPaddingExponent);

    final Matrix4 targetMatrix =
        Matrix4.identity()
          ..translate(
            viewerSize.width / 2 -
                (transformed.x + targetSize.width / 2) * desiredScale,
            viewerSize.height / 2 -
                (transformed.y + targetSize.height / 2) * desiredScale,
          )
          ..scale(desiredScale);

    _animateTo(targetMatrix, duration: duration, curve: curve);
  }

  void _focusOnMultiple(
    List<GlobalKey> keys, {
    Duration? duration,
    Curve? curve,
  }) {
    final RenderBox? viewerBox =
        _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewerBox == null) return;

    final List<RenderBox> boxes =
        keys
            .map((k) => k.currentContext?.findRenderObject() as RenderBox?)
            .where((b) => b != null)
            .cast<RenderBox>()
            .toList();

    if (boxes.isEmpty) return;

    Rect? unionRect;
    for (final box in boxes) {
      final Offset global = box.localToGlobal(Offset.zero);
      final Offset viewerGlobal = viewerBox.localToGlobal(Offset.zero);
      final Offset relative = global - viewerGlobal;
      final Rect rect = relative & box.size;

      unionRect = unionRect == null ? rect : unionRect.expandToInclude(rect);
    }

    if (unionRect == null) return;

    final Size viewerSize = viewerBox.size;

    // final double desiredScale = 0.5 * (viewerSize.height / unionRect.height);

    final double scale =
        (unionRect.height / unionRect.width) < viewerSize.aspectRatio
            ? viewerSize.height / unionRect.height
            : viewerSize.width / unionRect.width;

    final double desiredScale = _smoothClamp(scale, widget.viewPaddingExponent);

    final Matrix4 targetMatrix =
        Matrix4.identity()
          ..translate(
            viewerSize.width / 2 -
                (unionRect.left + unionRect.width / 2) * desiredScale,
            viewerSize.height / 2 -
                (unionRect.top + unionRect.height / 2) * desiredScale,
          )
          ..scale(desiredScale);

    _animateTo(targetMatrix, duration: duration, curve: curve);
  }

  double _smoothClamp(num value, num max) {
    return max * (1 - exp(-value / max));
  }

  void _reset({Duration? duration, Curve? curve}) {
    _animateTo(Matrix4.identity(), duration: duration, curve: curve);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _viewerKey,
      child: InteractiveViewer(
        transformationController: widget.controller,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        scaleFactor: widget.scaleFactor,
        scaleEnabled: widget.scaleEnabled,
        panEnabled: widget.panEnabled,
        child: widget.child,
      ),
    );
  }
}

class FocusableTransformationController extends TransformationController {
  late void Function(GlobalKey, {Duration? duration, Curve? curve})
  _requestFocus;
  late void Function(List<GlobalKey>, {Duration? duration, Curve? curve})
  _requestFocusMultiple;
  late void Function({Duration? duration, Curve? curve}) _reset;

  void _attachCallbacks({
    required void Function(GlobalKey, {Duration? duration, Curve? curve})
    requestFocus,
    required void Function(List<GlobalKey>, {Duration? duration, Curve? curve})
    requestFocusMultiple,
    required void Function({Duration? duration, Curve? curve}) reset,
  }) {
    _requestFocus = requestFocus;
    _requestFocusMultiple = requestFocusMultiple;
    _reset = reset;
  }

  void focusOn(GlobalKey key, {Duration? duration, Curve? curve}) {
    _requestFocus(key, duration: duration, curve: curve);
  }

  void focusOnMultiple(
    List<GlobalKey> keys, {
    Duration? duration,
    Curve? curve,
  }) {
    _requestFocusMultiple(keys, duration: duration, curve: curve);
  }

  void reset({Duration? duration, Curve? curve}) {
    _reset(duration: duration, curve: curve);
  }
}
