import 'package:flutter/material.dart';

class MedicationModel {
  final String id;
  final String userId;
  final String name;
  final int hour;
  final int minute;
  final String frequency;
  final String? notes;
  final DateTime createdAt;

  MedicationModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.hour,
    required this.minute,
    required this.frequency,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'hour': hour,
      'minute': minute,
      'frequency': frequency,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      hour: map['hour'] ?? 0,
      minute: map['minute'] ?? 0,
      frequency: map['frequency'] ?? 'Diário',
      notes: map['notes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  String get formattedTime {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  TimeOfDay get timeOfDay {
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Adicionar método copyWith
  MedicationModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? hour,
    int? minute,
    String? frequency,
    String? notes,
    DateTime? createdAt,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      frequency: frequency ?? this.frequency,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}