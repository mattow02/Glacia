#!/bin/bash

# Nom du jeu
APP_NAME="Glacia"
INSTALL_DIR="$HOME/$APP_NAME"

echo "Installation de $APP_NAME dans $INSTALL_DIR"

# Créer le dossier d'installation
mkdir -p "$INSTALL_DIR"

# Copier le binaire et le .pck
cp Glacia_linux.exe.x86_64 "$INSTALL_DIR/$APP_NAME"
chmod +x "$INSTALL_DIR/$APP_NAME"

# Renommer le .pck pour correspondre au binaire
cp Glacia_linux.exe.pck "$INSTALL_DIR/$APP_NAME.pck"

# Créer un script de lancement
LAUNCHER="$INSTALL_DIR/run.sh"
cat > "$LAUNCHER" <<EOL
#!/bin/bash
DIR="\$(cd "\$(dirname "\$0")" && pwd)"
cd "\$DIR"
./$APP_NAME
EOL
chmod +x "$LAUNCHER"

# Rendre le lancement disponible via la commande `Glacia`
# 1) Symlink dans ~/.local/bin si ce dossier est dans le PATH
BIN_DIR="$HOME/.local/bin"
if [ -d "$BIN_DIR" ] && echo ":$PATH:" | grep -q ":$BIN_DIR:"; then
  ln -sf "$LAUNCHER" "$BIN_DIR/$APP_NAME"
  MADE_CMD=true
fi

# 2) Sinon, ajouter un alias dans ~/.bashrc et ~/.zshrc
if [ -z "$MADE_CMD" ]; then
  echo "alias $APP_NAME='$LAUNCHER'" >> "$HOME/.bashrc"
  echo "alias $APP_NAME='$LAUNCHER'" >> "$HOME/.zshrc"
fi

echo "Installation terminée !"
echo "Pour lancer le jeu, tapez : $APP_NAME"
echo "Ou utilisez : $LAUNCHER"