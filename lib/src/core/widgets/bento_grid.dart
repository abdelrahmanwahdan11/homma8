import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class BentoTileSize {
  const BentoTileSize._(this.crossAxisSpan, this.mainAxisSpan);

  final int crossAxisSpan;
  final int mainAxisSpan;

  static const BentoTileSize oneByOne = BentoTileSize._(1, 1);
  static const BentoTileSize oneByTwo = BentoTileSize._(1, 2);
  static const BentoTileSize twoByOne = BentoTileSize._(2, 1);
  static const BentoTileSize twoByTwo = BentoTileSize._(2, 2);
}

class BentoGridDelegate extends SliverGridDelegate {
  BentoGridDelegate({
    required this.pattern,
    required this.crossAxisCount,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.tileAspectRatio = 1.0,
  }) : assert(pattern.isNotEmpty);

  final List<BentoTileSize> pattern;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double tileAspectRatio;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1)) / crossAxisCount;
    final double tileHeight = tileWidth / tileAspectRatio;
    return _BentoGridLayout(
      pattern: pattern,
      crossAxisCount: crossAxisCount,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
    );
  }

  @override
  bool shouldRelayout(covariant BentoGridDelegate oldDelegate) {
    return oldDelegate.pattern != pattern ||
        oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.tileAspectRatio != tileAspectRatio;
  }
}

class _BentoGridLayout extends SliverGridLayout {
  _BentoGridLayout({
    required this.pattern,
    required this.crossAxisCount,
    required this.tileWidth,
    required this.tileHeight,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  final List<BentoTileSize> pattern;
  final int crossAxisCount;
  final double tileWidth;
  final double tileHeight;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  final List<SliverGridGeometry> _geometries = <SliverGridGeometry>[];
  bool _built = false;
  double _maxScrollOffset = 0;

  void _ensureGeometries(int childCount) {
    if (_built && _geometries.length >= childCount) {
      return;
    }
    _geometries.clear();
    _maxScrollOffset = 0;
    final List<List<bool>> occupancy = <List<bool>>[];
    int patternIndex = 0;
    int placedCount = 0;
    while (placedCount < childCount) {
      final BentoTileSize tile = pattern[patternIndex % pattern.length];
      patternIndex += 1;
      bool placed = false;
      int row = 0;
      while (!placed) {
        while (row >= occupancy.length) {
          occupancy.add(List<bool>.filled(crossAxisCount, false));
        }
        for (int col = 0; col <= crossAxisCount - tile.crossAxisSpan; col++) {
          if (_canPlace(occupancy, row, col, tile)) {
            _occupy(occupancy, row, col, tile);
            final double crossExtent = tileWidth * tile.crossAxisSpan + crossAxisSpacing * (tile.crossAxisSpan - 1);
            final double mainExtent = tileHeight * tile.mainAxisSpan + mainAxisSpacing * (tile.mainAxisSpan - 1);
            final double crossOffset = col * (tileWidth + crossAxisSpacing);
            final double mainOffset = row * (tileHeight + mainAxisSpacing);
            _geometries.add(
              SliverGridGeometry(
                scrollOffset: mainOffset,
                crossAxisOffset: crossOffset,
                mainAxisExtent: mainExtent,
                crossAxisExtent: crossExtent,
              ),
            );
            _maxScrollOffset = math.max(_maxScrollOffset, mainOffset + mainExtent + mainAxisSpacing);
            placed = true;
            break;
          }
        }
        if (!placed) {
          row += 1;
        }
      }
      placedCount += 1;
    }
    _built = true;
  }

  bool _canPlace(List<List<bool>> grid, int row, int col, BentoTileSize tile) {
    final int neededRows = row + tile.mainAxisSpan;
    while (grid.length < neededRows) {
      grid.add(List<bool>.filled(crossAxisCount, false));
    }
    if (col + tile.crossAxisSpan > crossAxisCount) {
      return false;
    }
    for (int r = row; r < row + tile.mainAxisSpan; r++) {
      for (int c = col; c < col + tile.crossAxisSpan; c++) {
        if (grid[r][c]) {
          return false;
        }
      }
    }
    return true;
  }

  void _occupy(List<List<bool>> grid, int row, int col, BentoTileSize tile) {
    for (int r = row; r < row + tile.mainAxisSpan; r++) {
      for (int c = col; c < col + tile.crossAxisSpan; c++) {
        grid[r][c] = true;
      }
    }
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    assert(index >= 0);
    if (index >= _geometries.length) {
      _ensureGeometries(index + 1);
    }
    return _geometries[index];
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    for (int i = 0; i < _geometries.length; i++) {
      final geometry = _geometries[i];
      if (geometry.scrollOffset + geometry.mainAxisExtent > scrollOffset) {
        return i;
      }
    }
    return math.max(0, _geometries.length - 1);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    for (int i = _geometries.length - 1; i >= 0; i--) {
      final geometry = _geometries[i];
      if (geometry.scrollOffset <= scrollOffset) {
        return i;
      }
    }
    return 0;
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    _ensureGeometries(childCount);
    return _maxScrollOffset;
  }
}
