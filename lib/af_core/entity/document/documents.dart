import 'owner.dart';

class Dokuments {
  late String id;
  late String updatedAt;
  late String label;
  late String? annotation;
  late int order;
  late int downloadCount;
  late String file;
  late String fileSize;
  late String fileContentType;
  late String thumb;
  late String small;
  late String relatedObjectId;
  late String relatedObjectType;
  late String createdAt;
  late Owner owner;
  late String? parentId;
  late bool isArchived;
  late bool isSystem;

  Dokuments(
      {required this.id,
        required this.updatedAt,
        required this.label,
        this.annotation,
        required this.order,
        required this.downloadCount,
        required this.file,
        required this.fileSize,
        required this.fileContentType,
        required this.thumb,
        required this.small,
        required this.relatedObjectId,
        required this.relatedObjectType,
        required this.createdAt,
        required this.owner,
        this.parentId,
        required this.isArchived,
        required this.isSystem});

  Dokuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedAt = json['updated_at'];
    label = json['label'];
    annotation = json['annotation'];
    order = json['order'];
    downloadCount = json['download_count'];
    file = json['file'];
    fileSize = json['file_size'];
    fileContentType = json['file_content_type'];
    thumb = json['thumb'];
    small = json['small'];
    relatedObjectId = json['related_object_id'];
    relatedObjectType = json['related_object_type'];
    createdAt = json['created_at'];
    owner = (json['owner'] != null ? Owner.fromJson(json['owner']) : null)!;
    parentId = json['parent_id'];
    isArchived = json['is_archived'];
    isSystem = json['is_system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['label'] = label;
    data['annotation'] = annotation;
    data['order'] = order;
    data['download_count'] = downloadCount;
    data['file'] = file;
    data['file_size'] = fileSize;
    data['file_content_type'] = fileContentType;
    data['thumb'] = thumb;
    data['small'] = small;
    data['related_object_id'] = relatedObjectId;
    data['related_object_type'] = relatedObjectType;
    data['created_at'] = createdAt;
    data['owner'] = owner.toJson();
    data['parent_id'] = parentId;
    data['is_archived'] = isArchived;
    data['is_system'] = isSystem;
    return data;
  }
}