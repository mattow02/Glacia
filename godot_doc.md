# Godot Project Documentation

**Repository:** [https://github.com/Miterra/Game_2D](https://github.com/Miterra/Game_2D)

**Generated:** 19/12/2025 01:42:09

---

## 📊 Project Statistics

| Scripts | Functions | Variables | Constants | Signals |
| --- | --- | --- | --- | --- |
| **12** | **65** | **116** | **0** | **0** |

---

## 📑 Table of Contents

* [BatimentsDB](https://www.google.com/search?q=%23batimentsdb) `(Scripts/Data/BatimentsDB.gd)`
* [CloseButton](https://www.google.com/search?q=%23closebutton) `(Scripts/Utils/CloseButton.gd)`
* [Dialogues](https://www.google.com/search?q=%23dialogues) `(Resources/DialoguesData.gd)`
* [GameController](https://www.google.com/search?q=%23gamecontroller) `(Scripts/Controllers/GameController.gd)`
* [GameData](https://www.google.com/search?q=%23gamedata) `(Scripts/Data/GameData.gd)`
* [GameModel](https://www.google.com/search?q=%23gamemodel) `(Scripts/Models/GameModel.gd)`
* [GameOverController](https://www.google.com/search?q=%23gameovercontroller) `(Scripts/Controllers/GameOverController.gd)`
* [GameWinController](https://www.google.com/search?q=%23gamewincontroller) `(Scripts/Controllers/GameWinController.gd)`
* [MainMenuController](https://www.google.com/search?q=%23mainmenucontroller) `(Scripts/Controllers/MainMenuController.gd)`
* [options](https://www.google.com/search?q=%23options) `(Scripts/options.gd)`
* [overlay_settings](https://www.google.com/search?q=%23overlay_settings) `(Scripts/overlay_settings.gd)`
* [SettingsView](https://www.google.com/search?q=%23settingsview) `(Scripts/Views/SettingsView.gd)`

---

## <a id="batimentsdb"></a>BatimentsDB

**File:** `Scripts/Data/BatimentsDB.gd`

**Extends:** `Node`

### Functions (1)

#### `static get_default_data() -> Dictionary`

---

## <a id="closebutton"></a>CloseButton

**File:** `Scripts/Utils/CloseButton.gd`

**Extends:** `Button`

### Functions (1)

#### `_on_pressed()`

---

## <a id="dialogues"></a>Dialogues

**File:** `Resources/DialoguesData.gd`

**Extends:** `Node`

### Variables (1)

* `static text: auto`

---

## <a id="gamecontroller"></a>GameController

**File:** `Scripts/Controllers/GameController.gd`

**Extends:** `Node2D`

### Functions (36)

#### `_ready()`

#### `setup_batiment_ui(key: String, button: auto, panel: auto, bar: auto, label_pers: auto, label_comm: auto, label_nom: auto, anim_repar: auto, anim_detruit: auto, anim_warning: auto)`

* **Parameters:**
* `key`: String
* `button`: auto
* `panel`: auto
* `bar`: auto
* `label_pers`: auto
* `label_comm`: auto
* `label_nom`: auto
* `anim_repar`: auto
* `anim_detruit`: auto
* `anim_warning`: auto



#### `update_animations_batiments()`

#### `set_anim_active(anim: AnimatedSprite2D, active: bool)`

* **Parameters:**
* `anim`: AnimatedSprite2D
* `active`: bool



#### `update_global_ui()`

#### `_update_all_labels()`

#### `_on_passer_pressed()`

#### `open_batiment(key: String)`

* **Parameters:**
* `key`: String



#### `open_destruct_batiment(bat_name: String)`

* **Parameters:**
* `bat_name`: String



#### `_on_fermer_pressed()`

#### `_on_ajouter_pressed()`

#### `_on_retirer_pressed()`

#### `_on_pdix_personnes_pressed()`

#### `_on_mdix_personnes_pressed()`

#### `afficher_bouton_reparation(key: String)`

* **Parameters:**
* `key`: String



#### `_reparer_batiment(key: String, bouton: Button)`

* **Parameters:**
* `key`: String
* `bouton`: Button



#### `_on_commander_pressed()`

#### `_on_fermer_commande_pressed()`

#### `_on_delais_commande_pressed()`

#### `_on_fermer_delais_commande_pressed()`

#### `verifier_etat_commandes()`

#### `afficher_delais_reparations()`

#### `_on_fermer_detruit_pressed()`

#### `_on_revenir_pressed()`

#### `_on_reprendre_pressed()`

#### `_on_quitter_pressed()`

#### `_change_to_game_over()`

#### `_change_to_game_win()`

#### `_on_bat_principal_pressed()`

#### `_on_bat_rech_pousse_pressed()`

#### `_on_bat_rech_pousse_2_pressed()`

#### `_on_antenne_market_pressed()`

#### `_on_bat_infirmerie_pressed()`

#### `_on_bat_restauration_pressed()`

#### `_on_bat_stockage_pressed()`

#### `_on_bat_temps_market_pressed()`

### Variables (80)

* `game_model: GameModel`
* `current_bat_ui_key: auto`
* `batiments_ui: Dictionary = {}`
* `data: auto = game_model.batiments_data[key]`
* `texte_titre: auto = data.nom`
* `data: auto = game_model.batiments_data[key]`
* `anim_repar: auto = batiments_ui[key].anim_repar`
* `anim_detruit: auto = batiments_ui[key].anim_detruit`
* `anim_warning: auto = batiments_ui[key].anim_warning`
* `ui: auto = batiments_ui[key]`
* `data: auto = game_model.batiments_data[key]`
* `game_status: auto = game_model.passer_tour()`
* `data: auto = game_model.batiments_data[key]`
* `ui_elements: auto = batiments_ui[key]`
* `bar: auto = ui_elements.bar`
* `data: auto = game_model.batiments_data[key]`
* `data: auto = game_model.batiments_data[key]`
* `data: auto = game_model.batiments_data[current_bat_ui_key]`
* `ajout: auto = min(10, game_model.pers_dispo)`
* `data: auto = game_model.batiments_data[current_bat_ui_key]`
* `retrait: auto = min(10, data.pers)`
* `btn_name: auto = "reparer_" + key`
* `data: auto = game_model.batiments_data[key]`
* `bouton: auto = Button.new()`
* `data: auto = game_model.batiments_data[key]`
* `nb_boutons_reparation: int = 0`
* `nom_label: String = "LabelRienAFaire"`
* `label_existe: auto = commande_vbox.has_node(nom_label)`
* `label: auto = Label.new()`
* `btn_fermer: auto = commande_vbox.get_node("fermer_commande")`
* `index_insertion: int = 1`
* `data: auto = game_model.batiments_data[key]`
* `label: auto = Label.new()`
* `stats: auto = game_model.recuperer_stats_finales()`
* `stats: auto = game_model.recuperer_stats_finales()`
* `@onready win_bar: ProgressBar` *(Node path: $WinBar)*
* `@onready mode: Label` *(Node path: $Mode)*
* `@onready argent_txt: Label` *(Node path: $Argent)*
* `@onready mois: Label` *(Node path: $Mois)*
* `@onready luigi_reparation_rech: AnimatedSprite2D` *(Node path: $Luigi_reparation_rech)*
* `@onready luigi_reparation_rech_2: AnimatedSprite2D` *(Node path: $Luigi_reparation_rech2)*
* `@onready luigi_reparation_antenne: AnimatedSprite2D` *(Node path: $Luigi_reparation_antenne)*
* `@onready luigi_reparation_infirmerie: AnimatedSprite2D` *(Node path: $Luigi_reparation_infirmerie)*
* `@onready luigi_reparation_restauration: AnimatedSprite2D` *(Node path: $Luigi_reparation_restauration)*
* `@onready luigi_reparation_stockage: AnimatedSprite2D` *(Node path: $Luigi_reparation_stockage)*
* `@onready luigi_reparation_temps: AnimatedSprite2D` *(Node path: $Luigi_reparation_temps)*
* `@onready detruis_rech: AnimatedSprite2D` *(Node path: $detruis_rech)*
* `@onready detruis_rech_2: AnimatedSprite2D` *(Node path: $detruis_rech2)*
* `@onready detruis_antenne: AnimatedSprite2D` *(Node path: $detruis_antenne)*
* `@onready detruis_infirmerie: AnimatedSprite2D` *(Node path: $detruis_infirmerie)*
* `@onready detruis_restauration: AnimatedSprite2D` *(Node path: $detruis_restauration)*
* `@onready detruis_stockage: AnimatedSprite2D` *(Node path: $detruis_stockage)*
* `@onready detruis_temps: AnimatedSprite2D` *(Node path: $detruis_temps)*
* `@onready warning_rech: AnimatedSprite2D` *(Node path: $warning_rech)*
* `@onready warning_rech_2: AnimatedSprite2D` *(Node path: $warning_rech_2)*
* `@onready warning_antenne: AnimatedSprite2D` *(Node path: $warning_antenne)*
* `@onready warning_infirmerie: AnimatedSprite2D` *(Node path: $warning_infirmerie)*
* `@onready warning_restauration: AnimatedSprite2D` *(Node path: $warning_restauration)*
* `@onready warning_stockage: AnimatedSprite2D` *(Node path: $warning_stockage)*
* `@onready warning_temps: AnimatedSprite2D` *(Node path: $warning_temps)*
* `@onready bat_rech_windows: PanelContainer` *(Node path: $bat_rechWindows)*
* `@onready bat_rech2_windows: PanelContainer` *(Node path: $bat_rech2Windows)*
* `@onready bat_antenne_windows: PanelContainer` *(Node path: $bat_antenneWindows)*
* `@onready bat_infirmerie_windows: PanelContainer` *(Node path: $bat_infirmerieWindows)*
* `@onready bat_restauration_windows: PanelContainer` *(Node path: $bat_restaurationWindows)*
* `@onready bat_stockage_windows: PanelContainer` *(Node path: $bat_stockageWindows)*
* `@onready bat_temps_windows: PanelContainer` *(Node path: $bat_tempsWindows)*
* `@onready commande_vbox: VBoxContainer` *(Node path: $CommandeWindows/VBoxContainer)*
* `@onready bat_detruit_windows: PanelContainer` *(Node path: $bat_detruitWindows)*
* `@onready nom_detruit: Label` *(Node path: $bat_detruitWindows/VBoxContainer/nom_detruit)*
* `@onready delais_commande_windows: PanelContainer` *(Node path: $delais_commandeWindows)*
* `@onready delais_vbox: VBoxContainer` *(Node path: $delais_commandeWindows/VBoxContainer)*
* `@onready menu_pause: PanelContainer` *(Node path: $Menu_pause)*
* `@onready bat_rech_btn: Button` *(Node path: $bat_rech_pousse)*
* `@onready bat_rech2_btn: Button` *(Node path: $bat_rech_pousse2)*
* `@onready bat_antenne_btn: Button` *(Node path: $Antenne_market)*
* `@onready bat_infirmerie_btn: Button` *(Node path: $bat_infirmerie)*
* `@onready bat_restauration_btn: Button` *(Node path: $bat_restauration)*
* `@onready bat_stockage_btn: Button` *(Node path: $bat_stockage)*
* `@onready bat_temps_btn: Button` *(Node path: $bat_temps_market)*

---

## <a id="gamedata"></a>GameData

**File:** `Scripts/Data/GameData.gd`

**Extends:** `Node`

### Variables (2)

* `mode_infini: bool = false`
* `stats_fin_de_partie: Dictionary = {}`

---

## <a id="gamemodel"></a>GameModel

**File:** `Scripts/Models/GameModel.gd`

**Extends:** `Node`

### Functions (6)

#### `passer_tour() -> int`

#### `gerer_jour_nuit()`

#### `passer_en_mode_nuit()`

#### `passer_en_mode_jour()`

#### `reset_personnel_batiments()`

#### `recuperer_stats_finales() -> Dictionary`

### Variables (18)

* `argent: int = 150000`
* `argent_depense: int = 0`
* `pers_totales: int = 50`
* `pers_dispo: int = 50`
* `tour_actuel: int = 1`
* `moisJour: int = 1`
* `moisNuit: int = 0`
* `is_night_mode: bool = false`
* `barre_survie: int = 35`
* `argent_genere_ce_tour: int = 0`
* `batiments_data: Dictionary = BatimentsDB.get_default_data()`
* `b: auto = batiments_data[key]`
* `gain: auto = b.gain_argent`
* `b: auto = batiments_data[key]`
* `survivants: Array = []`
* `detruits: Array = []`
* `score: int = 0`
* `b: auto = batiments_data[key]`

---

## <a id="gameovercontroller"></a>GameOverController

**File:** `Scripts/Controllers/GameOverController.gd`

**Extends:** `Node2D`

### Functions (4)

#### `_ready()`

#### `afficher_resultats()`

#### `_on_restart_pressed()`

#### `_on_quit_pressed()`

### Variables (2)

* `stats: auto = GameData.stats_fin_de_partie`
* `texte: String = "GAME OVER - LA STATION A GELE...\n\n"`

---

## <a id="gamewincontroller"></a>GameWinController

**File:** `Scripts/Controllers/GameWinController.gd`

**Extends:** `Node2D`

### Functions (4)

#### `_ready()`

#### `afficher_resultats()`

#### `_on_restart_pressed()`

#### `_on_quit_pressed()`

### Variables (2)

* `stats: auto = GameData.stats_fin_de_partie`
* `texte: String = "FELICITATIONS ! MISSION REUSSI !\n\n"`

---

## <a id="mainmenucontroller"></a>MainMenuController

**File:** `Scripts/Controllers/MainMenuController.gd`

**Extends:** `Node`

### Functions (6)

#### `_on_btn_exit_pressed()`

#### `_on_btn_play_pressed()`

#### `_on_btn_settings_pressed()`

#### `_on_normal_pressed()`

#### `_on_infini_pressed()`

#### `_on_quit_pressed()`

### Variables (4)

* `@onready game_mode: PanelContainer` *(Node path: $GameMode)*
* `@onready normal: Button` *(Node path: $Normal)*
* `@onready infini: Button` *(Node path: $Infini)*
* `@onready quit: Button` *(Node path: $Quit)*

---

## <a id="options"></a>options

**File:** `Scripts/options.gd`

**Extends:** `Node2D`

### Functions (1)

#### `_on_back_pressed()`

---

## <a id="overlay_settings"></a>overlay_settings

**File:** `Scripts/overlay_settings.gd`

**Extends:** `ColorRect`

### Functions (3)

#### `_ready()`

#### `_on_volume_changed(value: auto)`

* **Parameters:**
* `value`: auto



#### `_on_close_pressed()`

### Variables (4)

* `value: auto = clamp((AudioMenu.volume_db + 80) / 80 * 100, 0, 100)`
* `db_value: auto = lerp(-80, 0, value / 100.0)`
* `@onready volume_label: auto` *(Node path: $Panel/VolumeLabel)*
* `@onready close_button: auto` *(Node path: $Panel/btnClose)*

---

## <a id="settingsview"></a>SettingsView

**File:** `Scripts/Views/SettingsView.gd`

**Extends:** `PanelContainer`

### Functions (3)

#### `_ready()`

#### `_on_volume_changed(value: auto)`

* **Parameters:**
* `value`: auto



#### `_on_close_pressed()`

### Variables (3)

* `value: auto = clamp((AudioMenu.volume_db + 80) / 80 * 100, 0, 100)`
* `db_value: auto = lerp(-80, 0, value / 100.0)`
* `@export volume_label: auto`