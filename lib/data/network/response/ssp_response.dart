class SspResponse {
  bool state;
  String message;
  List<SspModel>? data;

  SspResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory SspResponse.fromJson(Map<String, dynamic>json){
    return SspResponse(
      state: json['state'], 
      message: json['message'],
      data: List<SspModel>.from(
        (json['data'] as List).map((x) => SspModel.fromJson(x))
      )
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
  DateTime confirmDate;
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
      genderAnak: json['jenis_kelamin'], 
      urutanAnak: json['child_queue'], 
      hubunganKeluarga: json['hubungan']??'', 
      namaAlmarhum: json['alm_name']??'', 
      tanggalMeninggal: DateTime.parse(json['passed_date']), 
      note: json['notes']??'',
      state: json['status'],
      type: json['type'],
      sumbangan: json['sumbangan'],
      pdf: json['pdf']??'',
      rejectComment: json['reject_comment']??'', 
      releaseDate: DateTime.parse(json['release_date']), 
      confirmDate: DateTime.parse(json['confirm_date']), 
      confirmer: json['confirm_by'], 
      // editable: json['editable'], 
      editable: true, 
      cancelable: json['cancellable']
    );
  }
}