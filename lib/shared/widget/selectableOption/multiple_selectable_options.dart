import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/shared/widget/selectableOption/unique_selectable_option.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MultipleSelectableOptions extends StatelessWidget {
  final List<SelectableOptions> options;
  final List<String> selectedItems;
  final Function(SelectableOptions) onChanged;

  const MultipleSelectableOptions({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          options.map((option) {
            final isSelected = selectedItems.contains(option.title);
            return GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(bottom: StylesConstants.spacerContent),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1)
                          : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    StylesConstants.borderRadius,
                  ),
                  border: Border.all(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                    width: 0.7,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      option.icon,
                      size: 32,
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            option.subtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        HugeIcons.strokeRoundedCheckmarkCircle01,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
