class CommentsModel {
  List<Comment>? data;

  CommentsModel({this.data});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Comment>[];
      json['data'].forEach((v) {
        data!.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  String? ratingId;
  String? customerId;
  String? advertizerId;
  String? rating;
  String? comment;
  String? dateAdded;
  String? name;

  Comment(
      {this.ratingId,
      this.customerId,
      this.advertizerId,
      this.rating,
      this.comment,
      this.dateAdded,
      this.name});

  Comment.fromJson(Map<String, dynamic> json) {
    ratingId = json['rating_id'];
    customerId = json['customer_id'];
    advertizerId = json['advertizer_id'];
    rating = json['rating'];
    comment = json['comment'];
    dateAdded = json['date_added'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_id'] = this.ratingId;
    data['customer_id'] = this.customerId;
    data['advertizer_id'] = this.advertizerId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['date_added'] = this.dateAdded;
    data['name'] = this.name;
    return data;
  }
}
