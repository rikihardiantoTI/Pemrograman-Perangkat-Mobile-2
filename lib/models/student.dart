import 'package:flutter/widgets.dart';

@immutable
class Student {
  const Student({
    required this.name,
    required this.nim,
    required this.kelas,
    required this.roleLabel,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.verifiedAt,
    required this.faculty,
    required this.major,
  });

  final String name;
  final String nim;
  final String kelas;
  final String roleLabel;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String verifiedAt;
  final String faculty;
  final String major;
}
