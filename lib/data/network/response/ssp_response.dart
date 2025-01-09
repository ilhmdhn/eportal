class SspResponse {
  bool state;
  String message;
  SspValue? value;
  List<SspModel>? data;

  SspResponse({
    required this.state,
    required this.message,
    this.value,
    this.data
  });

  factory SspResponse.fromJson(Map<String, dynamic>json){
    return SspResponse(
      state: json['state'], 
      message: json['message'],
      value: SspValue.fromJson(json['donation']),
      data: List<SspModel>.from(
        (json['data'] as List).map((x) => SspModel.fromJson(x))
      )
    );
  }
}

class SspValue{
  num typeSatu;
  num typeDua;
  num typeTiga;
  num typeEmpat;

  SspValue({
    required this.typeSatu,
    required this.typeDua,
    required this.typeTiga,
    required this.typeEmpat,
  });

  factory SspValue.fromJson(Map<String, dynamic>json){
    return SspValue(
      typeSatu: json['type1'], 
      typeDua: json['type2'], 
      typeTiga: json['type3'], 
      typeEmpat: json['type4']
    );
  }
}

class SspModel{
  String id;
  String name;
  String aktaLahir;
  String aktaAnak;
  String bukuNikah;
  String suratKemation;
  String kartuKeluarga;
  String namaPasangan;
  String namaAnak;
  int genderAnak;
  int urutanAnak;
  String hubunganKeluarga;
  String namaAlmarhum;
  DateTime tanggalMeninggal;
  String note;
  int state;
  DateTime releaseDate;
  DateTime? confirmDate;
  String confirmer;
  int type;
  num sumbangan;
  String pdf;
  String rejectComment;
  bool editable;
  bool cancelable;

  SspModel({
    required this.id,
    required this.name,
    required this.aktaLahir,
    required this.aktaAnak,
    required this.bukuNikah,
    required this.suratKemation,
    required this.kartuKeluarga,
    required this.namaPasangan,
    required this.namaAnak,
    required this.genderAnak,
    required this.urutanAnak,
    required this.hubunganKeluarga,
    required this.namaAlmarhum,
    required this.tanggalMeninggal,
    required this.note,
    required this.state,
    required this.type,
    required this.sumbangan,
    required this.pdf,
    required this.rejectComment,
    required this.releaseDate,
    required this.confirmDate,
    required this.confirmer,
    required this.editable,
    required this.cancelable,
  });

  factory SspModel.fromJson(Map<String, dynamic>json){
    return SspModel(
      id: json['id'], 
      name: json['name'], 
      aktaLahir: json['akta_lahir']??'', 
      aktaAnak: json['akta_anak']??'', 
      bukuNikah: json['surat_nikah']??'', 
      suratKemation: json['surat_kematian']??'', 
      kartuKeluarga: json['kartu_keluarga']??'', 
      namaPasangan: json['marital_name']??'', 
      namaAnak: json['child_name']??'', 
      genderAnak: json['jenis_kelamin']??0,
      urutanAnak: json['child_queue']??1, 
      hubunganKeluarga: json['hubungan']??'', 
      namaAlmarhum: json['alm_name']??'', 
      tanggalMeninggal: json['passed_date'] != null?DateTime.parse(json['passed_date']): DateTime.now(), 
      note: json['notes']??'',
      state: json['status'],
      type: json['type'],
      sumbangan: json['sumbangan']??0,
      pdf: json['pdf']??'',
      rejectComment: json['reject_comment']??'', 
      releaseDate: json['release_date'] != null?DateTime.parse(json['release_date']): DateTime.now(), 
      confirmDate: json['confirm_date'] != null?DateTime.parse(json['confirm_date']): DateTime.now(), 
      confirmer: json['confirm_by']??'',
      editable: json['editable'], 
      cancelable: json['cancellable']
    );
  }
}