import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:hali_stawi/model/dependents_model.dart';
import 'package:rxdart/rxdart.dart';

class DependentsBloc {
  DependentsRepository _repository = DependentsRepository();
  final _allDependentsFetcher = PublishSubject<List<DependentsModel>>(); 
  Stream<List<DependentsModel>> get dependents => _allDependentsFetcher.stream;

  fetchDependents(String national_id, authToken) async {
    List<DependentsModel> dependentsResponse = await _repository.fetchDependents(national_id, authToken);
    _allDependentsFetcher.sink.add(dependentsResponse);
  }
  dispose() {
    _allDependentsFetcher.close();
  }
}
final dependentsBloc = DependentsBloc();

class DependentsRepository {
  DependentsApiProvider appApiProvider = DependentsApiProvider();
  Future<List<DependentsModel>> fetchDependents(String national_id, authToken) =>
      appApiProvider.fetchDependents(national_id, authToken);
}

class DependentsApiProvider {
  Client client = Client();
  Future<List<DependentsModel>> fetchDependents(String national_id, authToken) async {
    final response = await client.get(Uri.parse(
      "https://mobilehali.tenwebtechnologies.com/api/patient/dependent/$national_id"),
      headers: {'Authorization': 'Bearer $authToken'}
    );
    var data = json.decode(response.body);
    // print(data['date']);
    if (response.statusCode == 200) {
      return featuredFromJson(json.encode(data['date']));
    } else {
      throw Exception('Failed to load Featured');
    }
  }
}