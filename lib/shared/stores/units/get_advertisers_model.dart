class GetAdvertisersModel {
  bool? success;
  List<Advertisers>? advertisers;

  GetAdvertisersModel({this.success, this.advertisers});

  GetAdvertisersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['advertisers'] != null) {
      advertisers = <Advertisers>[];
      json['advertisers'].forEach((v) {
        advertisers!.add(new Advertisers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.advertisers != null) {
      data['advertisers'] = this.advertisers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Advertisers {
  String? name;
  String? nickname;
  String? profile;
  String? rating;
  String? id;
  String? customerId;
  bool? verifiedFlag;

  Advertisers(
      {this.name,
      this.nickname,
      this.profile,
      this.rating,
      this.id,
      this.customerId,
      this.verifiedFlag
      });

  Advertisers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nickname = json['nickname'];
    profile = json['profile'];
    rating = json['rating'];
    id = json['id'];
    customerId = json['customer_id'];
      verifiedFlag =json['verified_flag'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['nickname'] = this.nickname;
    data['profile'] = this.profile;
    data['rating'] = this.rating;
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['verified_flag'] = this.verifiedFlag;
     
    return data;
  }
}
