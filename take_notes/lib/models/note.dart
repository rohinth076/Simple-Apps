class Note{
  int _id;
  String _title;
  String _date;
  String _description;

  Note(this._title, this._date, [this._description=""]);
  Note.byId(this._id,this._title, this._date, [this._description=""]);


  int get id => _id;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }


  Map<String,dynamic> toMap(){
    var map =  Map<String,dynamic>();
    if(_id == null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    return map;
  }

//description
  Note.toObject( Map<String,dynamic> map){
    _id = map['id'];
    _date = map['date'];
    _title = map['title'];
    _description = map['description'];
  }
}