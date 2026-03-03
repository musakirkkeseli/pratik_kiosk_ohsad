import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/core/utility/logger_service.dart';
import 'package:pratik_pos_integration/pratik_pos_integration.dart';

import '../../../../../core/widget/snackbar_service.dart';
import '../../../../../features/utility/const/constant_string.dart';

class DebugLogButton extends StatelessWidget {
  const DebugLogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        SnackbarService().showSnackBar('Log dosyaları kontrol ediliyor...');
        try {
          // Tüm log dosyalarını al
          final result = await PosService.instance.debugGetAllLogs();
          final files = result['files'] as List<Map<String, dynamic>>? ?? [];
          final logsDir = result['logsDir'] as String? ?? '';

          if (files.isEmpty) {
            SnackbarService().showSnackBar(
              '⚠️ Henüz log dosyası yok.\n'
              'Bir ödeme işlemi yapın, sonra tekrar deneyin.\n\n'
              'Log dizini: $logsDir',
            );
          } else {
            // Detaylı görüntüleme için yeni sayfaya git
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    LogViewerPage(logsDir: logsDir, files: files),
              ),
            );
          }
        } catch (e) {
          SnackbarService().showSnackBar('✗ Log okuma hatası: $e');
        }
      },
      icon: const Icon(Icons.bug_report),
      label: const Text('Debug: Logları Göster'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}

/// Log dosyalarını detaylı görüntüleme sayfası
class LogViewerPage extends StatefulWidget {
  final String logsDir;
  final List<Map<String, dynamic>> files;

  const LogViewerPage({super.key, required this.logsDir, required this.files});

  @override
  State<LogViewerPage> createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<LogViewerPage> {
  bool _isLoading = false;

  Future<void> _sendLogsToServer() async {
    setState(() => _isLoading = true);

    try {
      // Tüm log dosyalarını birleştir
      final allLogs = <Map<String, dynamic>>[];

      for (final file in widget.files) {
        final lines = file['lines'] as List<dynamic>;
        for (final line in lines) {
          try {
            final logEntry = jsonDecode(line as String) as Map<String, dynamic>;
            allLogs.add(logEntry);
          } catch (e) {
            // Parse edilemeyen satırları string olarak ekle
            allLogs.add({'raw': line, 'parseError': e.toString()});
          }
        }
      }

      // JSON formatında hazırla
      final payload = {
        'timestamp': DateTime.now().toIso8601String(),
        'deviceInfo': {
          'logsDir': widget.logsDir,
          'fileCount': widget.files.length,
        },
        'logs': allLogs,
      };
      MyLog("_sendLogsToServer").d(payload);
      // TODO: Sunucu endpoint'ini buraya ekleyin
      final serverUrl = '${ConstantString.backendUrl}/pos/kiosk-log';

      final response = await Dio().post(
        serverUrl,
        data: jsonEncode(payload),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 100),
          receiveTimeout: const Duration(seconds: 100),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          SnackbarService().showSnackBar(
            '✓ Loglar başarıyla gönderildi (${allLogs.length} kayıt)',
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        SnackbarService().showSnackBar('✗ Log gönderme hatası: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearLogs() async {
    // Onay dialogu göster
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logları Temizle'),
        content: const Text(
          'Tüm log dosyaları silinecek. Devam etmek istiyor musunuz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Evet', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      // Log dosyalarını sil
      var deletedCount = 0;
      for (final file in widget.files) {
        final filePath = file['fullPath'] as String;
        final logFile = File(filePath);
        if (await logFile.exists()) {
          await logFile.delete();
          deletedCount++;
        }
      }

      if (mounted) {
        SnackbarService().showSnackBar(
          '✓ $deletedCount log dosyası temizlendi',
        );

        // Sayfayı kapat ve önceki sayfaya dön
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        SnackbarService().showSnackBar('✗ Log temizleme hatası: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Dosyaları'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          // Logları sunucuya gönder butonu
          IconButton(
            onPressed: _isLoading ? null : _sendLogsToServer,
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Logları Sunucuya Gönder',
          ),
          // Logları temizle butonu
          IconButton(
            onPressed: _isLoading ? null : _clearLogs,
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Logları Temizle',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                // Dizin yolu kartı
                Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📁 Log Dizini:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        widget.logsDir,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '💡 ADB ile erişim:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        'adb shell run-as com.pratikbilisim.kiosk cat "${widget.logsDir}/order_*.jsonl"',
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dosya listesi
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.files.length,
                    itemBuilder: (context, index) {
                      final file = widget.files[index];
                      final fileName = file['fileName'] as String;
                      final lineCount = file['lineCount'] as int;

                      return ListTile(
                        leading: const Icon(
                          Icons.description,
                          color: Colors.orange,
                        ),
                        title: Text(fileName),
                        subtitle: Text('$lineCount satır'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LogDetailPage(file: file),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

/// Tek bir log dosyasının detay sayfası
class LogDetailPage extends StatelessWidget {
  final Map<String, dynamic> file;

  const LogDetailPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final fileName = file['fileName'] as String;
    final fullPath = file['fullPath'] as String;
    final lines = file['lines'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Dosya yolu
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tam Yol:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SelectableText(
                  fullPath,
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),

          // Log satırları
          Expanded(
            child: ListView.builder(
              itemCount: lines.length,
              itemBuilder: (context, index) {
                final line = lines[index] as String;

                // JSON parse et
                Map<String, dynamic>? logEntry;
                try {
                  logEntry = jsonDecode(line) as Map<String, dynamic>;
                } catch (e) {
                  // Parse edilemezse ham hali göster
                }

                if (logEntry != null) {
                  return _buildLogEntryCard(context, index + 1, logEntry);
                } else {
                  return ListTile(
                    title: Text(
                      'Satır ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: SelectableText(line),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntryCard(
    BuildContext context,
    int lineNumber,
    Map<String, dynamic> entry,
  ) {
    final type = entry['type'] as String?;
    final timestamp = entry['timestamp'] as String?;

    Color cardColor;
    IconData icon;

    switch (type) {
      case 'request':
        cardColor = Colors.blue[50]!;
        icon = Icons.arrow_upward;
        break;
      case 'response':
        cardColor = Colors.green[50]!;
        icon = Icons.arrow_downward;
        break;
      case 'error':
        cardColor = Colors.red[50]!;
        icon = Icons.error;
        break;
      default:
        cardColor = Colors.grey[50]!;
        icon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: cardColor,
      child: ExpansionTile(
        leading: Icon(icon, color: _getColorForType(type)),
        title: Text(
          '[$lineNumber] ${type?.toUpperCase() ?? 'LOG'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: timestamp != null
            ? Text(
                DateTime.parse(timestamp).toLocal().toString(),
                style: const TextStyle(fontSize: 11),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                const JsonEncoder.withIndent('  ').convert(entry),
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForType(String? type) {
    switch (type) {
      case 'request':
        return Colors.blue;
      case 'response':
        return Colors.green;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
