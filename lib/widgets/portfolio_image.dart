import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A unified, resilient image widget for all portfolio image slots
/// (avatarImage, thumbnail, ogImage).
///
/// Features:
/// - http(s) URL -> [CachedNetworkImage] with cacheKey = imageUrl
/// - Any other string -> local [Image.asset]
/// - Empty, broken or slow URLs fallback to [fallbackAsset], then [fallbackWidget] / neutral box
/// - Preserves fixed size/fit so layout never shifts
/// - Configures [memCacheWidth] & [memCacheHeight] based on display size
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

  bool get _isNetworkUrl {
    final lower = imagePath.trim().toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
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
    Widget content;
    final trimmedPath = imagePath.trim();

    if (trimmedPath.isEmpty) {
      content = _buildAssetFallback(context);
    } else if (_isNetworkUrl) {
      content = CachedNetworkImage(
        imageUrl: trimmedPath,
        cacheKey: trimmedPath,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: _resolvedMemCacheWidth,
        memCacheHeight: _resolvedMemCacheHeight,
        placeholder: (context, url) =>
            placeholder ?? _buildNeutralPlaceholder(context),
        errorWidget: (context, url, error) => _buildAssetFallback(context),
      );
    } else {
      content = Image.asset(
        trimmedPath,
        width: width,
        height: height,
        fit: fit,
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
    final trimmedFallback = fallbackAsset.trim();
    if (trimmedFallback.isNotEmpty && trimmedFallback != imagePath.trim()) {
      return Image.asset(
        trimmedFallback,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildNeutralIconBox(context);
        },
      );
    }
    return _buildNeutralIconBox(context);
  }

  Widget _buildNeutralPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF1E293B),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
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
