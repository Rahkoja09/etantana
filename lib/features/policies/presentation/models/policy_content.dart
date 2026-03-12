class PoliciesContent {
  static const String appName = "E-Tantana";
  static const String contactEmail = "Fb: Koja Nekena Ramanamehefa";
  static const String lastUpdated = "Mars 2026";

  static const List<PolicySection> termsOfService = [
    PolicySection(
      title: "Acceptation des conditions",
      content:
          "En utilisant $appName, vous acceptez pleinement et sans réserve les présentes conditions générales d'utilisation. Si vous n'acceptez pas ces conditions, veuillez ne pas utiliser l'application.",
    ),
    PolicySection(
      title: "Description du service",
      content:
          "$appName est une plateforme de gestion de ventes en ligne permettant aux vendeurs de gérer leurs produits, commandes et livraisons. Nous mettons en relation vendeurs, livreurs et clients.",
    ),
    PolicySection(
      title: "Création de compte",
      content:
          "Vous devez fournir des informations exactes et complètes lors de la création de votre compte. Vous êtes responsable de la confidentialité de vos identifiants et de toutes les activités effectuées sous votre compte.",
    ),
    PolicySection(
      title: "Utilisation acceptable",
      content:
          "Vous vous engagez à ne pas utiliser $appName à des fins illégales, frauduleuses ou nuisibles. Toute tentative de manipulation des prix, de faux avis ou d'usurpation d'identité entraînera la suppression immédiate du compte.",
    ),
    PolicySection(
      title: "Transactions et paiements",
      content:
          "Toutes les transactions effectuées via $appName sont soumises à nos conditions de paiement. Nous ne sommes pas responsables des litiges entre vendeurs et acheteurs mais nous proposons un service de médiation.",
    ),
    PolicySection(
      title: "Suspension et résiliation",
      content:
          "Nous nous réservons le droit de suspendre ou supprimer tout compte qui violerait nos conditions d'utilisation, sans préavis ni remboursement dans les cas de fraude avérée.",
    ),
    PolicySection(
      title: "Limitation de responsabilité",
      content:
          "$appName ne peut être tenu responsable des pertes indirectes, dommages consécutifs ou manques à gagner résultant de l'utilisation ou de l'impossibilité d'utiliser le service.",
    ),
    PolicySection(
      title: "Modifications des conditions",
      content:
          "Nous nous réservons le droit de modifier ces conditions à tout moment. Les utilisateurs seront notifiés des changements importants par email ou notification dans l'application.",
    ),
  ];

  static const List<PolicySection> privacyPolicy = [
    PolicySection(
      title: "Données collectées",
      content:
          "Nous collectons les données que vous nous fournissez directement (nom, email, adresse, photo de profil), les données de transaction (commandes, paiements), les données d'utilisation (pages visitées, actions effectuées) et les données techniques (adresse IP, type d'appareil, système d'exploitation).",
    ),
    PolicySection(
      title: "Utilisation des données",
      content:
          "Vos données sont utilisées pour fournir et améliorer nos services, traiter vos transactions, vous envoyer des notifications importantes, prévenir la fraude, et respecter nos obligations légales. Nous n'utilisons pas vos données à des fins publicitaires tierces.",
    ),
    PolicySection(
      title: "Partage des données",
      content:
          "Vos données personnelles ne sont jamais vendues à des tiers. Elles peuvent être partagées avec nos prestataires techniques (hébergement, paiement) dans le strict cadre de la fourniture du service, et avec les autorités compétentes sur demande légale.",
    ),
    PolicySection(
      title: "Stockage et sécurité",
      content:
          "Vos données sont stockées de manière sécurisée sur des serveurs protégés. Nous utilisons le chiffrement SSL/TLS pour toutes les transmissions et des mesures de sécurité conformes aux standards de l'industrie.",
    ),
    PolicySection(
      title: "Vos droits",
      content:
          "Vous avez le droit d'accéder à vos données, de les rectifier, de les supprimer, de limiter leur traitement et de vous opposer à certains usages. Pour exercer ces droits, contactez-nous à $contactEmail.",
    ),
    PolicySection(
      title: "Cookies et traceurs",
      content:
          "L'application utilise des cookies techniques essentiels au fonctionnement du service. Aucun cookie publicitaire ou de traçage tiers n'est utilisé sans votre consentement explicite.",
    ),
    PolicySection(
      title: "Conservation des données",
      content:
          "Vos données sont conservées pendant toute la durée de votre utilisation du service et jusqu'à 3 ans après la suppression de votre compte pour respecter nos obligations légales.",
    ),
    PolicySection(
      title: "Mineurs",
      content:
          "$appName est destiné aux personnes de 18 ans et plus. Nous ne collectons pas sciemment de données personnelles concernant des mineurs. Si vous avez connaissance d'une telle situation, contactez-nous immédiatement.",
    ),
  ];

  static const List<PolicySection> sellerPolicy = [
    PolicySection(
      title: "Eligibilité vendeur",
      content:
          "Pour devenir vendeur sur $appName, vous devez être majeur, disposer d'une activité commerciale légale et fournir les documents justificatifs demandés lors de l'inscription.",
    ),
    PolicySection(
      title: "Responsabilité produits",
      content:
          "Vous êtes entièrement responsable de la conformité, de la qualité et de la légalité des produits que vous mettez en vente. Tout produit illégal, contrefait ou dangereux entraîne la suspension immédiate du compte.",
    ),
    PolicySection(
      title: "Prix et disponibilité",
      content:
          "Vous vous engagez à maintenir vos prix et disponibilités à jour. En cas d'erreur de prix manifeste, nous nous réservons le droit d'annuler les commandes concernées après vous en avoir informé.",
    ),
    PolicySection(
      title: "Commissions et frais",
      content:
          "Une commission est prélevée sur chaque vente réalisée via la plateforme. Le détail des tarifs est disponible dans votre espace vendeur. Ces frais peuvent évoluer avec un préavis de 30 jours.",
    ),
    PolicySection(
      title: "Délais et livraison",
      content:
          "Vous vous engagez à respecter les délais de traitement des commandes annoncés. En cas de retard ou d'impossibilité de livrer, vous devez en informer l'acheteur et notre service dans les plus brefs délais.",
    ),
    PolicySection(
      title: "Retours et remboursements",
      content:
          "Vous devez respecter notre politique de retour standard. Les litiges non résolus entre vendeur et acheteur dans un délai de 7 jours seront arbitrés par notre équipe dont la décision sera définitive.",
    ),
  ];

  static const List<PolicySection> deliveryPolicy = [
    PolicySection(
      title: "Eligibilité livreur",
      content:
          "Pour devenir livreur partenaire, vous devez être majeur, disposer d'un moyen de transport valide, d'un permis en cours de validité et fournir les documents d'identité requis.",
    ),
    PolicySection(
      title: "Zones de livraison",
      content:
          "Les livraisons sont effectuées dans les zones géographiques définies dans l'application. Vous n'êtes pas obligé d'accepter des livraisons hors de votre zone habituelle.",
    ),
    PolicySection(
      title: "Responsabilité des colis",
      content:
          "Une fois la prise en charge confirmée, vous êtes responsable des colis jusqu'à leur livraison. Tout dommage ou perte doit être immédiatement signalé via l'application.",
    ),
    PolicySection(
      title: "Rémunération",
      content:
          "La rémunération par livraison est calculée selon le tarif en vigueur dans votre zone. Les paiements sont effectués selon le calendrier défini dans votre espace livreur.",
    ),
    PolicySection(
      title: "Code de conduite",
      content:
          "Vous vous engagez à traiter les clients et vendeurs avec respect, à respecter le code de la route et à maintenir une présentation soignée lors des livraisons.",
    ),
  ];
}

class PolicySection {
  final String title;
  final String content;

  const PolicySection({required this.title, required this.content});
}

enum PolicyType { terms, privacy, seller, delivery }

extension PolicyTypeExtension on PolicyType {
  String get label {
    switch (this) {
      case PolicyType.terms:
        return "Conditions d'utilisation";
      case PolicyType.privacy:
        return "Politique de confidentialité";
      case PolicyType.seller:
        return "Politique vendeur";
      case PolicyType.delivery:
        return "Politique livreur";
    }
  }

  List<PolicySection> get sections {
    switch (this) {
      case PolicyType.terms:
        return PoliciesContent.termsOfService;
      case PolicyType.privacy:
        return PoliciesContent.privacyPolicy;
      case PolicyType.seller:
        return PoliciesContent.sellerPolicy;
      case PolicyType.delivery:
        return PoliciesContent.deliveryPolicy;
    }
  }
}
