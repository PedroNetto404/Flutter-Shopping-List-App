import 'package:pdf/widgets.dart';
import '../models/models.dart';
import '../extensions/extensions.dart';

class ShoppingListPdfModel extends StatelessWidget {
  final ShoppingList list;

  ShoppingListPdfModel({required this.list});

  @override
  Widget build(Context context) => Container(
      padding: const EdgeInsets.all(16),
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Align(
                  child: Text(list.name, style: const TextStyle(fontSize: 24)),
                  alignment: Alignment.centerLeft),
              Divider(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _info('Criada em: ', list.createdAt.toSouthAmericaFormat()),
                _info('Total de itens: ', list.items.length.toString()),
                _info('Valor total: ', list.totalPrice?.toCurrency() ?? '...')
              ]),
              Divider(),
              Table(border: TableBorder.all(), children: [
                TableRow(children: [
                  _header('Comprado?'),
                  _header('Nome'),
                  _header('Quantidade'),
                  _header('Price'),
                  _header('Preço Total')
                ]),
                ...list.items.map((item) => TableRow(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          _rowCell(item.purchased ? 'Sim' : 'Não'),
                          _rowCell(item.name),
                          _rowCell(item.quantity.toString()),
                          _rowCell(item.price?.toCurrency() ?? '...'),
                          _rowCell(item.totalPrice?.toCurrency() ?? '...'),
                        ]))
              ])
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _boldText('Listify'),
              Spacer(),
              _boldText('Sua lista de compras'),
            ])
          ])));

  Widget _header(String text) =>
      Padding(padding: const EdgeInsets.all(16), child: _boldText(text));

  Widget _rowCell(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(text));

  Widget _info(String header, String info) => Row(
        children: [
          _boldText(header),
          Text(info),
        ],
      );

  Widget _boldText(String text) =>
      Text(text, style: TextStyle(fontWeight: FontWeight.bold));
}
