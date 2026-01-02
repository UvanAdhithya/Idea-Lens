import 'package:hive/hive.dart';
import 'project_history.dart';

class ProjectHistoryAdapter extends TypeAdapter<ProjectHistory> {
  @override
  final int typeId = 0;

  @override
  ProjectHistory read(BinaryReader reader) {
    return ProjectHistory(
      imagePath: reader.readString(),
      detectedObjects: reader.readList().cast<String>(),
      selectedProject: reader.readString(),
      difficulty: reader.readString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        reader.readInt(),
      ),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectHistory obj) {
    writer.writeString(obj.imagePath);
    writer.writeList(obj.detectedObjects);
    writer.writeString(obj.selectedProject);
    writer.writeString(obj.difficulty);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}

