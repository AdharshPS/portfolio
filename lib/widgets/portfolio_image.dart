import 'package:flutter/material.dart';

/// A unified, resilient image widget for all portfolio image slots
/// (avatarImage, thumbnail, ogImage).
///
/// Features:
/// - Strictly local asset-based: no HTTP/HTTPS network calls are made for images.
/// - Resolves remote URLs or image names to corresponding local assets if provided.
/// - Any other string is treated as local [Image.asset].
/// - Empty, missing, or invalid paths fallback to [fallbackAsset], then [fallbackWidget] / neutral box.
/// - Preserves fixed size/fit so layout never shifts.
class PortfolioImage extends StatelessWidget {
  final String imagePath;
  final String fallbackAsset;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final Widget? placeholder;
  final Widget? fallbackWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const PortfolioImage({
    super.key,
    required this.imagePath,
    this.fallbackAsset = '',
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.aspectRatio,
    this.placeholder,
    this.fallbackWidget,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  /// Normalizes/resolves any image path or URL to a safe local asset path,
  /// ensuring no HTTP/HTTPS requests are ever performed for images.
  static String resolveAssetPath(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return '';

    final lower = trimmed.toLowerCase();

    // Map known project / profile images even if provided as remote URLs or filenames
    if (lower.contains('me.png') ||
        lower.contains('me.webp') ||
        lower.contains('avatar')) {
      return 'assets/images/me.png';
    }
    if (lower.contains('noteflow')) {
      return 'assets/images/projects/noteflow.png';
    }
    if (lower.contains('paws')) {
      return 'assets/images/projects/paws.png';
    }
    if (lower.contains('netflix')) {
      return 'assets/images/projects/netflix.png';
    }

    // If it's an HTTP/HTTPS URL that didn't match known assets, do NOT make an HTTP call
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return '';
    }

    return trimmed;
  }

  int? get _resolvedMemCacheWidth {
    if (memCacheWidth != null) return memCacheWidth;
    if (width != null && width!.isFinite && width! > 0) {
      return (width! * 2).clamp(1, 4096).round();
    }
    return null;
  }

  int? get _resolvedMemCacheHeight {
    if (memCacheHeight != null) return memCacheHeight;
    if (height != null && height!.isFinite && height! > 0) {
      return (height! * 2).clamp(1, 4096).round();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedPath = resolveAssetPath(imagePath);
    Widget content;

    if (resolvedPath.isEmpty) {
      content = _buildAssetFallback(context);
    } else {
      content = Image.asset(
        resolvedPath,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: _resolvedMemCacheWidth,
        cacheHeight: _resolvedMemCacheHeight,
        errorBuilder: (context, error, stackTrace) =>
            _buildAssetFallback(context),
      );
    }

    if (aspectRatio != null && aspectRatio! > 0) {
      return AspectRatio(aspectRatio: aspectRatio!, child: content);
    }

    return content;
  }

  Widget _buildAssetFallback(BuildContext context) {
    final resolvedFallback = resolveAssetPath(fallbackAsset);
    if (resolvedFallback.isNotEmpty &&
        resolvedFallback != resolveAssetPath(imagePath)) {
      return Image.asset(
        resolvedFallback,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: _resolvedMemCacheWidth,
        cacheHeight: _resolvedMemCacheHeight,
        errorBuilder: (context, error, stackTrace) {
          return _buildNeutralIconBox(context);
        },
      );
    }
    return _buildNeutralIconBox(context);
  }

  Widget _buildNeutralIconBox(BuildContext context) {
    if (fallbackWidget != null) return fallbackWidget!;
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF1E293B),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF64748B),
          size: 28,
        ),
      ),
    );
  }
}
