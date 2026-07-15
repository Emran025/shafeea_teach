import 'package:flutter/material.dart';
import '../../domain/entities/document_entity.dart';

/// Data-layer model for a teacher document.
///
/// Parsed directly from the API JSON (snake_case fields are camelCase in the
/// API contract because the resource uses camelCase keys).
@immutable
final class DocumentModel {
  final int id;
  final String name;
  final String certificateType;
  final String? certificateTypeOther;
  final String? riwayah;
  final String? issuingPlace;
  final String? issuingDate;
  final String? fileUrl;
  final bool hasFile;

  const DocumentModel({
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

  /// Creates a [DocumentModel] from the JSON map returned by the API.
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      certificateType: json['certificateType'] as String? ?? '',
      certificateTypeOther: json['certificateTypeOther'] as String?,
      riwayah: json['riwayah'] as String?,
      issuingPlace: json['issuingPlace'] as String?,
      issuingDate: json['issuingDate'] as String?,
      fileUrl: json['fileUrl'] as String?,
      hasFile: json['hasFile'] as bool? ?? (json['fileUrl'] != null),
    );
  }

  /// Converts this data model to a domain [DocumentEntity].
  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      name: name,
      certificateType: certificateType,
      certificateTypeOther: certificateTypeOther,
      riwayah: riwayah,
      issuingPlace: issuingPlace,
      issuingDate: issuingDate,
      fileUrl: fileUrl,
      hasFile: hasFile,
    );
  }
}
