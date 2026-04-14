import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mdp_gold/services/gold_service.dart';

class GoldListScreen extends StatefulWidget {
  const GoldListScreen({super.key});

  @override
  State<GoldListScreen> createState() => _GoldListScreenState();
}

class _GoldListScreenState extends State<GoldListScreen> {
  final GoldService _goldService = GoldService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== JUDUL ==========
              // Widget Text untuk menampilkan judul halaman
              const Text(
                'Daftar Emas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: StreamBuilder<DatabaseEvent>(
                  stream: _goldService.getGoldList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final data = snapshot.data?.snapshot.value;
                    if (data == null) {
                      return const Center(child: Text('Belum ada item.'));
                    }
                    final Map<dynamic, dynamic> itemsMap =
                        data as Map<dynamic, dynamic>;
                    final items = itemsMap.entries.toList();
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = Map<String, dynamic>.from(
                          items[index].value as Map,
                        );
                        final int harga = item['harga'] is int
                            ? item['harga'] as int
                            : int.tryParse(item['harga']?.toString() ?? '') ??
                                  0;
                        final String tanggal =
                            item['tanggal']?.toString() ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              'Rp ${_formatCurrency(harga)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Tanggal: $tanggal'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatCurrency(int value) {
  final digits = value.toString();
  final reversed = digits.split('').reversed.join();
  final parts = <String>[];

  for (var i = 0; i < reversed.length; i += 3) {
    parts.add(
      reversed.substring(i, i + 3 > reversed.length ? reversed.length : i + 3),
    );
  }

  return parts.join('.').split('').reversed.join();
}
