import 'dart:async';
import 'kendaraan.dart';

class ParkirPenuh implements Exception {
  final int kapasitas;
  ParkirPenuh(this.kapasitas);

  @override
  String toString() => 'Ditolak: Parkiran penuh (kapasitas $kapasitas)';
}

class Parkiran {
  final int kapasitas;
  final List<Kendaraan> _terparkir = [];
  int _pendapatan = 0;
  final _kejadian = StreamController<String>.broadcast();

  Parkiran(this.kapasitas);

  int get sisa => kapasitas - _terparkir.length;
  int get pendapatan => _pendapatan;
  Stream<String> get kejadian => _kejadian.stream;

  Future<void> masuk(Kendaraan k) async {
    // Simulasi palang pintu otomatis terbuka
    await Future.delayed(const Duration(milliseconds: 300));

    if (_terparkir.length >= kapasitas) {
      throw ParkirPenuh(kapasitas);
    }

    _terparkir.add(k);
    _kejadian.add('MASUK ${k.label} (sisa$sisa)');
  }

  Future<int> keluar(String plat, DateTime waktuKeluar) async {
    // Simulasi palang pintu keluar
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _terparkir.indexWhere((k) => k.plat == plat);
    if (index == -1) {
      throw StateError('Kendaraan dengan plat $plat tidak ditemukan di parkiran.');
    }

    final k = _terparkir.removeAt(index);
    final totalBayar = k.biaya(waktuKeluar);
    _pendapatan += totalBayar;

    _kejadian.add('KELUAR ${k.label} bayar Rp$totalBayar');
    return totalBayar;
  }

  Future<void> tutup() => _kejadian.close();
}