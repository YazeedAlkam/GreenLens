import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/create_new_project/more_contacts.dart';
import 'package:greenlens/section_head_pages/create_new_project/shared_files/fotter.dart';

class AllContactPage extends StatefulWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> clientInfo;
  final String projectId;

  const AllContactPage({
    super.key,
    required this.onBack,
    required this.clientInfo,
    required this.projectId,
  });

  @override
  State<AllContactPage> createState() => _AllContactPageState();
}

class _AllContactPageState extends State<AllContactPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _v(String? value) =>
      (value == null || value.trim().isEmpty) ? 'No Data' : value;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final main =
        widget.clientInfo['mainContact'] as Map<String, dynamic>? ?? {};
    final second =
        widget.clientInfo['secondContact'] as Map<String, dynamic>? ?? {};
    final extras = (widget.clientInfo['extraContacts'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    final secondName = (second['name'] as String? ?? '').trim();
    final hasSecond = secondName.isNotEmpty;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: widget.onBack,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: SvgPicture.asset('assets/images/Left Arrow.svg'),
                  ),
                ),
                Text(
                  "Contacts",
                  style: GoogleFonts.firaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: dividerColor, height: 2, thickness: 2),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Client Info",
                  style: GoogleFonts.firaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: tablelinescolor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: tablelinescolor, width: 2),
                ),
                children: [
                  _infoRow("ID",
                      _v(widget.projectId.isEmpty ? null : widget.projectId)),
                  _infoRow("Full Name", _v(main['name'] as String?)),
                  _infoRow("Client Position", _v(main['position'] as String?)),
                  _infoRow("Client Email", _v(main['email'] as String?)),
                  _infoRow(
                      "Client Phone Number", _v(main['phone'] as String?)),
                ],
              ),
            ),
            if (hasSecond) ...[
              const SizedBox(height: 16),
              MoreContacts(
                name: secondName,
                position: _v(second['position'] as String?),
                email: _v(second['email'] as String?),
                phoneNumber: _v(second['phone'] as String?),
              ),
            ],
            for (final extra in extras)
              if ((extra['name'] as String? ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                MoreContacts(
                  name: (extra['name'] as String).trim(),
                  position: _v(extra['position'] as String?),
                  email: _v(extra['email'] as String?),
                  phoneNumber: _v(extra['phone'] as String?),
                ),
              ],
            const SizedBox(height: 16),
            CreateNewProjectFooter(
              currentStep: 5,
              onNext: () {},
              onBack: widget.onBack,
              mode: FooterMode.backOnly,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  TableRow _infoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
