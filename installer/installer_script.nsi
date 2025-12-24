; Nom de l’installateur
OutFile "GlaciaInstaller.exe"

; Dossier d'installation par défaut
InstallDir "$PROGRAMFILES\Glacia"

Section "Glacia"
  SetOutPath "$INSTDIR"

  ; Copie l'exécutable
  File "C:\Users\0711m\Documents\ProjetGODOT\Game_T3\exports\windows\Glacia_windows.exe"

  ; Copie le fichier de données Godot
  File "C:\Users\0711m\Documents\ProjetGODOT\Game_T3\exports\windows\Glacia_windows.pck"
  
  ; Copie le fichier de console du jeu
  File "C:\Users\0711m\Documents\ProjetGODOT\Game_T3\exports\windows\Glacia_windows.console.exe"

SectionEnd
