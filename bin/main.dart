import 'package:pm_p4_4243250049/kendaraan.dart';
import 'package:pm_p4_4243250049/parkiran.dart';

Future<void> main() async {
  final parkiranFmipa = Parkiran(3);

  // Listener pos jaga memantau Stream kejadian
  final sub = parkiranFmipa.kejadian.listen((pesan) {
    print(pesan);
  });

  final jamMasuk = DateTime(2026, 11, 23, 8, 0);

  // Demonstrasi polimorfisme melalui List<Kendaraan>
  final antreanMasuk = <Kendaraan>[
    Motor('BK 1234 AB', jamMasuk),
    Mobil('BK 88 UN', jamMasuk),
    MobilMember('BK 7 MIPA', jamMasuk),
    Truk('BK 9999 XX', jamMasuk), // Akan ditolak karena kapasitas 3 penuh
  ];

  for (final k in antreanMasuk) {
    try {
      await parkiranFmipa.masuk(k);
    } on ParkirPenuh catch (e) {
      print(e);
    }
  }

  // Simulasi kendaraan keluar pada jam berbeda
  // Motor masuk 08:00, keluar 09:15 (1 jam 15 menit -> dibulatkan 2 jam x Rp3.000 = Rp6.000)
  await parkiranFmipa.keluar('BK 1234 AB', DateTime(2026, 11, 23, 9, 15));

  // Mobil masuk 08:00, keluar 10:30 (2 jam 30 menit -> dibulatkan 3 jam x Rp5.000 = Rp15.000)
  await parkiranFmipa.keluar('BK 88 UN', DateTime(2026, 11, 23, 10, 30));

  // MobilMember masuk 08:00, keluar 11:00 (3 jam x Rp5.000 = Rp15.000 -> diskon 50% = Rp7.500)
  await parkiranFmipa.keluar('BK 7 MIPA', DateTime(2026, 11, 23, 11, 0));

  // Beri jeda singkat agar semua event stream selesai tercetak sebelum total pendapatan
  await Future.delayed(const Duration(milliseconds: 50));
  print('Pendapatan: Rp${parkiranFmipa.pendapatan}');

  await sub.cancel();
  await parkiranFmipa.tutup();
}