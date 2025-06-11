import 'package:flutter/material.dart';
import 'dart:io'; // Wajib untuk akses file
import 'package:path_provider/path_provider.dart'; // Untuk direktori aplikasi
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // Library PDF
import 'package:provider/provider.dart';

// Provider
import '../providers/cart_provider.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  Future<void> _generateAndSaveInvoice(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (cart.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Keranjang kosong!")),
      );
      return;
    }

    final pdf = pw.Document();

    // Buat PDF content
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Text("Invoice", style: pw.TextStyle(fontSize: 24))),
          pw.Paragraph(text: "Tanggal: ${DateTime.now().toString()}"),
          pw.Table.fromTextArray(
            headers: ['Nama', 'Harga Satuan', 'QTY', 'Total'],
            data: [
              for (var item in cart.cartItems)
                [
                  item.name,
                  'Rp. ${item.price}',
                  '${item.quantity}',
                  'Rp. ${item.getTotalPrice()}',
                ],
              ['Total Bayar', '', '', 'Rp. ${cart.totalHarga.toStringAsFixed(0)}']
            ],
          ),
        ],
      ),
    );

    // Simpan ke direktori lokal
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    // Tampilkan konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Invoice berhasil disimpan di $file"),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Invoice")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LKS Mart',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.receipt, size: 50, color: Colors.blue),
              ],
            ),
            SizedBox(height: 16),
            Text("Tanggal: ${DateTime.now().toString()}"),
            SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  CartItem item = cart.cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Harga satuan: Rp. ${item.price}"),
                    trailing: Text("${item.quantity} x Rp. ${item.getTotalPrice()}"),
                  );
                },
              ),
            ),

            Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Bayar:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(
                  "Rp. ${cart.totalHarga.toStringAsFixed(0)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _generateAndSaveInvoice(context),
              icon: Icon(Icons.save),
              label: Text("Simpan Invoice PDF"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
            )
          ],
        ),
      ),
    );
  }
}