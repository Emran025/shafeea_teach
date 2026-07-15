import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a single document uploaded by a teacher applicant.
///
/// Documents are immutable value objects in the domain layer.
/// They carry metadata (type, riwayah, issuing details) and an optional
/// [fileUrl] that points to the file stored on the server.
@immutable
class DocumentEntity extends Equatable {
  final int id;

  /// Human-readable document name (e.g. "شهادة حفظ القرآن الكريم").
  final String name;

  /// The document category as stored in the DB enum.
  final String certificateType;

  /// Only set when [certificateType] is 'Other'.
  final String? certificateTypeOther;

  /// Quranic recitation riwayah, if applicable.
  final String? riwayah;

  /// Institution or location that issued the document.
  final String? issuingPlace;

  /// Date the document was issued (ISO-8601 date string or null).
  final String? issuingDate;

  /// Full publicly accessible URL for the uploaded file.
  /// `null` means the applicant submitted metadata only — no file was attached.
  final String? fileUrl;

  /// Convenience flag: `true` when [fileUrl] is non-null.
  final bool hasFile;

  const DocumentEntity({
    required this.id,
    required this.name,
    required this.certificateType,
    this.certificateTypeOther,
    this.riwayah,
    this.issuingPlace,
    this.issuingDate,
    this.fileUrl,
    required this.hasFile,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        certificateType,
        certificateTypeOther,
        riwayah,
        issuingPlace,
        issuingDate,
        fileUrl,
        hasFile,
      ];
}
