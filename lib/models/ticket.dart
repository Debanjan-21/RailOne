import 'dart:math';
import 'package:intl/intl.dart';
import 'station.dart';

class Ticket {
  final String utsNumber;
  final String seasonTicketCode;
  final String bookingRefCode;
  final Station source;
  final Station destination;
  final DateTime bookingDateTime;
  final DateTime validFrom;
  final DateTime validUpto;
  final String trainType;
  final String travelClass;
  final String ticketType;
  final int adults;
  final int children;
  final int distanceKm;
  final double fareAmount;
  final String viaRoute;
  final bool isPaperless;
  final String transactionId;
  final String passengerName;
  final String passengerAge;
  final String mobileNumber;
  final String idType;
  final String idNumber;

  Ticket({
    required this.utsNumber,
    this.seasonTicketCode = 'XEDWEHJ0FC',
    this.bookingRefCode = 'R27458',
    required this.source,
    required this.destination,
    required this.bookingDateTime,
    required this.validFrom,
    required this.validUpto,
    this.trainType = 'ORDINARY',
    this.travelClass = 'SECOND',
    this.ticketType = 'MONTHLY',
    this.adults = 1,
    this.children = 0,
    required this.distanceKm,
    required this.fareAmount,
    required this.viaRoute,
    this.isPaperless = true,
    required this.transactionId,
    this.passengerName = 'DEBANJAN MAJUMDER',
    this.passengerAge = '23 years',
    this.mobileNumber = '8420613892',
    this.idType = 'STUDENT ID',
    this.idNumber = '•••• 3892',
  });

  /// Factory helper that automatically generates a realistic UTS booked ticket
  /// based on user station selection and current timestamp.
  factory Ticket.generate({
    required Station source,
    required Station destination,
    String trainType = 'ORDINARY',
    String travelClass = 'SECOND',
    int adults = 1,
    int children = 0,
  }) {
    final now = DateTime.now();
    final random = Random();

    // Random time: hour (6 to 21) and minute (0 to 59)
    final randomHour = 6 + random.nextInt(16);
    final randomMinute = random.nextInt(60);

    // Ticket booking date: 3 days before current date with random time
    final bookingDateTime = DateTime(
      now.year,
      now.month,
      now.day - 3,
      randomHour,
      randomMinute,
    );

    // Valid from date: same as ticket booking date
    final validFromDate = bookingDateTime;

    // Valid upto: exact 30 days from current date
    final validUptoDate = now.add(const Duration(days: 30));

    // Realistic distance approximation with accurate bidirectional lookup
    final distance = _calculateDistance(source, destination, random);

    final totalFare = 100.00;

    // UTS Number & Season Ticket Code format (e.g. XEDWEHJ0FC)
    const seasonCode = 'XEDWEHJ0FC';
    final utsPrefix = String.fromCharCode(65 + random.nextInt(26));
    final utsSuffix = (10000000 + random.nextInt(90000000)).toString();
    final utsNumber = '$utsPrefix$utsSuffix';

    final txnId = 'TXN${now.millisecondsSinceEpoch.toString().substring(3)}';
    final via = 'DDC';

    return Ticket(
      utsNumber: utsNumber,
      seasonTicketCode: seasonCode,
      bookingRefCode: 'R27458',
      source: source,
      destination: destination,
      bookingDateTime: bookingDateTime,
      validFrom: validFromDate,
      validUpto: validUptoDate,
      trainType: trainType,
      travelClass: travelClass,
      ticketType: 'MONTHLY',
      adults: adults,
      children: children,
      distanceKm: distance,
      fareAmount: totalFare,
      viaRoute: via,
      isPaperless: true,
      transactionId: txnId,
      passengerName: 'DEBANJAN MAJUMDER',
      passengerAge: '23 years',
      mobileNumber: '8420613892',
      idType: 'STUDENT ID',
      idNumber: '•••• 3892',
    );
  }

  static int _calculateDistance(Station src, Station dest, Random rand) {
    if (src.code == dest.code) return 0;

    // Symmetrical lookup: sort codes alphabetically so A->B and B->A return identical distance
    final pair = [src.code, dest.code]..sort();
    final key = '${pair[0]}-${pair[1]}';

    const Map<String, int> exactDistances = {
      // Kolkata Suburban accurate distances
      'BT-DDJ': 16,    // Barasat <-> Dumdum
      'BP-DDJ': 16,    // Barrackpore <-> Dumdum
      'BP-BT': 18,     // Barrackpore <-> Barasat
      'DDJ-SDAH': 7,   // Dumdum <-> Sealdah
      'BT-SDAH': 22,   // Barasat <-> Sealdah
      'BP-SDAH': 23,   // Barrackpore <-> Sealdah
      'DDJ-HWH': 12,   // Dumdum <-> Howrah
      'BP-HWH': 23,    // Barrackpore <-> Howrah
      'BT-HWH': 26,    // Barasat <-> Howrah
      'HWH-SDAH': 5,   // Howrah <-> Sealdah
      'DDJ-KOAA': 5,   // Dumdum <-> Kolkata
      'BP-KOAA': 19,   // Barrackpore <-> Kolkata
      'BT-KOAA': 19,   // Barasat <-> Kolkata
      'KOAA-SDAH': 7,  // Kolkata <-> Sealdah
      'HWH-KOAA': 8,   // Howrah <-> Kolkata

      // Intercity & Major Routes
      'DLI-NDLS': 3,
      'NDLS-NZM': 7,
      'ANVT-NDLS': 12,
      'AGC-NDLS': 195,
      'JP-NDLS': 303,
      'CDG-NDLS': 244,
      'ASR-NDLS': 448,
      'CNB-NDLS': 440,
      'LKO-NDLS': 512,
      'NDLS-PRYJ': 634,
      'BSB-NDLS': 758,
      'DDU-NDLS': 774,
      'NDLS-PNBE': 998,
      'HWH-NDLS': 1447,
      'NDLS-SDAH': 1453,
      'JAT-NDLS': 577,
      'BPL-NDLS': 701,
      'CSMT-NDLS': 1543,

      // Mumbai
      'CSMT-DR': 9,
      'CSMT-TNA': 34,
      'CSMT-KYN': 54,
      'CSMT-PUNE': 192,
      'BDTS-MMCT': 10,
      'DR-MMCT': 6,
      'MMCT-TNA': 32,
      'KYN-MMCT': 51,
      'MMCT-ST': 263,
      'BRC-MMCT': 392,
      'ADI-MMCT': 491,
      'CSMT-SUR': 455,

      // Eastern / South Eastern
      'BBS-HWH': 437,
      'HWH-PURI': 500,
      'HWH-PNBE': 532,
      'HWH-R': 831,
      'HWH-NGP': 1131,
      'GHY-HWH': 985,
      'HWH-MAS': 1659,
      'HWH-SBC': 1954,

      // Southern
      'MAS-MS': 2,
      'MAS-SBC': 357,
      'BZA-MAS': 431,
      'CBE-MAS': 497,
      'ERS-MAS': 696,
      'MAS-TVC': 790,
      'MYS-SBC': 139,
      'SBC-YPR': 6,
      'SBC-SMVB': 10,
      'HYB-SBC': 624,
      'HYB-SC': 9,
      'BZA-SC': 349,
      'BZA-VSKP': 350,
    };

    if (exactDistances.containsKey(key)) {
      return exactDistances[key]!;
    }

    // Sealdah - Krishnanagar Mainline Km Markers
    const Map<String, int> mainlineKm = {
      'SDAH': 0, 'BNXR': 4, 'DDJ': 7, 'BLH': 12, 'AGP': 14,
      'SEP': 16, 'KDH': 19, 'TGH': 20, 'BP': 23, 'PTF': 25,
      'IP': 27, 'SNR': 30, 'JGDL': 34, 'KNR': 35, 'NH': 38,
      'HLHR': 42, 'KPA': 45, 'KYI': 48, 'MDPR': 53, 'SMX': 57,
      'PLPR': 60, 'CDH': 62, 'PRDB': 68, 'RHA': 74, 'KLNP': 78,
      'BIJ': 82, 'THP': 84, 'BDZ': 89, 'KNJ': 100,
    };

    // Sealdah - Bangaon Line Km Markers (branches at Dum Dum, km 7)
    const Map<String, int> bangaonKm = {
      'SDAH': 0, 'BNXR': 4, 'DDJ': 7, 'DDC': 10, 'DGNR': 11,
      'BBT': 13, 'BRPK': 15, 'NBE': 16, 'MMG': 18, 'HHR': 20,
      'BT': 23, 'BMG': 26, 'DTK': 30, 'BIRA': 34, 'GUMA': 37,
      'ASKR': 41, 'HB': 45, 'SNHT': 49, 'MSL': 53, 'GBG': 57,
      'TKNR': 62, 'CDP': 67, 'BNAA': 72, 'BNJ': 77,
    };

    final sCode = src.code;
    final dCode = dest.code;

    // Both on Mainline
    if (mainlineKm.containsKey(sCode) && mainlineKm.containsKey(dCode)) {
      final diff = (mainlineKm[sCode]! - mainlineKm[dCode]!).abs();
      return diff == 0 ? 5 : diff;
    }

    // Both on Bangaon Line
    if (bangaonKm.containsKey(sCode) && bangaonKm.containsKey(dCode)) {
      final diff = (bangaonKm[sCode]! - bangaonKm[dCode]!).abs();
      return diff == 0 ? 5 : diff;
    }

    // One on Mainline, one on Bangaon Line (connected via Dum Dum Junction, km 7)
    if (mainlineKm.containsKey(sCode) && bangaonKm.containsKey(dCode)) {
      final d1 = (mainlineKm[sCode]! - 7).abs();
      final d2 = (bangaonKm[dCode]! - 7).abs();
      return d1 + d2;
    }
    if (bangaonKm.containsKey(sCode) && mainlineKm.containsKey(dCode)) {
      final d1 = (bangaonKm[sCode]! - 7).abs();
      final d2 = (mainlineKm[dCode]! - 7).abs();
      return d1 + d2;
    }

    if (src.city == dest.city) {
      return 15;
    }

    final hash = key.codeUnits.fold(0, (a, b) => a + b);
    return 300 + (hash * 17) % 1200;
  }

  static double _calculateFare(int distance, String trainType, String travelClass) {
    double fare;
    if (distance <= 20) {
      fare = 10.0;
    } else if (distance <= 50) {
      fare = 20.0;
    } else if (distance <= 100) {
      fare = 35.0;
    } else if (distance <= 300) {
      fare = 80.0;
    } else if (distance <= 600) {
      fare = 155.0;
    } else {
      fare = 215.0 + ((distance - 600) * 0.25).round();
    }

    if (travelClass.contains('FIRST')) {
      fare *= 3.5;
    }

    if (trainType.contains('SUPERFAST')) {
      fare += 15.0;
    }

    return (fare / 5).round() * 5.0; // Round to nearest multiple of 5 INR like CRIS
  }

  static String _determineVia(Station src, Station dest) {
    if (src.city == dest.city) {
      return 'DIRECT / SUBURBAN';
    }
    return 'MAIN LINE (DIRECT)';
  }

  String get formattedBookingTime =>
      DateFormat('dd/MM/yyyy HH:mm').format(bookingDateTime);

  String get formattedOrangeDate =>
      DateFormat('dd MMM yyyy, HH:mm').format(bookingDateTime);

  String get formattedValidFrom =>
      DateFormat('dd/MM/yyyy').format(validFrom);

  String get formattedValidUpto =>
      DateFormat('dd/MM/yyyy').format(validUpto);

  String get formattedValidUntil =>
      DateFormat('dd/MM/yyyy').format(validUpto);

  String get qrPayload =>
      'CRIS:UTS:$seasonTicketCode|SRC:${source.code}|DST:${destination.code}|DATE:${DateFormat('yyyyMMddHHmm').format(bookingDateTime)}|PAX:${passengerName}|FARE:$fareAmount|CLASS:$travelClass';

  String get fareInWords {
    final intFare = fareAmount.toInt();
    return 'Rupees ${_numberToWords(intFare)} Only';
  }

  static String _numberToWords(int n) {
    if (n == 0) return 'Zero';
    final units = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
      'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
      'Seventeen', 'Eighteen', 'Nineteen'
    ];
    final tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];

    if (n < 20) return units[n];
    if (n < 100) {
      return '${tens[n ~/ 10]}${n % 10 != 0 ? ' ${units[n % 10]}' : ''}';
    }
    if (n < 1000) {
      return '${units[n ~/ 100]} Hundred${n % 100 != 0 ? ' and ${_numberToWords(n % 100)}' : ''}';
    }
    if (n < 100000) {
      return '${_numberToWords(n ~/ 1000)} Thousand${n % 1000 != 0 ? ' ${_numberToWords(n % 1000)}' : ''}';
    }
    return n.toString();
  }
}
