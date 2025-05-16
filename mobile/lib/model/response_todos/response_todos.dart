import 'dart:convert';

import 'datum.dart';

class ResponseTodos {
  String? message;
  List<Datum>? data;

  ResponseTodos({this.message, this.data});

  @override
  String toString() => 'ResponseTodos(message: $message, data: $data)';

  factory ResponseTodos.fromMap(Map<String, dynamic> data) => ResponseTodos(
    message: data['message'] as String?,
    data:
        (data['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toMap() => {
    'message': message,
    'data': data?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResponseTodos].
  factory ResponseTodos.fromJson(String data) {
    return ResponseTodos.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ResponseTodos] to a JSON string.
  String toJson() => json.encode(toMap());

  ResponseTodos copyWith({String? message, List<Datum>? data}) {
    return ResponseTodos(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
