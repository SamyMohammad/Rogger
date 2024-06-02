import 'dart:convert';

class Rating {
  String? ratingId;
  String? customerId;
  String? advertizerId;
  String? rating;
  dynamic comment;
  String? dateAdded;

  Rating({
    this.ratingId,
    this.customerId,
    this.advertizerId,
    this.rating,
    this.comment,
    this.dateAdded,
  });

  factory Rating.fromMap(Map<String, dynamic> data) => Rating(
        ratingId: data['rating_id'] as String?,
        customerId: data['customer_id'] as String?,
        advertizerId: data['advertizer_id'] as String?,
        rating: data['rating'] as String?,
        comment: data['comment'] as dynamic,
        dateAdded: data['date_added'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'rating_id': ratingId,
        'customer_id': customerId,
        'advertizer_id': advertizerId,
        'rating': rating,
        'comment': comment,
        'date_added': dateAdded,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Rating].
  factory Rating.fromJson(String data) {
    return Rating.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Rating] to a JSON string.
  String toJson() => json.encode(toMap());
}
