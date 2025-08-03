import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jangoldi_jharna_academy/models/result_params_model.dart';
import 'package:jangoldi_jharna_academy/providers/exam_terms_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ResultScreen extends ConsumerStatefulWidget {
  final String userName;
  const ResultScreen({super.key, required this.userName});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  String? selectedTermId;

  Future<void> _exportToPDF(termResult) async {
    final pdf = pw.Document();

    // Check and request permission
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required.")),
      );
      return;
    }

    final directory = await getExternalStorageDirectory();
    final fileName = "${termResult.termName}_Result.pdf";
    final filePath = "${directory!.path}/$fileName";

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Info
              pw.Text(
                'BNI MADRASHA',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Student ID: ${widget.userName}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Exam Term: ${termResult.termName}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 16),

              // Table
              pw.Table.fromTextArray(
                headers: ['Subject', 'Marks', 'Grade', 'GPA'],
                data: termResult.subjects
                    .map(
                      (s) => [
                    s.subjectName,
                    s.totalMarks,
                    s.grade,
                    s.gpa.toString(),
                  ],
                )
                    .toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.teal),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 20),

              pw.Text(
                'Average GPA: ${_calculateAvgGPA(termResult.subjects).toStringAsFixed(2)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Average Marks: ${_calculateAvgMarks(termResult.subjects).toStringAsFixed(2)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          );
        },
      ),
    );

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Show confirmation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("PDF saved to: $filePath")));
  }

  double _calculateAvgGPA(List subjects) {
    final gpas = subjects.map((s) => double.tryParse(s.gpa) ?? 0).toList();
    return gpas.isEmpty ? 0 : gpas.reduce((a, b) => a + b) / gpas.length;
  }

  double _calculateAvgMarks(List subjects) {
    final marks = subjects
        .map((s) => double.tryParse(s.totalMarks) ?? 0)
        .toList();
    return marks.isEmpty ? 0 : marks.reduce((a, b) => a + b) / marks.length;
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green.shade700;
      case 'A':
        return Colors.green;
      case 'A-':
        return Colors.lightGreen;
      case 'B':
        return Colors.orange;
      case 'C':
        return Colors.deepOrange;
      case 'F':
      case '0.0':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final termsAsync = ref.watch(examTermsProvider(widget.userName));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Academic Result',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: termsAsync.when(
          data: (terms) {
            final selectedParams = selectedTermId != null
                ? ResultParams(
              userName: widget.userName,
              selectedTermId: selectedTermId!,
            )
                : null;

            final resultAsync = selectedParams != null
                ? ref.watch(resultProvider(selectedParams))
                : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Select Term"),
                  value: selectedTermId,
                  items: terms.map((term) {
                    return DropdownMenuItem(
                      value: term.id,
                      child: Text(term.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTermId = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (resultAsync != null)
                  Expanded(
                    child: resultAsync.when(
                      data: (termResult) {
                        if (termResult == null || termResult.subjects.isEmpty) {
                          return const Center(
                            child: Text("No result found for this term."),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${termResult.termName} Result",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.print),
                                  label: const Text("Print"),
                                  onPressed: () => _exportToPDF(termResult),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        "Subject",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Marks",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Grade",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "GPA",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: termResult.subjects.map((subject) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(subject.subjectName)),
                                        DataCell(Text(subject.totalMarks)),
                                        DataCell(
                                          Text(
                                            subject.grade,
                                            style: TextStyle(
                                              color: _gradeColor(subject.grade),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(subject.gpa)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Average GPA: ${_calculateAvgGPA(termResult.subjects).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Average Marks: ${_calculateAvgMarks(termResult.subjects).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () =>
                      const Center(child: CircularProgressIndicator()),
                      error: (e, _) =>
                          Center(child: Text("Error loading result: $e")),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error loading terms: $e")),
        ),
      ),
    );
  }
}
