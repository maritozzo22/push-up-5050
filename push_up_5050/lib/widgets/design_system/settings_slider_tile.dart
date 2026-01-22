import 'package:flutter/material.dart';

/// Settings slider tile with orange gradient track.
/// Used in settings screen for volume and recovery time adjustments.
class SettingsSliderTile extends StatelessWidget {
  final String title;
  final String? valueDisplay;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final IconData? icon;

  const SettingsSliderTile({
    super.key,
    required this.title,
    this.valueDisplay,
    required this.value,
    this.min = 0,
    this.max = 1,
    this.divisions,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: Colors.white.withOpacity(0.50),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (valueDisplay != null)
                Text(
                  valueDisplay!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFFB347),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _CustomSlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _CustomSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _CustomSlider({
    required this.value,
    this.min = 0,
    this.max = 1,
    this.divisions,
    required this.onChanged,
  });

  @override
  State<_CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<_CustomSlider> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(_CustomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final range = widget.max - widget.min;
    final normalizedValue = (_currentValue - widget.min) / range;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final trackWidth = maxWidth;
        final thumbPosition = trackWidth * normalizedValue.clamp(0.0, 1.0);

        return GestureDetector(
          onPanStart: (details) {
            _updateValue(details.localPosition.dx, maxWidth);
          },
          onPanUpdate: (details) {
            _updateValue(details.localPosition.dx, maxWidth);
          },
          onTapDown: (details) {
            _updateValue(details.localPosition.dx, maxWidth);
          },
          child: SizedBox(
            height: 32,
            width: double.infinity,
            child: Stack(
              children: [
                // Background track
                Positioned(
                  top: 11,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                // Filled track with gradient
                Positioned(
                  top: 11,
                  left: 0,
                  width: thumbPosition.clamp(0.0, maxWidth),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                // Thumb
                Positioned(
                  top: 5,
                  left: thumbPosition.clamp(0.0, maxWidth) - 10,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A18).withOpacity(0.40),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateValue(double dx, double maxWidth) {
    final range = widget.max - widget.min;
    final newValue = widget.min + (dx / maxWidth) * range;
    final clampedValue = newValue.clamp(widget.min, widget.max);

    if (widget.divisions != null) {
      final step = range / widget.divisions!;
      final steppedValue = (clampedValue / step).round() * step;
      setState(() => _currentValue = steppedValue.clamp(widget.min, widget.max));
      widget.onChanged(_currentValue);
    } else {
      setState(() => _currentValue = clampedValue);
      widget.onChanged(_currentValue);
    }
  }
}
