import 'dart:convert';

List<DependentsModel> featuredFromJson(String str) => List<DependentsModel>.from(json.decode(str).map((x) => DependentsModel.fromJson(x)));

String featuredToJson(List<DependentsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DependentsModel {
  final int dependent_id;
  final String name;
  final String date_of_birth;
  final String gender;
  final int national_id;
  final String relation;
  final String created_at;

  DependentsModel({
    this.dependent_id,
    this.name,
    this.date_of_birth,
    this.gender,
    this.national_id,
    this.relation,
    this.created_at
  });

  factory DependentsModel.fromJson(Map<String, dynamic> json) => DependentsModel(
    dependent_id: json["dependent_id"],
    name: json["name"],
    date_of_birth: json["date_of_birth"],
    gender: json["gender"],
    national_id: json["national_id"],
    relation: json["relation"],
    created_at: json["created_at"]
  );

  Map<String, dynamic> toJson() => {
    "dependent_id": dependent_id,
    "name": name,
    "date_of_birth": date_of_birth,
    "gender": gender,
    "national_id": national_id,
    "relation": relation,
    "created_at": created_at
  };
}