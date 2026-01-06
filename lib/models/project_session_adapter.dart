import 'package:hive/hive.dart';
import 'project_session.dart';

class ProjectSessionAdapter extends TypeAdapter<ProjectSession> {
  @override
  final int typeId = 11; // Increased TypeID

  @override
  ProjectSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return ProjectSession(
      projectId: fields[0] as String,
      projectTitle: fields[1] as String,
      currentStepIndex: fields[2] as int,
      totalSteps: fields[3] as int,
      imagePath: fields[4] as String?,
      difficulty: fields[5] as String,
      lastUpdated: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectSession obj) {
    writer.writeByte(7); // Number of fields

    writer.writeByte(0);
    writer.write(obj.projectId);

    writer.writeByte(1);
    writer.write(obj.projectTitle);

    writer.writeByte(2);
    writer.write(obj.currentStepIndex);

    writer.writeByte(3);
    writer.write(obj.totalSteps);

    writer.writeByte(4);
    writer.write(obj.imagePath);

    writer.writeByte(5);
    writer.write(obj.difficulty);

    writer.writeByte(6);
    writer.write(obj.lastUpdated);
  }
}
