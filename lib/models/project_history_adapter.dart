import 'package:hive/hive.dart';
import 'project_history.dart';

class ProjectHistoryAdapter extends TypeAdapter<ProjectHistory> {
  @override
  final int typeId = 10; // Increased TypeID

  @override
  ProjectHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return ProjectHistory(
      imagePath: fields[0] as String?,
      detectedObjects: (fields[1] as List?)?.cast<String>(),
      selectedProject: (fields[2] as String?) ?? 'Unknown',
      difficulty: (fields[3] as String?) ?? 'Unknown',
      createdAt: (fields[4] as DateTime?) ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectHistory obj) {
    writer.writeByte(5); // Number of fields
    
    writer.writeByte(0);
    writer.write(obj.imagePath);
    
    writer.writeByte(1);
    writer.write(obj.detectedObjects);
    
    writer.writeByte(2);
    writer.write(obj.selectedProject);
    
    writer.writeByte(3);
    writer.write(obj.difficulty);
    
    writer.writeByte(4);
    writer.write(obj.createdAt); // Hive handles DateTime directly
  }
}

