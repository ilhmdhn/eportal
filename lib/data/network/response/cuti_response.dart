class CutiResponse{
  bool state;
  String message;
  CutiDetail? data;

  CutiResponse({
    this.state = false,
    this.message = 'Failed',
    this.data
  });

  factory CutiResponse.fromJson(Map<String, dynamic>json){
    return CutiResponse(
      state: json['state'],
      message: json['message'],
      data: CutiDetail.fromJson(json['data'])
    );
  }
}

class CutiDetail{
  int cutiRemaining;
  int cutiNextYearReamining;
  List<CutiListModel>? listCuti;

  CutiDetail({
    this.cutiRemaining = 0,
    this.cutiNextYearReamining = 0,
    this.listCuti
  });

  factory CutiDetail.fromJson(Map<String, dynamic>json){
    return CutiDetail(
      cutiRemaining: json['sisa_cuti_tahun_ini'],
      cutiNextYearReamining: json['sisa_cuti_tahun_depan'],
      listCuti: List<CutiListModel>.from(
        (json['list'] as List).map((x) => CutiListModel.fromJson(x))
      )
    );
  }
}

class CutiListModel{
  String id;
  String year;
  String nip;
  String name;
  DateTime startCuti;
  DateTime endCuti;
  DateTime requestDate;
  int day;
  int state;
  String rejectReason;
  String cutiReason;

  CutiListModel({
    this.id = '001',
    this.year = '1970',
    this.nip = '1',
    this.name = 'no name',
    DateTime? startCuti,
    DateTime? endCuti,
    DateTime? requestDate,
    this.day = 1,
    this.state = 1,
    this.rejectReason = '',
    this.cutiReason = '',
  })  : startCuti = startCuti ?? DateTime.parse('1970-01-01'),
        endCuti = endCuti ?? DateTime.parse('1970-01-01'),
        requestDate = requestDate?? DateTime.parse('1970-01-01')
        ;

  factory CutiListModel.fromJson(Map<String, dynamic>json){
    return CutiListModel(
      id: json['ID'],
      year: json['Year'],
      nip: json['NIP'],
      name: json['Name'],
      startCuti: DateTime.parse(json['StartDate']),
      endCuti: DateTime.parse(json['EndDate']),
      requestDate: DateTime.parse(json['RequestDate']),
      day: json['Day']??1,
      state: json['Status']??3,
      rejectReason: json['RejectComment']??'',
      cutiReason: json['Alasan']??'',
    );
  }
}