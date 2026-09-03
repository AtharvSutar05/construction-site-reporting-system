enum ReportStatus {
  draft,
  submitted,
  approved,
  rejected;

  static ReportStatus fromString(String? status) {
    switch(status) {
      case 'draft':
        return ReportStatus.draft;
      case 'submitted':
        return ReportStatus.submitted;
      case 'approved':
        return ReportStatus.approved;
      case 'rejected':
        return ReportStatus.rejected;
      default:
        return ReportStatus.submitted;
    }
  }

  String toJson() {
    switch(this) {
      case ReportStatus.draft:
        return "draft";
      case ReportStatus.submitted:
        return "submitted";
      case ReportStatus.approved:
        return "approved";
      case ReportStatus.rejected:
        return "rejected";
    }
  }

}

extension ReportStatusExtension on ReportStatus {
  String get displayName {
    switch(this) {
      case ReportStatus.draft:
        return "Draft";
      case ReportStatus.submitted:
        return "Submitted";
      case ReportStatus.approved:
        return "Approved";
      case ReportStatus.rejected:
        return "Rejected";
    }
  }
}