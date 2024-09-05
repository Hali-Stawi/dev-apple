import 'dart:convert';

List<PaymentHistoryModel> featuredFromJson(String str) => List<PaymentHistoryModel>.from(json.decode(str).map((x) => PaymentHistoryModel.fromJson(x)));

String featuredToJson(List<PaymentHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentHistoryModel {
  final int id;
  final int user_id;
  final String mobile_number;
  final int amount;
  final String transactiontime;
  final String transactiondate;
  final String mpesacode;
  final String trans_code;
  final String created_at;
  final String updated_at;

  PaymentHistoryModel({
    this.id,
    this.user_id,
    this.mobile_number,
    this.amount,
    this.transactiontime,
    this.transactiondate,
    this.mpesacode,
    this.trans_code,
    this.created_at,
    this.updated_at
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) => PaymentHistoryModel(
    id: json["id"],
    user_id: json["user_id"],
    mobile_number: json["mobile_number"],
    amount: json["amount"],
    transactiontime: json["transactiontime"],
    transactiondate: json["transactiondate"],
    mpesacode: json["mpesacode"],
    trans_code: json["trans_code"],
    created_at: json["created_at"],
    updated_at: json["updated_at"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": user_id,
    "mobile_number": mobile_number,
    "amount": amount,
    "transactiontime": transactiontime,
    "transactiondate": transactiondate,
    "mpesacode": mpesacode,
    "trans_code": trans_code,
    "created_at": created_at,
    "updated_at": updated_at
  };
}