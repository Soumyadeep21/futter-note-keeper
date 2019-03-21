 class Note{

  int _id , _priority;
  String _title , _description , _date ;
  Note(this._title,this._date,this._priority,[this._description]);
  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  set title(String newTitle){
    if(newTitle.length <= 50)
      this._title = newTitle;
  }
  set description(String newDescription){
    if(newDescription.length <= 300)
      this._description = newDescription;
  }
  set priority(int newPriority){
    if(newPriority >= 1 && newPriority <= 3)
      this._priority = newPriority;
  }
  set date(String newDate){
    this._date  = newDate;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(_id != null)
      map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  Note.fromMapObject(Map<String , dynamic> map){
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _date = map['date'];
  }
 }