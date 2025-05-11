import 'package:flutter/material.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

import '/core/models/editor_configs/text_editor_configs.dart';
import '/core/models/layers/text_layer.dart';
import '/plugins/rounded_background_text/src/rounded_background_text.dart';

/// A widget representing a text layer in the sticker editor.
class LayerWidgetTextItem extends StatelessWidget {
  /// Creates a [LayerWidgetTextItem] with the given text layer and editor
  /// configurations.
  const LayerWidgetTextItem({
    super.key,
    required this.layer,
    required this.textEditorConfigs,
    required this.showMoveCursor,
    required this.onHitChanged,
    required this.onEdit,
    required this.onRemove,
  });

  /// The text layer represented by this widget.
  final TextLayer layer;

  /// Configuration settings for the text editor.
  final TextEditorConfigs textEditorConfigs;

  /// Notifies whether the move cursor should be shown.
  final ValueNotifier<bool> showMoveCursor;

  /// Callback function that is triggered when a hit status changes.
  ///
  /// The [onHitChanged] function takes a boolean parameter [hasHit] which
  /// indicates whether a hit has occurred (true) or not (false).
  final Function(bool hasHit) onHitChanged;
  final Function onEdit;
  final Function onRemove;

  @override
  Widget build(BuildContext context) {
    var fontSize = textEditorConfigs.initFontSize * layer.scale;
    var style = TextStyle(
      fontSize: fontSize * layer.fontScale,
      color: layer.color,
      overflow: TextOverflow.ellipsis,
    );

    return ValueListenableBuilder(
        valueListenable: showEditors,
        builder: (context, value, child) {
          return HeroMode(
            enabled: false,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                // onTap: (){onEdit();},
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      //  borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: RoundedBackgroundText(
                      onHitTestResult: (hasHit) {
                        // Update hit detection and cursor visibility state.
                        if (layer.hit != hasHit ||
                            showMoveCursor.value != hasHit) {
                          layer.hit = hasHit;
                          showMoveCursor.value = hasHit;
                        }
                        layer.hit = hasHit;
                        onHitChanged(hasHit);
                      },
                      layer.text.toString(),
                      backgroundColor: layer.background,
                      textAlign: layer.align,
                      style: layer.textStyle?.copyWith(
                            fontSize: style.fontSize,
                            fontWeight: style.fontWeight,
                            color: style.color,
                            fontFamily: style.fontFamily,
                          ) ??
                          style,
                    ),
                  ),
                ),
                // Edit icon at top-left corner
                if (value)
                  Positioned(
                    top: -10,
                    left: -10,
                    child: InkWell(
                      onTap: (){
                        onEdit();
                      },
                      child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: const Icon(Icons.edit, color: Colors.green)),
                    ),
                  ),
                // Delete icon at top-right corner
                if (value)
                  Positioned(
                    top: -10,
                    right: -10,
                    child: InkWell(
                      child: const Icon(Icons.delete, color: Colors.red),
                      onTap: () => onRemove(),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
