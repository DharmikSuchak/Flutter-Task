class GetSampleApi {
  int? serialNo;
  String? name;
  String? dateOfJoining;

  GetSampleApi({this.serialNo, this.name, this.dateOfJoining});

  GetSampleApi.fromJson(Map<String, dynamic> json) {
    serialNo = json['Serial_no'];
    name = json['Name'];
    dateOfJoining = json['Date_of_joining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Serial_no'] = this.serialNo;
    data['Name'] = this.name;
    data['Date_of_joining'] = this.dateOfJoining;
    return data;
  }
}