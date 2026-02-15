import 'package:e_tantana/features/printer/presentation/providers/invoice_models.dart';
import 'package:e_tantana/features/printer/presentation/invoiceModels/first/pages/first.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_tantana/features/printer/presentation/providers/interaction_invoice_data_provider.dart';

final allInvoiceModelsProvider = Provider<List<InvoiceModels>>((ref) {
  final data = ref.watch(interactionInvoiceDataNotifierProvider);

  return [
    InvoiceModels(
      name: "Modèle Standard",
      creator: "Koja Nekena",
      model: First(invoiceData: data),
    ),
  ];
});
