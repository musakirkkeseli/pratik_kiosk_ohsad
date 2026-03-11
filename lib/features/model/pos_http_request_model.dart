class PosHttpRequestModel {
  String? version;
  String? requestId;
  String? correlationId;
  String? kioskId;
  int? timeoutMs;
  String? operation;
  Pos? pos;
  Map<String, dynamic>? payload;

  PosHttpRequestModel({
    this.version,
    this.requestId,
    this.correlationId,
    this.kioskId,
    this.timeoutMs,
    this.operation,
    this.pos,
    this.payload,
  });

  PosHttpRequestModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    requestId = json['requestId'];
    correlationId = json['correlationId'];
    kioskId = json['kioskId'];
    timeoutMs = json['timeoutMs'];
    operation = json['operation'];
    pos = json['pos'] != null ? Pos.fromJson(json['pos']) : null;
    payload = json['payload'] != null
        ? Map<String, dynamic>.from(json['payload'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['requestId'] = requestId;
    data['correlationId'] = correlationId;
    data['kioskId'] = kioskId;
    data['timeoutMs'] = timeoutMs;
    data['operation'] = operation;
    if (pos != null) {
      data['pos'] = pos!.toJson();
    }
    if (payload != null) {
      data['payload'] = payload;
    }
    return data;
  }
}

class Pos {
  String? vendor;
  String? protocol;
  String? baseUrl;
  String? path;
  String? method;
  Map<String, dynamic>? headers;

  Pos({
    this.vendor,
    this.protocol,
    this.baseUrl,
    this.path,
    this.method,
    this.headers,
  });

  Pos.fromJson(Map<String, dynamic> json) {
    vendor = json['vendor'];
    protocol = json['protocol'];
    baseUrl = json['baseUrl'];
    path = json['path'];
    method = json['method'];
    headers = json['headers'] != null
        ? Map<String, dynamic>.from(json['headers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor'] = vendor;
    data['protocol'] = protocol;
    data['baseUrl'] = baseUrl;
    data['path'] = path;
    data['method'] = method;
    if (headers != null) {
      data['headers'] = headers;
    }
    return data;
  }
}
