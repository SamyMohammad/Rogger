class GetRate {
  bool? success;
  Rating? rating;

  GetRate({this.success, this.rating});

  GetRate.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    rating =
        json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class Rating {
  String? ratingId;
  String? customerId;
  String? advertizerId;
  String? rating;
  String? comment;
  String? dateAdded;

  Rating(
      {this.ratingId,
      this.customerId,
      this.advertizerId,
      this.rating,
      this.comment,
      this.dateAdded});

  Rating.fromJson(Map<String, dynamic> json) {
    ratingId = json['rating_id'];
    customerId = json['customer_id'];
    advertizerId = json['advertizer_id'];
    rating = json['rating'];
    comment = json['comment'];
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_id'] = this.ratingId;
    data['customer_id'] = this.customerId;
    data['advertizer_id'] = this.advertizerId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['date_added'] = this.dateAdded;
    return data;
  }
}
