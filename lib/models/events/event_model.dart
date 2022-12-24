

class event_model {
  String? image;
  String date;
  String location;
  bool isSuper;
  int price;
  int event_id;
  String eventType;

  event_model({ this.image, required this.date,
      required this.location, required this.price, required this.event_id, required this.eventType,required this.isSuper});
fromMap(Map<String, dynamic> map) {
    image = map['image'];
    date = map['Date'];
    location = map['Location'];
    isSuper = map['IsSuper'];
    price = map['Price'];
    event_id = map['EventId'];
    eventType = map['EventType'];}
  toMap(Map<String, dynamic> data) {
    return {

      'Date': date,
      'Location': location,
      'Price': price,
      'EventId': event_id,
      'EventType': eventType,
      'IsSuper': isSuper
    };
  }


}