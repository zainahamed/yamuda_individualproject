class Message {
  String _messageId = "null";
  String _senderId = "";
  String _senderEmail = "";
  String _senderUserName = "";
  String _timeSpan = "null";
  String _content = "null";

  Message(this._messageId, this._senderId, this._senderEmail,
      this._senderUserName, this._timeSpan, this._content);

  String get messageId => _messageId;
  set messageId(String value) => _messageId = value;

  String get senderId => _senderId;

  set senderId(String value) {
    _senderId = value;
  }

  String get senderEmail => _senderEmail;

  set senderEmail(String value) {
    _senderEmail = value;
  }

  String get timeSpan => _timeSpan;
  set timeSpan(String value) => _timeSpan = value;

  String get content => _content;
  set content(String value) => _content = value;

  //Map message to database
  Map<String, dynamic> toMap() {
    return {
      'messageId': _messageId,
      'content': _content,
      'senderUserName': _senderUserName,
      'timeSpan': _timeSpan,
      'senderId': _senderId,
      'senderEmail': _senderEmail,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      map['messageId'],
      map['senderId'],
      map['senderEmail'],
      map['senderUserName'],
      map['timeSpan'],
      map['content'],
    );
  }
}
