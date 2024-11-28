class AttendanceListResponse{
  bool state;
  String message;
  List<AttendanceListModel> listAbsen;

  AttendanceListResponse({
    required this.state,
    required this.message,
    required this.listAbsen,
  });

  factory AttendanceListResponse.fromJson(Map<String, dynamic>json){
    if(json['state'] != true){
      throw json['message'];
    }
    return AttendanceListResponse(
      state: json['state'], 
      message: json['message'], 
      listAbsen: List<AttendanceListModel>.from(
        (json['data'] as List).map((x) => AttendanceListModel.fromJson(x)))
      );
  }
}

class AttendanceListModel{
  String nip;
  String name;
  String? date;
  String? jko;
  String? arrivalSchedule;
  String? arrived;
  String? leaveSchedule;
  String? leaved;
  String? arrivalDescription;
  String? leaveDescription;

  AttendanceListModel({
    required this.nip,
    required this.name,
    this.date,
    this.jko,
    this.arrivalSchedule,
    this.arrived,
    this.leaveSchedule,
    this.leaved,
    this.arrivalDescription,
    this.leaveDescription,
  });

  factory AttendanceListModel.fromJson(Map<String, dynamic>json){
    return AttendanceListModel(
      nip: json['nip'],
      name: json['name'],
      date: json['tanggal'],
      jko: json['jko'],
      arrivalSchedule: json['jadwal_datang'],
      arrived: json['datang'],
      leaveSchedule: json['jadwal_pulang'],
      leaved: json['pulang'],
      arrivalDescription: json['keterangan_datang'],
      leaveDescription: json['keterangan_pulang'],
    );
  }
}