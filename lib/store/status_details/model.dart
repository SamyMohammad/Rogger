import 'dart:convert';

StatusModel statusModelFromJson(String str) =>
    StatusModel.fromJson(json.decode(str));

String statusModelToJson(StatusModel data) => json.encode(data.toJson());

class StatusModel {
  StatusModel({
    this.stories,
  });

  List<Status>? stories;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        stories: json["stories"] == null
            ? []
            : List<Status>.from(
                json["stories"]!.map((x) => Status.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stories": stories == null
            ? []
            : List<dynamic>.from(stories!.map((x) => x.toJson())),
      };
}

class Status {
  Status({
    this.storyId,
    this.attachment,
    this.attachmentType,
    this.dateAdded,
    this.views,
  });

  int? storyId;
  String? attachment;
  String? attachmentType;
  DateTime? dateAdded;
  int? views;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        views: json["views"],
        storyId: json["story_id"],
        attachment: json["attachment"],
        attachmentType: json["attachment_type"],
        dateAdded: json["date_added"] == null
            ? null
            : DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "story_id": storyId,
        "views": views,
        "attachment": attachment,
        "attachment_type": attachmentType,
        "date_added": dateAdded?.toIso8601String(),
      };
}
