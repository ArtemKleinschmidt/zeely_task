import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A scrollable grid that smoothly animates additions, removals and
/// reorderings of its items.
///
/// Items are matched across rebuilds by [keyOf]. Surviving items slide
/// from their previous slot to their new one, removed items fade and
/// scale out in place, and freshly added items fade and scale in. The
/// grid itself shrinks or grows via [AnimatedSize] so the surrounding
/// layout follows the row count.
final class AmazingAnimatedGrid<T> extends StatefulWidget {
  const AmazingAnimatedGrid({
    required this.items,
    required this.keyOf,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.childAspectRatio = 1,
    this.padding = EdgeInsets.zero,
    this.moveDuration = const Duration(milliseconds: 260),
    this.fadeDuration = const Duration(milliseconds: 180),
    this.moveCurve = Curves.easeInOutCubic,
    this.enterCurve = Curves.easeOutCubic,
    this.exitCurve = Curves.easeInCubic,
    this.appearScale = 0.94,
    this.emptyState,
    super.key,
  }) : assert(crossAxisCount > 0),
       assert(childAspectRatio > 0);

  /// Current items. The grid diffs against the previous list using
  /// [keyOf] to figure out which tiles are added, removed or moved.
  final List<T> items;

  /// Stable identity for an item across rebuilds. Items sharing a key
  /// are treated as the same logical tile.
  final Object Function(T item) keyOf;

  /// Builds the visual content of a single tile.
  final Widget Function(BuildContext context, T item) itemBuilder;

  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  /// Width / height ratio of each tile. Combined with the column width
  /// derived from layout constraints to compute tile height.
  final double childAspectRatio;

  /// Padding around the scrollable grid. The horizontal component is
  /// also subtracted from the available width when sizing tiles.
  final EdgeInsetsGeometry padding;

  /// Duration of slot-to-slot move transitions.
  final Duration moveDuration;

  /// Duration of enter/exit fade and scale transitions.
  final Duration fadeDuration;

  final Curve moveCurve;
  final Curve enterCurve;
  final Curve exitCurve;

  /// Scale applied while a tile is entering or exiting.
  final double appearScale;

  /// Optional widget shown — cross-faded over the grid — when [items]
  /// is empty and no exit animations are still in flight.
  final Widget? emptyState;

  @override
  State<AmazingAnimatedGrid<T>> createState() => _AmazingAnimatedGridState<T>();
}

final class _AmazingAnimatedGridState<T> extends State<AmazingAnimatedGrid<T>> {
  // All tiles currently mounted, including ones that are fading out.
  final List<_GridTile<T>> _tiles = [];

  // Guards the delayed cleanup so a fresh sync supersedes a stale one.
  var _cleanupToken = 0;

  @override
  void initState() {
    super.initState();
    for (final entry in widget.items.indexed) {
      _tiles.add(
        _GridTile<T>(
          key: widget.keyOf(entry.$2),
          item: entry.$2,
          slotIndex: entry.$1,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant AmazingAnimatedGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTiles();
  }

  @override
  Widget build(BuildContext context) {
    final config = _AnimationConfig(
      moveDuration: widget.moveDuration,
      fadeDuration: widget.fadeDuration,
      moveCurve: widget.moveCurve,
      enterCurve: widget.enterCurve,
      exitCurve: widget.exitCurve,
      appearScale: widget.appearScale,
    );

    final emptyState = widget.emptyState;
    final showEmptyState =
        emptyState != null && widget.items.isEmpty && _tiles.isEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final metrics = _GridMetrics.fromWidth(
          maxWidth: maxWidth,
          horizontalPadding: widget.padding.horizontal,
          crossAxisCount: widget.crossAxisCount,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
          childAspectRatio: widget.childAspectRatio,
        );

        return Stack(
          children: [
            SingleChildScrollView(
              padding: widget.padding,
              child: AnimatedSize(
                duration: widget.moveDuration,
                curve: widget.moveCurve,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: metrics.gridWidth,
                  height: _gridHeight(metrics),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (final tile in _tiles)
                        _AnimatedGridCard(
                          key: ValueKey(tile.key),
                          slotIndex: tile.slotIndex,
                          state: tile.state,
                          metrics: metrics,
                          config: config,
                          child: widget.itemBuilder(context, tile.item),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (emptyState != null)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !showEmptyState,
                  child: AnimatedOpacity(
                    opacity: showEmptyState ? 1 : 0,
                    duration: widget.fadeDuration,
                    curve: Curves.easeOut,
                    child: emptyState,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  double _gridHeight(_GridMetrics metrics) {
    if (_tiles.isEmpty) return 0;

    var maxSlot = 0;
    for (final tile in _tiles) {
      if (tile.slotIndex + 1 > maxSlot) maxSlot = tile.slotIndex + 1;
    }
    final rows = (maxSlot / widget.crossAxisCount).ceil();
    return (rows * metrics.itemHeight) + ((rows - 1) * widget.mainAxisSpacing);
  }

  // Diffs [widget.items] against the existing tiles. Survivors get their
  // new slot index (driving the move animation), removed items are
  // flagged as exiting, and brand-new items are appended as entering.
  void _syncTiles() {
    final next = widget.items;
    final nextById = <Object, T>{};
    final nextSlotById = <Object, int>{};
    for (final entry in next.indexed) {
      final key = widget.keyOf(entry.$2);
      nextById[key] = entry.$2;
      nextSlotById[key] = entry.$1;
    }

    var hasExits = false;
    for (var i = 0; i < _tiles.length; i++) {
      final tile = _tiles[i];
      final nextItem = nextById[tile.key];
      if (nextItem == null) {
        if (tile.state != _TileState.exiting) {
          _tiles[i] = tile.copyWith(state: _TileState.exiting);
          hasExits = true;
        }
        continue;
      }
      _tiles[i] = tile.copyWith(
        item: nextItem,
        slotIndex: nextSlotById[tile.key],
        state: tile.state == _TileState.exiting
            ? _TileState.stable
            : tile.state,
      );
    }

    var hasEntries = false;
    final knownKeys = {for (final tile in _tiles) tile.key};
    for (final entry in next.indexed) {
      final key = widget.keyOf(entry.$2);
      if (knownKeys.contains(key)) continue;
      _tiles.add(
        _GridTile<T>(
          key: key,
          item: entry.$2,
          slotIndex: entry.$1,
          state: _TileState.entering,
        ),
      );
      hasEntries = true;
    }

    _sortTiles();

    if (hasEntries) _scheduleEnterAnimation();
    if (hasExits) _scheduleExitCleanup();
  }

  // New tiles are inserted in the entering state so they render initially
  // hidden. After the first frame we transition them to stable so the
  // tween animates them into place.
  void _scheduleEnterAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      var changed = false;
      for (var i = 0; i < _tiles.length; i++) {
        if (_tiles[i].state == _TileState.entering) {
          _tiles[i] = _tiles[i].copyWith(state: _TileState.stable);
          changed = true;
        }
      }
      if (changed) setState(() {});
    });
  }

  // After the fade duration, drop tiles that finished exiting. The token
  // ensures only the most recently scheduled cleanup actually runs, so a
  // burst of updates can't race an older callback into removing a tile
  // that has since been re-added.
  void _scheduleExitCleanup() {
    final token = ++_cleanupToken;
    Future<void>.delayed(widget.fadeDuration, () {
      if (!mounted || token != _cleanupToken) return;
      if (_tiles.every((tile) => tile.state != _TileState.exiting)) return;
      setState(() {
        _tiles.removeWhere((tile) => tile.state == _TileState.exiting);
        _sortTiles();
      });
    });
  }

  // Exiting tiles paint last so they sit above survivors during fade.
  void _sortTiles() {
    _tiles.sort((a, b) {
      final aExiting = a.state == _TileState.exiting;
      final bExiting = b.state == _TileState.exiting;
      if (aExiting == bExiting) return 0;
      return aExiting ? 1 : -1;
    });
  }
}

enum _TileState { stable, entering, exiting }

final class _GridTile<T> {
  const _GridTile({
    required this.key,
    required this.item,
    required this.slotIndex,
    this.state = _TileState.stable,
  });

  final Object key;
  final T item;
  final int slotIndex;
  final _TileState state;

  _GridTile<T> copyWith({
    T? item,
    int? slotIndex,
    _TileState? state,
  }) {
    return _GridTile<T>(
      key: key,
      item: item ?? this.item,
      slotIndex: slotIndex ?? this.slotIndex,
      state: state ?? this.state,
    );
  }
}

final class _GridMetrics {
  const _GridMetrics({
    required this.gridWidth,
    required this.itemWidth,
    required this.itemHeight,
    required this.crossAxisCount,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });

  factory _GridMetrics.fromWidth({
    required double maxWidth,
    required double horizontalPadding,
    required int crossAxisCount,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
    required double childAspectRatio,
  }) {
    final contentWidth = math.max(0.0, maxWidth - horizontalPadding);
    final totalSpacing = math.max(0.0, (crossAxisCount - 1) * crossAxisSpacing);
    final itemWidth = math.max(
      0.0,
      (contentWidth - totalSpacing) / crossAxisCount,
    );
    return _GridMetrics(
      gridWidth: contentWidth,
      itemWidth: itemWidth,
      itemHeight: itemWidth / childAspectRatio,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
    );
  }

  final double gridWidth;
  final double itemWidth;
  final double itemHeight;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  double leftFor(int slotIndex) =>
      (slotIndex % crossAxisCount) * (itemWidth + crossAxisSpacing);

  double topFor(int slotIndex) =>
      (slotIndex ~/ crossAxisCount) * (itemHeight + mainAxisSpacing);
}

final class _AnimationConfig {
  const _AnimationConfig({
    required this.moveDuration,
    required this.fadeDuration,
    required this.moveCurve,
    required this.enterCurve,
    required this.exitCurve,
    required this.appearScale,
  });

  final Duration moveDuration;
  final Duration fadeDuration;
  final Curve moveCurve;
  final Curve enterCurve;
  final Curve exitCurve;
  final double appearScale;
}

final class _AnimatedGridCard extends StatelessWidget {
  const _AnimatedGridCard({
    required this.slotIndex,
    required this.state,
    required this.metrics,
    required this.config,
    required this.child,
    super.key,
  });

  final int slotIndex;
  final _TileState state;
  final _GridMetrics metrics;
  final _AnimationConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isExiting = state == _TileState.exiting;
    final isHidden = state != _TileState.stable;
    final transitionCurve = isExiting ? config.exitCurve : config.enterCurve;

    return AnimatedPositioned(
      duration: config.moveDuration,
      curve: config.moveCurve,
      left: metrics.leftFor(slotIndex),
      top: metrics.topFor(slotIndex),
      width: metrics.itemWidth,
      height: metrics.itemHeight,
      child: IgnorePointer(
        ignoring: isExiting,
        child: AnimatedOpacity(
          duration: config.fadeDuration,
          curve: transitionCurve,
          opacity: isHidden ? 0 : 1,
          child: AnimatedScale(
            duration: config.fadeDuration,
            curve: transitionCurve,
            scale: isHidden ? config.appearScale : 1,
            child: child,
          ),
        ),
      ),
    );
  }
}
