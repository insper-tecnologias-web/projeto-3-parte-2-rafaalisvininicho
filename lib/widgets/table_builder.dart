import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:projeto/extensions.dart';

class TableBuilder extends StatelessWidget {
  const TableBuilder(
      {super.key,
      required this.headerRow,
      required this.rowBuilder,
      required this.rowCount,
      this.headerGap = 8.0,
      this.rowGap = 8.0,
      required this.columnWidths});

  final List<String> headerRow;
  final double headerGap;
  final double rowGap;
  final int rowCount;
  final Map<int, TableColumnWidth> columnWidths;
  final TableRow Function(BuildContext context, int index) rowBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: SmoothBorderRadius.all(
          SmoothRadius(
            cornerRadius: 8.0,
            cornerSmoothing: 0.6,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromARGB(24, 0, 0, 0),
            offset: Offset(0.0, 4.0),
            blurRadius: 20.0,
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 8.0,
      ),
      child: Column(
        children: [
          Table(
            columnWidths: columnWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                children: <Widget>[
                  for (var row in headerRow)
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        row,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )),
                ],
              ),
              TableRow(children: [
                for (var _ in headerRow) SizedBox(height: headerGap)
              ]),
              ...buildTableRows(context),
            ],
          ),
        ],
      ),
    ).withPadding(
      const EdgeInsets.only(top: 32.0),
    );
  }

  List<TableRow> buildTableRows(BuildContext context) {
    return List<TableRow>.generate(
        2 * rowCount,
        (int index) => index % 2 == 0
            ? rowBuilder(context, index ~/ 2)
            : TableRow(
                children: [for (var _ in headerRow) SizedBox(height: rowGap)]));
  }
}
