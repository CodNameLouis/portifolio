import 'package:equatable/equatable.dart';
import 'package:portfolio_luan/features/home/models/highlight_stat_model.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.greeting,
    required this.role,
    required this.bio,
    required this.available,
    required this.availabilityLabel,
    required this.photo,
    required this.stats,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final rawStats = json['stats'] as List<dynamic>? ?? const [];

    return ProfileModel(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      greeting: json['greeting'] as String? ?? '',
      role: json['role'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      available: json['available'] as bool? ?? false,
      availabilityLabel: json['availabilityLabel'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      stats: rawStats
          .whereType<Map<String, dynamic>>()
          .map(HighlightStatModel.fromJson)
          .toList(growable: false),
    );
  }

  final String firstName;
  final String lastName;
  final String greeting;
  final String role;
  final String bio;
  final bool available;
  final String availabilityLabel;
  final String photo;
  final List<HighlightStatModel> stats;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    greeting,
    role,
    bio,
    available,
    availabilityLabel,
    photo,
    stats,
  ];
}
