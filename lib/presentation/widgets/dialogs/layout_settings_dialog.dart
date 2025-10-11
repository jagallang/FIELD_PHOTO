import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/layout_config.dart';

/// Dialog for configuring layout settings
class LayoutSettingsDialog extends StatefulWidget {
  final LayoutConfig initialConfig;
  final Function(LayoutConfig) onConfigChanged;

  const LayoutSettingsDialog({
    super.key,
    required this.initialConfig,
    required this.onConfigChanged,
  });

  @override
  State<LayoutSettingsDialog> createState() => _LayoutSettingsDialogState();

  static Future<void> show(
    BuildContext context,
    LayoutConfig initialConfig,
    Function(LayoutConfig) onConfigChanged,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => LayoutSettingsDialog(
        initialConfig: initialConfig,
        onConfigChanged: onConfigChanged,
      ),
    );
  }
}

class _LayoutSettingsDialogState extends State<LayoutSettingsDialog> {
  late LayoutConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('layout_settings'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _GridSizeSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
            const SizedBox(height: 20),
            _SpacingSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
            const SizedBox(height: 20),
            _BorderSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
            const SizedBox(height: 20),
            _PageNumberSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
            const SizedBox(height: 20),
            _TitleSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfigChanged(_config);
            Navigator.pop(context);
          },
          child: Text('apply'.tr()),
        ),
      ],
    );
  }
}

class _GridSizeSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _GridSizeSection({
    required this.config,
    required this.onConfigChanged,
  });

  int _getPhotosPerPage() => config.photosPerPage;

  void _setPhotosPerPage(int count) {
    LayoutType layoutType;
    switch (count) {
      case 1:
        layoutType = LayoutType.layout1;
        break;
      case 2:
        layoutType = LayoutType.layout2;
        break;
      case 3:
        layoutType = LayoutType.layout3;
        break;
      case 4:
        layoutType = LayoutType.layout4;
        break;
      default:
        layoutType = LayoutType.layout1;
    }
    onConfigChanged(config.copyWith(layoutType: layoutType));
  }

  @override
  Widget build(BuildContext context) {
    final currentCount = _getPhotosPerPage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'photos_per_page'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 1; i <= 4; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: OutlinedButton(
                    onPressed: () => _setPhotosPerPage(i),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: currentCount == i ? Colors.blue : Colors.white,
                      foregroundColor: currentCount == i ? Colors.white : Colors.black,
                      side: BorderSide(
                        color: currentCount == i ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      i.toString(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SpacingSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _SpacingSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'spacing'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: config.spacing,
          min: 0,
          max: 20,
          divisions: 20,
          label: config.spacing.round().toString(),
          onChanged: (value) => onConfigChanged(
            config.copyWith(spacing: value),
          ),
        ),
      ],
    );
  }
}

class _BorderSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _BorderSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'border_width'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: config.borderWidth,
          min: 0,
          max: 5,
          divisions: 10,
          label: config.borderWidth.toString(),
          onChanged: (value) => onConfigChanged(
            config.copyWith(borderWidth: value),
          ),
        ),
      ],
    );
  }
}

class _PageNumberSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _PageNumberSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'page_numbers'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Switch(
              value: config.showPageNumbers,
              onChanged: (value) => onConfigChanged(
                config.copyWith(showPageNumbers: value),
              ),
            ),
          ],
        ),
        if (config.showPageNumbers) ...[
          const SizedBox(height: 8),
          _NumberSelector(
            label: 'starting_page'.tr(),
            value: config.startingPageNumber,
            min: 1,
            max: 999,
            onChanged: (value) => onConfigChanged(
              config.copyWith(startingPageNumber: value),
            ),
          ),
        ],
      ],
    );
  }
}

class _NumberSelector extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const _NumberSelector({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove),
              iconSize: 20,
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add),
              iconSize: 20,
            ),
          ],
        ),
      ],
    );
  }
}

class _TitleSection extends StatefulWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _TitleSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<_TitleSection> createState() => _TitleSectionState();
}

class _TitleSectionState extends State<_TitleSection> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.config.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'show_title'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Switch(
              value: widget.config.showTitle,
              onChanged: (value) => widget.onConfigChanged(
                widget.config.copyWith(showTitle: value),
              ),
            ),
          ],
        ),
        if (widget.config.showTitle) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'title'.tr(),
              hintText: 'add_title'.tr(),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => widget.onConfigChanged(
              widget.config.copyWith(title: value),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'title_font_size'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Slider(
            value: widget.config.titleFontSize,
            min: 14,
            max: 36,
            divisions: 22,
            label: widget.config.titleFontSize.round().toString(),
            onChanged: (value) => widget.onConfigChanged(
              widget.config.copyWith(titleFontSize: value),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          'caption_font_size'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: widget.config.captionFontSize,
          min: 10,
          max: 30,
          divisions: 20,
          label: widget.config.captionFontSize.round().toString(),
          onChanged: (value) => widget.onConfigChanged(
            widget.config.copyWith(captionFontSize: value),
          ),
        ),
      ],
    );
  }
}