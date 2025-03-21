import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CounterTableScreen extends StatefulWidget {
  @override
  _CounterTableScreenState createState() => _CounterTableScreenState();
}

class _CounterTableScreenState extends State<CounterTableScreen> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  List<PlutoColumnGroup> columnGroups = [];
  bool isLoading = true;

  String selectedLine = "A";
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<List<Map<String, dynamic>>> fetchCounterData(String line, String date) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference counterRef = firestore.collection('counter_sistem').doc(line).collection(date);

    QuerySnapshot snapshot = await counterRef.get();

    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((doc) {
      String processName = doc.id;
      Map<String, dynamic> processData = {"process_name": processName};
      Map<String, dynamic>? timeData = doc.data() as Map<String, dynamic>?;

      if (timeData != null) {
        for (String time in ["07:30", "08:30", "09:30", "10:30", "11:30", "13:30", "14:30", "15:30", "16:30"]) {
          if (timeData.containsKey(time) && timeData[time] is Map) {
            for (int i = 1; i <= 5; i++) {
              processData["${time}_$i"] = timeData[time]["$i"] ?? 0;
            }
          }
        }
      }
      return processData;
    }).toList();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    String formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate);
    List<Map<String, dynamic>> data = await fetchCounterData(selectedLine, formattedDate);

    List<String> timeSlots = ["07:30", "08:30", "09:30", "10:30", "11:30", "13:30", "14:30", "15:30", "16:30"];

    columns = [
      PlutoColumn(
        title: "PROCESS",
        field: "process_name",
        type: PlutoColumnType.text(),
        width: 120,
        titleTextAlign: PlutoColumnTextAlign.center,
        backgroundColor: Colors.blue.shade200,
        enableColumnDrag: false, // Hilangkan ikon garis tiga
        enableContextMenu: false,
        // enableDropToResize: false,
        enableSorting: false,
      ),
    ];

    columnGroups = [];

    for (String time in timeSlots) {
      for (int i = 1; i <= 5; i++) {
        columns.add(PlutoColumn(
          title: "$i",
          field: "${time}_$i",
          type: PlutoColumnType.number(),
          width: 40,
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          backgroundColor: Colors.blue.shade100,
          enableColumnDrag: false, // Hilangkan ikon garis tiga
          enableContextMenu: false,
          enableDropToResize: false,
          enableSorting: false,
          cellPadding: EdgeInsets.all(1.0),
        ));
      }
      columns.add(
        PlutoColumn(
          title: "Total",
          field: "${time}_total",
          type: PlutoColumnType.number(),
          width: 60,
          titleTextAlign: PlutoColumnTextAlign.center,
          textAlign: PlutoColumnTextAlign.center,
          backgroundColor: Colors.yellow.shade200,
          enableColumnDrag: false, // Hilangkan ikon garis tiga
          enableContextMenu: false,
          enableDropToResize: false,
          enableSorting: false,
          cellPadding: EdgeInsets.all(1.0),
          renderer: (rendererContext) {
            return Container(
              color: Colors.yellow.shade100, // Warna untuk seluruh sel
              alignment: Alignment.center,
              child: Text(rendererContext.cell.value.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            );
          },
        ),
      );

      columnGroups.add(
        PlutoColumnGroup(
          title: time,
          backgroundColor: Colors.blue.shade200,
          fields: [
            "${time}_1",
            "${time}_2",
            "${time}_3",
            "${time}_4",
            "${time}_5",
            "${time}_total"
          ],
        ),
      );
    }

    columns.add(
      PlutoColumn(
        title: "GRAND TOTAL",
        field: "grand_total",
        type: PlutoColumnType.number(),
        width: 120,
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        backgroundColor: Colors.orange.shade300,
        enableColumnDrag: false, // Hilangkan ikon garis tiga
        enableContextMenu: false,
        enableDropToResize: false,
        enableSorting: false,
        cellPadding: EdgeInsets.all(1.0),
        renderer: (rendererContext) {
            return Container(
              color: Colors.orange.shade200, // Warna untuk seluruh sel
              alignment: Alignment.center,
              child: Text(rendererContext.cell.value.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            );
          },
      ),
    );

    rows = data.map((entry) {
      Map<String, PlutoCell> cells = {
        "process_name": PlutoCell(value: entry["process_name"]),
      };

      int grandTotal = 0;

      for (String time in timeSlots) {
        int total = 0;

        for (int i = 1; i <= 5; i++) {
          int count = entry["${time}_$i"] ?? 0;
          total += count;
          cells["${time}_$i"] = PlutoCell(value: count);
        }

        grandTotal += total;
        cells["${time}_total"] = PlutoCell(value: total);
      }

      cells["grand_total"] = PlutoCell(value: grandTotal);

      return PlutoRow(cells: cells);
    }).toList();

    setState(() => isLoading = false);
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Stock Kumitate per Process",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blueAccent.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 4, // Memberikan efek shadow di bawah AppBar
        actions: [
           // Menambah jarak dari sisi kanan sebelum tombol
          IconButton(
            icon: Icon(Icons.refresh, size: 26, color: Colors.white),
            tooltip: "Refresh Data",
            onPressed: () => loadData(),
            splashRadius: 24, // Efek hover saat ditekan
          ),
          SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue.shade500, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedLine,
                      items: ["A", "B", "C", "D", "E"]
                          .map((line) => DropdownMenuItem(
                                value: line,
                                child: Text(
                                  "Line $line",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedLine = value!);
                        loadData();
                      },
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade600, size: 24),
                      style: TextStyle(color: Colors.black),
                      dropdownColor: Colors.white, 
                      borderRadius: BorderRadius.circular(5), // Membuat sudut lebih halus
                      menuMaxHeight: 250, // Membatasi tinggi dropdown agar tidak terlalu panjang
                      menuWidth: 96,
                    ),
                  ),
                ),
                
                TextButton.icon(
                  icon: Icon(Icons.calendar_today, size: 18),
                  label: Text(DateFormat("yyyy-MM-dd").format(selectedDate)),
                  onPressed: () => selectDate(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : rows.isEmpty
                    ? Center(child: Text("No Data Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                    : Padding(
                        // padding: const EdgeInsets.all(4.0),
                        padding: EdgeInsets.only(left: 8.0, right: 4.0),
                        child: PlutoGrid(
                          columns: columns,
                          rows: rows,
                          columnGroups: columnGroups,
                          configuration: PlutoGridConfiguration(
                            style: PlutoGridStyleConfig(
                              gridBackgroundColor: Colors.white, // Warna background tabel
                              rowColor: Colors.blue.shade50,
                              borderColor: Colors.blue.shade800,
                              rowHeight: 30,
                              columnHeight: 30,
                              cellTextStyle: TextStyle(fontSize: 12),
                              
                            ),
                          ),
                          mode: PlutoGridMode.readOnly,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
