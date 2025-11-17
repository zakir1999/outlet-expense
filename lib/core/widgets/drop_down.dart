
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final String? hint;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onTap;
  final String? errorText;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;

  /// 🔥 external scroll controller for pagination
  final ScrollController? scrollController;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.onTap,
    this.hint,
    this.errorText,
    this.borderRadius = 12.0,
    this.borderColor = Colors.grey,
    this.padding,
    this.scrollController,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late List<String> filteredOptions;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredOptions = List.from(widget.options);
  }

  /// 🔥 IMPORTANT FIX: update UI when new data comes
  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options != widget.options) {
      setState(() {
        filteredOptions = List.from(widget.options);
      });
    }
  }

  void _openDropdownAdaptive() {
    if (widget.onTap != null) widget.onTap!();

    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      _openBottomSheet();
    } else {
      _openCenterDialog();
    }
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _DropdownContent(
          label: widget.label,
          options: filteredOptions,
          onChanged: widget.onChanged,
          scrollController: widget.scrollController,
        );
      },
    );
  }

  void _openCenterDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return Dialog(
          elevation: 8,
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
                padding: const EdgeInsets.all(16),
                child: _DropdownListView(
                  label: widget.label,
                  options: filteredOptions,
                  onChanged: (val) {
                    widget.onChanged?.call(val);
                    Navigator.pop(context);
                  },
                  scrollController: widget.scrollController,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 360 ? 14.0 : 16.0;

    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _openDropdownAdaptive,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: widget.errorText != null
                      ? Colors.red
                      : widget.borderColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedValue ??
                          widget.hint ??
                          "Select ${widget.label}",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: widget.selectedValue == null
                            ? Colors.grey[600]
                            : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54),
                ],
              ),
            ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                widget.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _DropdownContent extends StatelessWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String?>? onChanged;
  final ScrollController? scrollController;

  const _DropdownContent({
    required this.label,
    required this.options,
    this.onChanged,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _DropdownListView(
          label: label,
          options: options,
          onChanged: (val) {
            onChanged?.call(val);
            Navigator.pop(context);
          },
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _DropdownListView extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String?>? onChanged;
  final ScrollController? scrollController;

  const _DropdownListView({
    required this.label,
    required this.options,
    this.onChanged,
    this.scrollController,
  });

  @override
  State<_DropdownListView> createState() => _DropdownListViewState();
}

class _DropdownListViewState extends State<_DropdownListView> {
  final TextEditingController _searchCtrl = TextEditingController();

  late ScrollController scrollController;
  late List<String> filtered;

  @override
  void initState() {
    super.initState();
    scrollController =
        widget.scrollController ?? ScrollController();

    filtered = List.from(widget.options);
  }

  /// 🔥 CRITICAL FIX — new data now updates UI
  @override
  void didUpdateWidget(covariant _DropdownListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options != widget.options) {
      setState(() {
        filtered = List.from(widget.options);
      });
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      scrollController.dispose();
    }
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select ${widget.label}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          onChanged: (query) {
            setState(() {
              filtered = widget.options
                  .where((opt) =>
                  opt.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          },
        ),

        const SizedBox(height: 12),

        Expanded(
          child: filtered.isEmpty
              ? const Center(
            child: Text(
              'No results found',
              style: TextStyle(color: Colors.grey),
            ),
          )
              : ListView.separated(
            controller: scrollController,
            itemCount: filtered.length,
            separatorBuilder: (_, __) =>
                Divider(color: Colors.grey[300]),
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(
                  filtered[i],
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () => widget.onChanged?.call(filtered[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}


