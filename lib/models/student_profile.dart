class StudentProfile {
  final String id;
  final String uniqId;
  final String fullName;
  final String contactMobile;
  final String imageUrl;

  final String sectionName;
  final String className;
  final String groupName;
  final String mediumName;
  final String shiftName;
  final String branchName;
  final String instituteName;

  StudentProfile({
    required this.id,
    required this.uniqId,
    required this.fullName,
    required this.contactMobile,
    required this.imageUrl,
    required this.sectionName,
    required this.className,
    required this.groupName,
    required this.mediumName,
    required this.shiftName,
    required this.branchName,
    required this.instituteName,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['_id'] ?? '',
      uniqId: json['_uniq_id'] ?? '',
      fullName: json['_full_name'] ?? '',
      contactMobile: json['_contact_mobile'] ?? '',
      imageUrl: json['_image_location'] ?? '',
      sectionName: json['_st_name'] ?? '',
      className: json['_cl_name'] ?? '',
      groupName: json['_dp_name'] ?? '',
      mediumName: json['_me_name'] ?? '',
      shiftName: json['_sh_name'] ?? '',
      branchName: json['_br_name'] ?? '',
      instituteName: json['_ins_name'] ?? '',
    );
  }
}
