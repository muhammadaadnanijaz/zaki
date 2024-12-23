import 'package:flutter/services.dart';

class ContactModel {
  String? id;

  /// The contact display name.
  String? displayName;

  // / A low-resolution version of the [photo].

  /// The full-resolution contact picture.
  Uint8List? photo;

  /// Whether the contact is starred (Android only).
  bool? isStarred;

  /// Structured name.
  String? name;

  /// Phone numbers.
  String? phones;

  /// Email addresses.
  String? emails;

  /// Whether the low-resolution thumbnail was fetched.
  bool? thumbnailFetched = true;

  /// Whether the high-resolution photo was fetched.
  bool? photoFetched = true;

  /// Whether this is a unified contact (and not a raw contact).
  bool? isUnified = true;

  /// Whether properties (name, phones, emails, etc).
  bool? propertiesFetched = true;

  ContactModel(
      {this.id,
      this.displayName, 
      this.name, 
      this.emails,
      this.phones, 
      this.photo,
      this.isStarred, 
      this.isUnified,
      this.photoFetched,
      this.propertiesFetched,
      this.thumbnailFetched
      });
}
