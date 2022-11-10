class Request {
  String requestId;
  String method;
  List<dynamic>? params;

  Request(this.requestId, this.method, this.params);
}
