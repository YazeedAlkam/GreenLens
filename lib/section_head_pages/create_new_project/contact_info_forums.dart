import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';

/// Returns true when [value] contains between 7 and 15 digit characters
/// (after stripping '+' and spaces), per E.164 constraints.
bool _isValidPhone(String value) {
  final digits = value.replaceAll(RegExp(r'[+\s]'), '');
  return digits.length >= 7 && digits.length <= 15;
}

/// Form card for the primary client contact (name, position, email, phone).
///
/// Validates the phone number live and shows an inline error when the format
/// is invalid. When [readOnly] is true all fields are disabled.
class MainClientForum extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController positionController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final bool readOnly;

  const MainClientForum({
    super.key,
    required this.nameController,
    required this.positionController,
    required this.emailController,
    required this.phoneController,
    this.readOnly = false,
  });

  @override
  State<MainClientForum> createState() => _MainClientForumState();
}

/// State for [MainClientForum]. Manages inline phone-validation error message.
class _MainClientForumState extends State<MainClientForum> {
  String? _phoneError;

  /// Validates [value] and updates the phone error message shown below the field.
  void _onPhoneChanged(String value) {
    if (value.isEmpty) {
      setState(() => _phoneError = null);
      return;
    }
    setState(() {
      _phoneError = _isValidPhone(value)
          ? null
          : 'Enter a valid phone number (7–15 digits)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Full Name',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: widget.nameController,
                readOnly: widget.readOnly,
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "e.g Mohammed",
                  hintStyle: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF808080),
                  ),
                  filled: widget.readOnly,
                  fillColor: disableColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Client Position',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: widget.positionController,
                readOnly: widget.readOnly,
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "e.g CEO",
                  hintStyle: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF808080),
                  ),
                  filled: widget.readOnly,
                  fillColor: disableColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Client Email',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 336),
                Text(
                  'Client Phone Number',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: widget.emailController,
                      readOnly: widget.readOnly,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g example@example.com",
                        hintStyle: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF808080),
                        ),
                        filled: widget.readOnly,
                        fillColor: disableColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF808080),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF808080),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: widget.phoneController,
                    readOnly: widget.readOnly,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s]')),
                    ],
                    onChanged: widget.readOnly ? null : _onPhoneChanged,
                    maxLines: 1,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g +962 79 7786 498",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
                      errorText: widget.readOnly ? null : _phoneError,
                      errorStyle: GoogleFonts.firaSans(fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: _phoneError != null
                              ? Colors.red
                              : Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: _phoneError != null
                              ? Colors.red
                              : Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Form card for an additional (non-primary) client contact.
///
/// Identical layout to [MainClientForum] but used for contacts 2, 3, etc.
class OtherContactsForum extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController positionController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final bool readOnly;

  const OtherContactsForum({
    super.key,
    required this.nameController,
    required this.positionController,
    required this.emailController,
    required this.phoneController,
    this.readOnly = false,
  });

  @override
  State<OtherContactsForum> createState() => _OtherContactsForumState();
}

/// State for [OtherContactsForum]. Manages inline phone-validation error message.
class _OtherContactsForumState extends State<OtherContactsForum> {
  String? _phoneError;

  /// Validates [value] and updates the phone error message shown below the field.
  void _onPhoneChanged(String value) {
    if (value.isEmpty) {
      setState(() => _phoneError = null);
      return;
    }
    setState(() {
      _phoneError = _isValidPhone(value)
          ? null
          : 'Enter a valid phone number (7–15 digits)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: widget.nameController,
                readOnly: widget.readOnly,
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "e.g Mohammed",
                  hintStyle: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF808080),
                  ),
                  filled: widget.readOnly,
                  fillColor: disableColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Position',
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 65,
              child: TextField(
                controller: widget.positionController,
                readOnly: widget.readOnly,
                expands: true,
                maxLines: null,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "e.g CEO",
                  hintStyle: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF808080),
                  ),
                  filled: widget.readOnly,
                  fillColor: disableColor,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Color(0xFF808080)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Email',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 404),
                Text(
                  'Phone Number',
                  style: GoogleFonts.firaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 65,
                    child: TextField(
                      controller: widget.emailController,
                      readOnly: widget.readOnly,
                      expands: true,
                      maxLines: null,
                      style: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g example@example.com",
                        hintStyle: GoogleFonts.firaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF808080),
                        ),
                        filled: widget.readOnly,
                        fillColor: disableColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF808080),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF808080),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: widget.phoneController,
                    readOnly: widget.readOnly,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s]')),
                    ],
                    onChanged: widget.readOnly ? null : _onPhoneChanged,
                    maxLines: 1,
                    style: GoogleFonts.firaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g +962 79 7786 498",
                      hintStyle: GoogleFonts.firaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                      ),
                      filled: widget.readOnly,
                      fillColor: disableColor,
                      errorText: widget.readOnly ? null : _phoneError,
                      errorStyle: GoogleFonts.firaSans(fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: _phoneError != null
                              ? Colors.red
                              : Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: _phoneError != null
                              ? Colors.red
                              : Color(0xFF808080),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
