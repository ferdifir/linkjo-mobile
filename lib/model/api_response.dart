class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var status = json['success'].toString().toLowerCase();
    var success = status == 'true';
    return ApiResponse(
      success: success,
      message: json['message'],
      data: json['data'],
    );
  }
}
