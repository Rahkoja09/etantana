import 'package:flutter/widgets.dart';

class InvoiceModels {
  final String name;
  final Widget model;
  final String creator;
  InvoiceModels({
    required this.name,
    required this.model,
    required this.creator,
  });

  Widget get getModel {
    return this.model;
  }

  String get getModelName {
    return this.name;
  }
}
