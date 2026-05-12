import 'package:flutter/material.dart';

class GroupFormState {
  int activeType = 0; // 0=Split, 1=Packaged, 2=Central
  int activeInvertor = 0; // 0=Invertor, 1=Non-Invertor

  // Controllers shared across all types
  final noOfUnits = TextEditingController();
  final capacity = TextEditingController();
  final yearlyHours = TextEditingController();
  final ratedPower = TextEditingController();
  final notes = TextEditingController();

  // Packaged-only
  final noOfPackages = TextEditingController();
  final packageCapacity = TextEditingController();
  final packageHours = TextEditingController();
  final packagePower = TextEditingController();
  final packageNotes = TextEditingController();

  // Central-only
  final chillerCapacity = TextEditingController();
  final chillerPower = TextEditingController();
  final chillerHours = TextEditingController();
  final ahuCount = TextEditingController();
  final centralNotes = TextEditingController();

  // Computed fields
  String get totalPower {
    final units = double.tryParse(noOfUnits.text) ?? 0;
    final power = double.tryParse(ratedPower.text) ?? 0;
    if (units == 0 || power == 0) return '';
    return (units * power).toStringAsFixed(2);
  }

  String get annualKwh {
    final tp = double.tryParse(totalPower) ?? 0;
    final hours = double.tryParse(yearlyHours.text) ?? 0;
    if (tp == 0 || hours == 0) return '';
    return (tp * hours).toStringAsFixed(2);
  }

  String get packageTotalPower {
    final units = double.tryParse(noOfPackages.text) ?? 0;
    final power = double.tryParse(packagePower.text) ?? 0;
    if (units == 0 || power == 0) return '';
    return (units * power).toStringAsFixed(2);
  }

  String get packageAnnualKwh {
    final tp = double.tryParse(packageTotalPower) ?? 0;
    final hours = double.tryParse(packageHours.text) ?? 0;
    if (tp == 0 || hours == 0) return '';
    return (tp * hours).toStringAsFixed(2);
  }

  String get centralTotalPower {
    final power = double.tryParse(chillerPower.text) ?? 0;
    if (power == 0) return '';
    return power.toStringAsFixed(2);
  }

  String get centralAnnualKwh {
    final tp = double.tryParse(centralTotalPower) ?? 0;
    final hours = double.tryParse(chillerHours.text) ?? 0;
    if (tp == 0 || hours == 0) return '';
    return (tp * hours).toStringAsFixed(2);
  }

  Map<String, dynamic> toMap() {
    return {
      'acType': activeType,
      'invertor': activeInvertor,
      'noOfUnits': noOfUnits.text,
      'capacity': capacity.text,
      'yearlyHours': yearlyHours.text,
      'ratedPower': ratedPower.text,
      'notes': notes.text,
      'noOfPackages': noOfPackages.text,
      'packageCapacity': packageCapacity.text,
      'packageHours': packageHours.text,
      'packagePower': packagePower.text,
      'packageNotes': packageNotes.text,
      'chillerCapacity': chillerCapacity.text,
      'chillerPower': chillerPower.text,
      'chillerHours': chillerHours.text,
      'ahuCount': ahuCount.text,
      'centralNotes': centralNotes.text,
    };
  }

  void dispose() {
    for (final c in [
      noOfUnits, capacity, yearlyHours, ratedPower, notes,
      noOfPackages, packageCapacity, packageHours, packagePower, packageNotes,
      chillerCapacity, chillerPower, chillerHours, ahuCount, centralNotes,
    ]) {
      c.dispose();
    }
  }
}