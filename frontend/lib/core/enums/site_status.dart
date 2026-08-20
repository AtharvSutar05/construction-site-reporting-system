enum SiteStatus {
  active,
  onHold,
  completed,
  archived;

  static SiteStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return SiteStatus.active;
      case 'on_hold':
        return SiteStatus.onHold;
      case 'completed':
        return SiteStatus.completed;
      case 'archived':
        return SiteStatus.archived;
      default:
        return SiteStatus.active;
    }
  }

  String toJson() {
    switch (this) {
      case SiteStatus.active:
        return 'active';
      case SiteStatus.onHold:
        return 'on_hold';
      case SiteStatus.completed:
        return 'completed';
      case SiteStatus.archived:
        return 'archived';
    }
  }
}

extension SiteStatusExtension on SiteStatus {
  String get displayName {
    switch (this) {
      case SiteStatus.active:
        return 'Active';
      case SiteStatus.onHold:
        return 'On Hold';
      case SiteStatus.completed:
        return 'Completed';
      case SiteStatus.archived:
        return 'Archived';
    }
  }
}