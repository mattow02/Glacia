# Diagrammes UML - Glacia

Ce dossier contient les diagrammes UML décrivant la structure du jeu Glacia.

## Fichiers disponibles

### 1. `diagramme_uml.puml` - Diagramme de Classes
Diagramme détaillé montrant toutes les classes principales du jeu, leurs attributs, méthodes et relations.

**Classes principales :**
- **GameModel** : Modèle principal gérant la logique métier
- **GameController** : Contrôleur principal du jeu
- **BatimentsDB** : Base de données des bâtiments
- **GameData** : Singleton partagé pour les données globales
- **Controllers** : MainMenuController, GameOverController, GameWinController

### 2. `diagramme_navigation.puml` - Diagramme de Navigation
Diagramme montrant le flux de navigation entre les différentes scènes du jeu.

**Scènes principales :**
- MainMenu → Dialogues → GameLevel → (GameOver/GameWin)

### 3. `diagramme_architecture.puml` - Diagramme d'Architecture
Vue d'ensemble de l'architecture MVC (Model-View-Controller) du projet.


## Structure du projet

Le jeu Glacia suit une architecture **MVC (Model-View-Controller)** :

- **MODEL** : `GameModel` contient toute la logique métier
- **VIEW** : Les scènes Godot (`.tscn`) et les composants UI
- **CONTROLLER** : Les scripts `*Controller.gd` coordonnent l'interaction

### Flux de données principal

```
GameController → GameModel → BatimentsDB
              ↓
            GameData (Singleton partagé)
              ↓
    GameOverController / GameWinController
```

## Résumé de l'architecture

- **8 bâtiments** gérés (principal, recherche x2, antenne, infirmerie, restauration, stockage, temps)
- **Cycle jour/nuit** : 6 mois jour / 6 mois nuit
- **Système de réparations** avec délais et coûts
- **Gestion du personnel** affecté aux bâtiments
- **Barre de survie** calculée selon l'état des bâtiments
- **Modes de jeu** : Normal (24 tours) et Infini
