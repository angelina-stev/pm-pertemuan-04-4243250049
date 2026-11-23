// Mixin untuk kendaraan berlangganan/member (diskon 50%)
mixin Berlangganan {
  double get diskon => 0.5;
  int hitungTarifDiskon(int biayaNormal) => (biayaNormal * (1 - diskon)).round();
}

abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  String get jenis;
  int get tarifPerJam;

  // Pembulatan ke atas per jam, minimal 1 jam
  int hitungDurasiJam(DateTime keluar) {
    final selisihMenit = keluar.difference(waktuMasuk).inMinutes;
    if (selisihMenit <= 0) return 1;
    return (selisihMenit / 60).ceil();
  }

  int biaya(DateTime keluar) {
    return hitungDurasiJam(keluar) * tarifPerJam;
  }

  String get label => '$jenis$plat';
}

class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 3000;
}

class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000;
}

class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 10000;
}

// Subclass Mobil yang menggunakan mixin Berlangganan
class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);

  @override
  String get label => '$jenis (member)$plat';

  @override
  int biaya(DateTime keluar) {
    final normal = super.biaya(keluar);
    return hitungTarifDiskon(normal);
  }
}