import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:hali_stawi/model/payment_history_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentHistoryBloc {
  PaymentHistoryRepository _repository = PaymentHistoryRepository();
  final _allPaymentHistoryFetcher = PublishSubject<List<PaymentHistoryModel>>(); 
  Stream<List<PaymentHistoryModel>> get payments => _allPaymentHistoryFetcher.stream;

  fetchPaymentHistory(String national_id, authToken) async {
    List<PaymentHistoryModel> paymentsResponse = await _repository.fetchPaymentHistory(national_id, authToken);
    _allPaymentHistoryFetcher.sink.add(paymentsResponse);
  }
  dispose() {
    _allPaymentHistoryFetcher.close();
  }
}
final paymentsBloc = PaymentHistoryBloc();

class PaymentHistoryRepository {
  PaymentHistoryApiProvider appApiProvider = PaymentHistoryApiProvider();
  Future<List<PaymentHistoryModel>> fetchPaymentHistory(String national_id, authToken) =>
      appApiProvider.fetchPaymentHistory(national_id, authToken);
}

class PaymentHistoryApiProvider { 
  Client client = Client();
  Future<List<PaymentHistoryModel>> fetchPaymentHistory(String national_id, authToken) async {
     final response = await client.post(Uri.parse(
      "https://mobilehali.tenwebtechnologies.com/api/patient/paymenthistory"),
      body: {
        "national_id": "$national_id"
      },
      headers: {'Authorization': 'Bearer $authToken'} 
    );
    var data = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('balance', data['balance']);
    if (response.statusCode == 200) {
      return featuredFromJson(json.encode(data['payments'])); 
    } else {
      throw Exception('Failed to load Featured');
    }
  }
}