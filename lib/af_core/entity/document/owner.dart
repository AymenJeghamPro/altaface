
class Owner {
  late String id;
  late String type;
  late String teamId;
  late String weeklyScheduleId;
  late String firstName;
  late String lastName;
  late String username;
  late bool isLocalized;
  late String storeId;
  late bool isArchived;
  late String avatar;

  Owner(
      {required this.id,
        required this.type,
        required this.teamId,
        required this.weeklyScheduleId,
        required this.firstName,
        required this.lastName,
        required this.username,
        required this.isLocalized,
        required this.storeId,
        required this.isArchived,
        required this.avatar});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    teamId = json['team_id'];
    weeklyScheduleId = json['weekly_schedule_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    isLocalized = json['is_localized'];
    storeId = json['store_id'];
    isArchived = json['is_archived'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['team_id'] = this.teamId;
    data['weekly_schedule_id'] = this.weeklyScheduleId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['is_localized'] = this.isLocalized;
    data['store_id'] = this.storeId;
    data['is_archived'] = this.isArchived;
    data['avatar'] = this.avatar;
    return data;
  }
}