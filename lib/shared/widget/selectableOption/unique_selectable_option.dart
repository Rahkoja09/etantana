import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SelectableOptions {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  SelectableOptions({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class UniqueSelectableOption extends StatefulWidget {
  final List<SelectableOptions> options;
  final ValueChanged<SelectableOptions> onChanged;
  final String? initialValue;

  const UniqueSelectableOption({
    super.key,
    required this.options,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<UniqueSelectableOption> createState() => _UniqueSelectableOptionState();
}

class _UniqueSelectableOptionState extends State<UniqueSelectableOption> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          widget.options.map((option) {
            final isSelected = selectedValue == option.title;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedValue = option.title;
                });
                widget.onChanged(option);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(bottom: StylesConstants.spacerContent),
                padding: EdgeInsets.all(6),
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
