import 'package:e_tantana/features/order/domain/entities/order_entities.dart';

class MessageTemplate {
  static String generateOrderConfirmation(OrderEntities order) {
    double totalProduits = 0;
    if (order.productsAndQuantities != null) {
      for (var item in order.productsAndQuantities!) {
        totalProduits +=
            (item['unit_price'] as num) * (item['quantity'] as num);
      }
    }

    final totalGeneral = totalProduits + (order.deliveryCosts ?? 0);

    return """

Bonjour *${order.clientName ?? 'Client(e)'}*, 

>> VOTRE COMMANDE CHEZ NMV EST VALIDÉE <<

voici les détails:

🆔 *Commande N°:* ${order.id?.substring(0, 8).toUpperCase() ?? 'En cours...'}
📅 *Date:* ${order.createdAt != null ? _formatDate(order.createdAt!) : '-'}
🚚 *Livraison prévue:* ${order.deliveryDate != null ? _formatDate(order.deliveryDate!) : 'À confirmer'}

----------------------------------
📍 *Adresse:* ${order.clientAdrs ?? '-'}
💰 *Frais de livraison:* ${(order.deliveryCosts ?? 0).toStringAsFixed(0)} Ar
🔥 *TOTAL À PAYER:* ${totalGeneral.toStringAsFixed(0)} Ar
----------------------------------

📄 *Facture (lien sécurisé) :*
${order.invoiceLink ?? 'Lien disponible prochainement'}

- Merci d'être joignable le jours de livraison -

📞 *Besoin d'aide ? Contactez-nous :*
+261 38 05 166 86
+261 33 60 497 84
*PAGE FACEBOOK UNIQUE DE NMV: *
https://www.facebook.com/profile.php?id=61582901219933*NMV *

Misaotra tamin'ny fahatokisana! 

🌟 *NMV - Ny Mora Vidy* 🌟
_"Manome ny tsara indrindra ho anao"_

@Ce message est automatiquement envoyé par notre système de commande.
""";
  }

  static String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
