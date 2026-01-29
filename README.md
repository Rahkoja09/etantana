# Etantana

Etantana est une solution mobile dédiée à la gestion de ventes en ligne.

## Objectif MVP

L'enjeu principal du MVP est l'intégration et la validation du flux d'impression thermique (factures et étiquetage) via une imprimante portable externe.

## Aperçu de l'interface

<p align="center">
  <img src="https://github.com/user-attachments/assets/1853bf4e-fcb6-46a3-ad96-6cfe4a2d6129" width="160" />
  <img src="https://github.com/user-attachments/assets/f10d940a-ca6d-409c-b633-87d80e6683ee" width="160" />
  <img src="https://github.com/user-attachments/assets/0746a25b-576a-4a39-b802-15495edd7e2a" width="160" />
  <img src="https://github.com/user-attachments/assets/52cec5ee-70e2-400d-8215-ce338b7473ff" width="160" />
  <img src="https://github.com/user-attachments/assets/1d2eac66-ca4b-4803-acd9-7b1e124cf2bd" width="160" />
</p>

## Stack Technique

- **Framework :** Flutter (Android Only pour la v1).
- **Architecture :** Clean Architecture.
- **Gestion d'état :** Riverpod.
- **Injection de dépendances :** Get_It.
- **Backend & Base de données :** Supabase.
- **Impression :** Communication avec l'application iPrint pour la gestion du matériel thermique.

## Caractéristiques

- Architecture modulaire et scalable séparée par Features.
- Thème dynamique.
- Gestion des médias et stockage cloud.
- Recherche et filtrage .

## Installation rapide

1. Cloner le projet : `git clone https://github.com/Rahkoja09/etantana.git`
2. Installer les dépendances : `flutter pub get`
3. Lancer la génération des fichiers (si nécessaire) : `flutter pub run build_runner build`
4. Exécuter l'application : `flutter run`

---

Comming push...
