class ResponseModel {
  final bool status;
  final String message;
  var data;

  ResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  // Convert a ResponseModel object into a map to serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }

  // Create a ResponseModel object from a JSON map
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}
