import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<String?> pickFile({List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );
    return result?.files.single.path;
  }
}