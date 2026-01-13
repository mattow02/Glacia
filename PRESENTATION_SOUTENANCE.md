# Présentation Soutenance - Glacia

**Durée :** 10 minutes de présentation + 10 minutes de questions  
**Date :** 14-15 janvier  
**Évaluateurs :** Pierre Kraemer et Mathieu Zimmermann

---

## 📋 PLAN DE PRÉSENTATION

1. **Thème du projet** (1-2 min)
2. **Structures de données** (3-4 min)
3. **Algorithmes principaux** (4-5 min)
4. **Critique et alternatives** (1-2 min)

---

## 1. THÈME DU PROJET (1-2 minutes)

### Glacia : Jeu de Gestion en Antarctique

**Contexte :**
- Jeu de gestion, survie et stratégie développé avec **Godot Engine 4.5**
- Architecture **MVC (Model-View-Controller)**
- Objectif : Gérer une station polaire scientifique sur 24 mois

**Mécaniques principales :**
- **8 bâtiments** à maintenir (principal, recherche x2, antenne, infirmerie, restauration, stockage, temps marketing)
- **Gestion du personnel** : Répartition de 50 personnes (10 en nuit polaire)
- **Cycle jour/nuit** : 6 mois de jour / 6 mois de nuit polaire
- **Système de réparations** avec délais (5 mois de livraison)
- **Barre de survie** calculée selon l'état des bâtiments

**Objectif pédagogique :** Exploration des dynamiques de gestion de crise avec anticipation, équilibre systémique et interdépendances.

---

## 2. STRUCTURES DE DONNÉES CHOISIES (3-4 minutes)

### 2.1. Dictionary pour les Bâtiments (`batiments_data`)

**Choix :** `Dictionary<String, Dictionary>` - Structure imbriquée

**Localisation :** `Scripts/Models/GameModel.gd`

```gdscript
var batiments_data: Dictionary = BatimentsDB.get_default_data()

# Structure :
batiments_data = {
    "principal": {
        "nom": "Batiment principal",
        "pers": 0,              # Personnel affecté
        "etat": true,           # Booléen : intact/détruit
        "reparation_restante": 0,
        "tour_cout": 5,
        "pv": 70,               # Points de vie (0-100)
        "cout": 400000,
        "gain_argent": 5000
    },
    "rech": { ... },
    "antenne": { ... },
    ...
}
```

**Justification :**
- **Accès O(1)** par clé (nom du bâtiment)
- **Flexibilité** : Ajout/modification facile de nouveaux bâtiments
- **Typage dynamique** de GDScript adapté aux données hétérogènes
- **Sérialisation native** pour sauvegarde/chargement potentiel

**Source des données :** `BatimentsDB.get_default_data()` (classe statique)

---

### 2.2. Dictionary pour l'UI des Bâtiments (`batiments_ui`)

**Choix :** `Dictionary<String, Dictionary>` - Indexation des références UI

**Localisation :** `Scripts/Controllers/GameController.gd`

```gdscript
var batiments_ui = {}

# Structure :
batiments_ui = {
    "principal": {
        "button": Button,
        "panel": PanelContainer,
        "bar": ProgressBar,
        "label_pers": Label,
        "label_common": Label,
        "label_nom": Label,
        "anim_repar": AnimatedSprite2D,
        "anim_detruit": AnimatedSprite2D,
        "anim_warning": AnimatedSprite2D
    },
    ...
}
```

**Justification :**
- **Centralisation** : Toutes les références UI regroupées par bâtiment
- **Itération uniforme** : Boucle unique pour mettre à jour tous les bâtiments
- **Couplage faible** : Séparation données (Model) / présentation (View)

---

### 2.3. Array pour les Statistiques Finales

**Choix :** `Array` pour les listes de bâtiments

**Localisation :** `Scripts/Models/GameModel.gd` - `recuperer_stats_finales()`

```gdscript
var survivants = []  # Array de String
var detruits = []    # Array de String

for key in batiments_data:
    var b = batiments_data[key]
    if b.etat:
        survivants.append(b.nom)
    else:
        detruits.append(b.nom)
```

**Justification :**
- **Ordre d'insertion** préservé pour l'affichage
- **Opérations simples** : `append()` en O(1) amorti
- **Itération directe** pour l'affichage

---

### 2.4. Types Primitifs pour l'État du Jeu

**Choix :** Types simples (int, float, bool)

```gdscript
var argent: int = 150000
var argent_depense: int = 0
var pers_totales: int = 50
var pers_dispo: int = 50
var tour_actuel: int = 1
var moisJour: int = 1
var moisNuit: int = 0
var is_night_mode: bool = false
var barre_survie: float = 35.0
var argent_genere_ce_tour: int = 0
```

**Justification :**
- **Performance** : Accès direct en mémoire
- **Simplicité** : Pas de surcharge pour des valeurs atomiques
- **Typage explicite** pour la clarté

---

### 2.5. Singleton pour les Données Globales (`GameData`)

**Choix :** Classe singleton (AutoLoad dans Godot)

**Localisation :** `Scripts/Data/GameData.gd`

```gdscript
extends Node

var mode_infini: bool = false
var stats_fin_de_partie = {}
```

**Justification :**
- **Accès global** depuis n'importe quelle scène
- **Persistence** entre les changements de scène
- **Pattern standard** dans Godot pour les données partagées

---

## 3. ALGORITHMES PRINCIPAUX (4-5 minutes)

### 3.1. Algorithme Principal : `passer_tour()`

**Complexité :** O(n) où n = nombre de bâtiments (8)

**Localisation :** `Scripts/Models/GameModel.gd`

**Rôle :** Exécute toute la logique d'un tour de jeu

```gdscript
func passer_tour() -> int:
    argent_genere_ce_tour = 0
    
    # 1. Gestion des bâtiments (O(n))
    for key in batiments_data:
        var b = batiments_data[key]
        
        # GESTION REPARATION
        if b.reparation_restante > 0:
            b.reparation_restante -= 1
            if b.reparation_restante == 0:
                b.etat = true
                b.pv = 50
            continue
        
        # SI DETRUIT
        if not b.etat:
            b.pv = 0
            continue
        
        # LOGIQUE PV SELON PERSONNEL (5 seuils)
        if b.pers < 5:
            b.pv -= 10
        elif b.pers < 10:
            b.pv -= 5
        elif b.pers < 15:
            pass  # Stable
        elif b.pers < 20:
            b.pv += 5
        else:  # 20+
            b.pv += 20
        
        b.pv = clamp(b.pv, 0, 100)  # Contrainte [0, 100]
        
        # VERIFICATION DESTRUCTION
        if b.pv <= 0:
            b.etat = false
            b.pv = 0
        else:
            var gain = b.gain_argent
            if tour_actuel >= 26:
                gain = int(gain / 2)  # Malus froid
            argent_genere_ce_tour += gain
    
    argent += argent_genere_ce_tour
    
    # 2. Calcul barre de survie (O(n))
    for key in batiments_data:
        var b = batiments_data[key]
        if b.reparation_restante > 0 or not b.etat or b.pv < 50:
            barre_survie -= 0.5
        else:
            barre_survie += 0.5
    
    barre_survie = clamp(barre_survie, 0, 100)
    
    tour_actuel += 1
    
    # 3. Gestion Jour/Nuit (O(1))
    gerer_jour_nuit()
    
    # CONDITIONS DE FIN (O(1))
    if barre_survie <= 0:
        return 1  # Perdu
    if not GameData.mode_infini and tour_actuel > 24:
        return 2  # Gagné
    return 0  # Continue
```

**Points clés :**
- **Parcours séquentiel** : O(n) avec n=8 (constant pratique)
- **Système de seuils** : 5 niveaux de gestion du personnel
- **État machine implicite** : réparation → détruit → actif
- **Clamp** pour garantir les contraintes

---

### 3.2. Algorithme de Cycle Jour/Nuit

**Complexité :** O(1) par appel, O(n) lors des transitions (n=8)

**Localisation :** `Scripts/Models/GameModel.gd`

```gdscript
func gerer_jour_nuit():
    if not is_night_mode:
        moisJour += 1
        if moisJour >= 6:
            passer_en_mode_nuit()
    else:
        moisNuit += 1
        if moisNuit >= 6:
            passer_en_mode_jour()

func passer_en_mode_nuit():
    is_night_mode = true
    moisJour = 0
    moisNuit = 0
    pers_totales = 10
    pers_dispo = 10
    reset_personnel_batiments()  # O(n)

func reset_personnel_batiments():
    for key in batiments_data:
        batiments_data[key].pers = 0
```

**Points clés :**
- **Compteurs séparés** pour jour/nuit
- **Réinitialisation** du personnel lors des transitions
- **Impact stratégique** majeur (50 → 10 personnes)

---

### 3.3. Algorithme de Priorité d'Animations

**Complexité :** O(n) où n = nombre de bâtiments

**Localisation :** `Scripts/Controllers/GameController.gd`

```gdscript
func update_animations_batiments():
    for key in batiments_ui:
        var data = game_model.batiments_data[key]
        var anim_repar = batiments_ui[key].anim_repar
        var anim_detruit = batiments_ui[key].anim_detruit
        var anim_warning = batiments_ui[key].anim_warning
        
        # CAS 1 : EN REPARATION (Priorité absolue)
        if data.reparation_restante > 0:
            set_anim_active(anim_repar, true)
            set_anim_active(anim_detruit, false)
            set_anim_active(anim_warning, false)
        
        # CAS 2 : DETRUIT
        elif not data.etat:
            set_anim_active(anim_repar, false)
            set_anim_active(anim_detruit, true)
            set_anim_active(anim_warning, false)
        
        # CAS 3 : WARNING (PV <= 20%)
        elif data.pv <= 20:
            set_anim_active(anim_repar, false)
            set_anim_active(anim_detruit, false)
            set_anim_active(anim_warning, true)
        
        # CAS 4 : NORMAL
        else:
            set_anim_active(anim_repar, false)
            set_anim_active(anim_detruit, false)
            set_anim_active(anim_warning, false)
```

**Points clés :**
- **Système de priorité** explicite (if-elif-elif-else)
- **État exclusif** : une seule animation active à la fois
- **Null-safe** : gestion des animations manquantes

---

### 3.4. Algorithme de Calcul de Score

**Complexité :** O(n) où n = nombre de bâtiments

**Localisation :** `Scripts/Models/GameModel.gd`

```gdscript
func recuperer_stats_finales() -> Dictionary:
    var survivants = []
    var detruits = []
    var score = 0
    
    # 1. Tri des bâtiments (O(n))
    for key in batiments_data:
        var b = batiments_data[key]
        if b.etat:
            survivants.append(b.nom)
            score += 1000  # 1000 points par bâtiment vivant
        else:
            detruits.append(b.nom)
    
    # 2. Points pour l'argent (O(1))
    score += int(argent / 100)
    
    # 3. Bonus victoire (O(1))
    score += 5000
    
    return {
        "score_total": score,
        "argent_restant": argent,
        "argent_depense": argent_depense,
        "liste_survivants": survivants,
        "liste_detruits": detruits,
        "tours_tenus": tour_actuel
    }
```

**Points clés :**
- **Séparation** en deux listes
- **Système multi-critères** : bâtiments + argent
- **Bonus fixe** pour la victoire

---

## 4. CRITIQUE ET ALTERNATIVES (1-2 minutes)

### 4.1. Structures de Données : Points Positifs

✅ **Dictionary pour bâtiments** :
- **Avantage** : Accès O(1) par clé, flexibilité
- **Adapté** au nombre fixe de bâtiments (8)
- **Limite acceptable** : Pas d'ordre garanti (non problématique ici)

✅ **Dictionary pour UI** :
- **Avantage** : Couplage faible Model/View
- **Réutilisabilité** : Pattern applicable à d'autres entités

✅ **Array pour listes** :
- **Avantage** : Simple, ordre préservé
- **Adapté** pour l'affichage séquentiel

---

### 4.2. Structures de Données : Points à Améliorer

⚠️ **Dictionary imbriqués** :
- **Problème** : Pas de typage fort (GDScript)
- **Risque** : Erreurs de clés à l'exécution
- **Alternative** : Utiliser une **classe `Batiment`** avec propriétés typées
  ```gdscript
  class_name Batiment
  extends Resource
  @export var nom: String
  @export var pers: int
  @export var etat: bool
  @export var pv: int
  # ...
  ```
  - **Avantage** : Typage fort, auto-complétion, validation
  - **Inconvénient** : Plus verbeux, nécessite Resource dans Godot

⚠️ **Dictionary pour UI** :
- **Problème** : Accès par string ("button", "panel") → risque de faute de frappe
- **Alternative 1** : **Enum** pour les clés
  ```gdscript
  enum UIKeys { BUTTON, PANEL, BAR, ... }
  batiments_ui[key][UIKeys.BUTTON]
  ```
  - **Avantage** : Auto-complétion, erreurs compile-time
- **Alternative 2** : **Classe `BatimentUI`**
  ```gdscript
  class_name BatimentUI
  var button: Button
  var panel: PanelContainer
  # ...
  ```
  - **Avantage** : Typage fort, encapsulation

---

### 4.3. Algorithmes : Points Positifs

✅ **`passer_tour()`** :
- **Complexité** O(n) avec n=8 constant → **O(1) pratique**
- **Lisibilité** : Code clair, séparation des phases
- **Efficacité** : Un seul parcours pour la majorité des calculs

✅ **Système de seuils** :
- **Simple** : 5 conditions if-elif
- **Efficace** : O(1) par bâtiment
- **Maintenable** : Facile à ajuster les valeurs

---

### 4.4. Algorithmes : Points à Améliorer

⚠️ **Double parcours dans `passer_tour()`** :
```gdscript
# Parcours 1 : Gestion des bâtiments
for key in batiments_data: ...

# Parcours 2 : Calcul barre de survie
for key in batiments_data: ...
```
- **Problème** : Redondance (n=8, impact négligeable mais présent)
- **Alternative** : **Fusionner en un seul parcours**
  ```gdscript
  for key in batiments_data:
      var b = batiments_data[key]
      # ... gestion PV ...
      # Calcul barre de survie immédiatement après
      if b.reparation_restante > 0 or not b.etat or b.pv < 50:
          barre_survie -= 0.5
      else:
          barre_survie += 0.5
  ```
  - **Avantage** : Moins de parcours, meilleure localité de cache
  - **Complexité** : O(n) → O(n) (pas de gain asymptotique mais meilleur en pratique)

⚠️ **Système de seuils avec if-elif** :
- **Problème** : 5 conditions linéaires (acceptable mais peut être optimisé)
- **Alternative** : **Table de correspondance** (lookup table)
  ```gdscript
  # Défini une fois
  var seuils_pv = {
      5: -10,
      10: -5,
      15: 0,
      20: 5
  }
  
  # Dans la boucle
  var modif_pv = 20  # Par défaut (>= 20)
  for seuil in seuils_pv.keys().sort():
      if b.pers < seuil:
          modif_pv = seuils_pv[seuil]
          break
  b.pv += modif_pv
  ```
  - **Avantage** : Plus facile à modifier (données vs code)
  - **Inconvénient** : Plus complexe, moins lisible pour 5 seuils
  - **Verdict** : **Non recommandé** pour ce cas (5 seuils)

⚠️ **Calcul de score** :
- **Problème** : Utilisation de `append()` dans une boucle
- **Note** : En GDScript, `append()` est O(1) amorti → **acceptable**
- **Alternative** : **Pré-allouer** si on connaît la taille max
  ```gdscript
  var survivants = []
  survivants.resize(8)  # Taille max = 8 bâtiments
  ```
  - **Verdict** : **Non nécessaire** (n=8, overhead négligeable)

---

### 4.5. Bilan Global

**Forces :**
- ✅ Structures simples et adaptées au problème
- ✅ Algorithmes linéaires O(n) avec n constant → O(1) pratique
- ✅ Code lisible et maintenable
- ✅ Architecture MVC claire

**Faiblesses (mineures) :**
- ⚠️ Manque de typage fort (limitation GDScript)
- ⚠️ Quelques optimisations possibles (double parcours)
- ⚠️ Structures de données imposées par Godot (Dictionary, Array)

**Conclusion :**
Les choix de structures de données et algorithmes sont **appropriés** pour un projet de cette taille. Le manque de typage fort est une **limitation de l'environnement** (GDScript), et les optimisations potentielles auraient un **impact négligeable** avec seulement 8 bâtiments. Pour un projet plus grand, l'utilisation de classes typées serait recommandée.

---

## 📝 NOTES POUR LA PRÉSENTATION ORALE

### Timing suggéré :
- **Thème** : 1-2 min
- **Structures** : 3-4 min (détail sur Dictionary principalement)
- **Algorithmes** : 4-5 min (focus sur `passer_tour()` et cycle jour/nuit)
- **Critique** : 1-2 min (points essentiels)

### Points à mettre en avant :
1. **Justification des Dictionary** : Accès O(1), flexibilité
2. **Complexité O(n) avec n=8** → constante pratique
3. **Limitations GDScript** : Typage dynamique vs typage fort
4. **Optimisations possibles** : Double parcours, classes typées

### Questions potentielles à anticiper :
- "Pourquoi Dictionary plutôt qu'un Array ?" → Accès par clé, pas d'ordre nécessaire
- "Complexité asymptotique ?" → O(n) mais n=8 constant → O(1) pratique
- "Alternative avec classes ?" → Typage fort mais plus verbeux
- "Performance avec plus de bâtiments ?" → Scalabilité discutée

---

## 🔗 FICHIERS DE RÉFÉRENCE

- `Scripts/Models/GameModel.gd` : Cœur du système
- `Scripts/Controllers/GameController.gd` : Gestion UI
- `Scripts/Data/BatimentsDB.gd` : Données par défaut
- `Scripts/Data/GameData.gd` : Singleton global
