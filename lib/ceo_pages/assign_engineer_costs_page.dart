import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/footer.dart';

class AssignEngineerCostsPage extends StatefulWidget {
  const AssignEngineerCostsPage({super.key});

  @override
  State<AssignEngineerCostsPage> createState() =>
      _AssignEngineerCostsPageState();
}

class _AssignEngineerCostsPageState extends State<AssignEngineerCostsPage> {
  late Future<List<Map<String, dynamic>>> _engineersFuture;
  final Map<String, TextEditingController> _rateControllers = {};

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _engineersFuture = _fetchEngineers();
  }

  @override
  void dispose() {
    for (final c in _rateControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchEngineers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Engineer')
        .get();
    return snapshot.docs
        .map((doc) => {'docId': doc.id, ...doc.data()})
        .toList();
  }

  Future<void> _saveChanges(List<Map<String, dynamic>> engineers) async {
    setState(() => _isSaving = true);
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (final eng in engineers) {
        final docId = eng['docId'] as String;
        final controller = _rateControllers[docId];
        if (controller == null) continue;
        final rateText = controller.text.trim();
        final ref =
            FirebaseFirestore.instance.collection('users').doc(docId);
        final rate = int.tryParse(rateText);
        if (rate != null) {
          batch.update(ref, {'rate': rate});
        } else {
          batch.update(ref, {'rate': FieldValue.delete()});
        }
      }
      await batch.commit();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        _tableCell(
          Text('ID',
              style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: primaryColor)),
        ),
        _tableCell(
          Text('Name',
              style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: primaryColor)),
          center: false,
        ),
        _tableCell(
          Text('Email',
              style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: primaryColor)),
          center: false,
        ),
        _tableCell(
          Text('Cost / hr',
              style: GoogleFonts.firaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: primaryColor)),
        ),
      ],
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> eng, String docId) {
    final id = eng['customId'];
    final name = eng['name'] as String? ?? '—';
    final email = eng['email'] as String? ?? '—';

    return TableRow(
      children: [
        // ID
        _tableCell(
          Text(id?.toString() ?? '—',
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.firaSans(fontSize: 24, color: Colors.black)),
        ),
        // Name
        _tableCell(
          Text(name,
              style:
                  GoogleFonts.firaSans(fontSize: 24, color: Colors.black)),
          center: false,
        ),
        // Email
        _tableCell(
          Row(
            children: [
              Expanded(
                child: Text(email,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.firaSans(
                        fontSize: 24, color: Colors.black)),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: email));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email copied'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Icon(Icons.copy, size: 20, color: primaryColor),
              ),
            ],
          ),
          center: false,
        ),
        // Cost/hr — editable
        _tableCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TextField(
                  controller: _rateControllers[docId],
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.firaSans(
                      fontSize: 24, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'No Data',
                    hintStyle: GoogleFonts.firaSans(
                        fontSize: 24, color: Colors.grey),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'JOD',
                style: GoogleFonts.firaSans(
                    fontSize: 24, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tableCell(Widget child, {bool center = true}) => TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          height: 69,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: center ? Center(child: child) : Align(alignment: Alignment.centerLeft, child: child),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: "Assign Engineer's Costs",
        subtitle: 'View and Edit your engineers costs',
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _engineersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load engineers.',
                style: GoogleFonts.firaSans(color: Colors.red),
              ),
            );
          }
          final engineers = snapshot.data ?? [];

          // Initialise controllers once
          for (final eng in engineers) {
            final docId = eng['docId'] as String;
            if (!_rateControllers.containsKey(docId)) {
              final rate = eng['rate'];
              _rateControllers[docId] = TextEditingController(
                text: rate != null ? rate.toString() : '',
              );
            }
          }

          return Column(
            children: [
              // ── Table area ──────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Engineer's Costs",
                        style: GoogleFonts.firaSans(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: engineers.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'No engineers found.',
                                    style: GoogleFonts.firaSans(
                                        color: Colors.grey),
                                  ),
                                )
                              : Table(
                                  border: TableBorder.all(
                                    color: tablelinescolor,
                                    width: 1,
                                  ),
                                  columnWidths: const {
                                    0: FlexColumnWidth(5),
                                    1: FlexColumnWidth(18),
                                    2: FlexColumnWidth(18),
                                    3: FlexColumnWidth(10),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    _buildHeaderRow(),
                                    for (final eng in engineers)
                                      _buildDataRow(
                                        eng,
                                        eng['docId'] as String,
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Footer: Back + Save Changes ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Footer(
                  currentStep: 0,
                  onNext: () {},
                  onBack: () => Navigator.pop(context),
                  mode: FooterMode.saveChanges,
                  onSaveChanges:
                      _isSaving ? null : () => _saveChanges(engineers),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
