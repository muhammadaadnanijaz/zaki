
class CardModel {
  CardModel({
    required this.createdTime,
    required this.lastModifiedTime,
    required this.token,
    required this.userToken,
    required this.cardProductToken,
    required this.lastFour,
    required this.pan,
    required this.expiration,
    required this.expirationTime,
    required this.barcode,
    required this.pinIsSet,
    required this.state,
    required this.stateReason,
    required this.fulfillmentStatus,
    required this.instrumentType,
    required this.expedite,
    required this.metadata,
  });
  late final String createdTime;
  late final String lastModifiedTime;
  late final String token;
  late final String userToken;
  late final String cardProductToken;
  late final String lastFour;
  late final String pan;
  late final String expiration;
  late final String expirationTime;
  late final String barcode;
  late final bool pinIsSet;
  late final String state;
  late final String stateReason;
  late final String fulfillmentStatus;
  late final String instrumentType; 
  late final bool expedite;
  late final Metadata metadata;
  
  CardModel.fromJson(Map<String, dynamic> json){
    createdTime = json['created_time'];
    lastModifiedTime = json['last_modified_time'];
    token = json['token'];
    userToken = json['user_token'];
    cardProductToken = json['card_product_token'];
    lastFour = json['last_four'];
    pan = json['pan'];
    expiration = json['expiration'];
    expirationTime = json['expiration_time'];
    barcode = json['barcode'];
    pinIsSet = json['pin_is_set'];
    state = json['state'];
    stateReason = json['state_reason'];
    fulfillmentStatus = json['fulfillment_status'];
    instrumentType = json['instrument_type'];
    expedite = json['expedite'];
    metadata = Metadata.fromJson(json['metadata']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['created_time'] = createdTime;
    _data['last_modified_time'] = lastModifiedTime;
    _data['token'] = token;
    _data['user_token'] = userToken;
    _data['card_product_token'] = cardProductToken;
    _data['last_four'] = lastFour;
    _data['pan'] = pan;
    _data['expiration'] = expiration;
    _data['expiration_time'] = expirationTime;
    _data['barcode'] = barcode;
    _data['pin_is_set'] = pinIsSet;
    _data['state'] = state;
    _data['state_reason'] = stateReason;
    _data['fulfillment_status'] = fulfillmentStatus;
    _data['instrument_type'] = instrumentType;
    _data['expedite'] = expedite;
    _data['metadata'] = metadata.toJson();
    return _data;
  }
}

class Metadata {
  Metadata();
  
  Metadata.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}