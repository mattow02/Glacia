# Chemin vers NSIS
$nsis_path = "C:\Program Files (x86)\NSIS\makensis.exe"

# Chemin vers le script NSIS
$script = "$PSScriptRoot\installer_script.nsi"

# Exécuter NSIS
& $nsis_path $script
