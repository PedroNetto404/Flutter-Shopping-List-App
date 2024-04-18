import 'package:file_saver/file_saver.dart';
import 'package:mobile_shopping_list_app/constants/shopping-list-pdf-model.dart';
import 'package:pdf/widgets.dart';

import '../models/models.dart';


class ExportService {
  final FileSaver _fileSaver = FileSaver.instance;

  Future<String> exportListInPDF(ShoppingList list) async {
    final doc = Document();
    doc.addPage(MultiPage(
        build: (Context context) => [ShoppingListPdfModel(list: list)]));

    final docBytes = await doc.save();

    return await _fileSaver.saveFile(
        name: '${list.name}_${list.id}}',
        bytes: docBytes,
        mimeType: MimeType.pdf,
        ext: 'pdf');
  }
}
