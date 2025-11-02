import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final String title;
  final String hintText;
  final bool isRangePicker;
  final bool readOnly;
  final DateTime? initialDate;
  final DateTimeRange? initialRange;
  final Function(DateTime)? onDateSelected;
  final Function(DateTimeRange)? onRangeSelected;
  final String dateFormat;
  final String? locale;
  final String? Function(DateTime?)? validator;
  final String? Function(DateTimeRange?)? rangeValidator;

  const CustomDatePicker({
    Key? key,
    required this.title,
    required this.hintText,
    this.isRangePicker = false,
    this.readOnly = false,
    this.initialDate,
    this.initialRange,
    this.onDateSelected,
    this.onRangeSelected,
    this.dateFormat = 'dd/MM/yyyy',
    this.locale,
    this.validator,
    this.rangeValidator,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;
  String? _errorText;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF004AAD),
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
      locale: widget.locale == null ? null : Locale(widget.locale!),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _errorText = widget.validator?.call(_selectedDate);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange: widget.initialRange ??
          DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF004AAD),
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
      locale: widget.locale == null ? null : Locale(widget.locale!),
    );

    if (picked != null) {
      setState(() {
        _selectedRange = picked;
        _errorText = widget.rangeValidator?.call(_selectedRange);
      });
      widget.onRangeSelected?.call(picked);
    }
  }

  String _getDisplayText() {
    final formatter = DateFormat(widget.dateFormat, widget.locale);
    if (widget.isRangePicker) {
      if (_selectedRange == null) return widget.hintText;
      return "${formatter.format(_selectedRange!.start)} → ${formatter.format(_selectedRange!.end)}";
    } else {
      if (_selectedDate == null) return widget.hintText;
      return formatter.format(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: GestureDetector(
        onTap: widget.readOnly
            ? null
            : widget.isRangePicker
            ? _pickRange
            : _pickDate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              enabled: false,
              readOnly: true,
              decoration: InputDecoration(
                labelText: widget.title,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C2A5E),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade500,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xFF004AAD),
                    width: 1.5,
                  ),
                ),
              ),
              controller: TextEditingController(
                text: _getDisplayText(),
              ),
              style: TextStyle(
                fontSize: 15.sp,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            if (_errorText != null) ...[
              SizedBox(height: 5.h),
              Text(
                _errorText!,
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
