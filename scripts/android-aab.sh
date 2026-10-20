#!/bin/zsh
# Compila el .aab firmado para Google Play con la clave de subida.
# Pide la contraseña al ejecutarlo: no se guarda en ningún archivo.
# Uso: npm run android:aab   (clave en otra ruta: TERRAVERA_KEYSTORE=/ruta/clave.jks npm run android:aab)
set -e
KEYSTORE="${TERRAVERA_KEYSTORE:-$HOME/Documents/TERRAVERA-claves/terravera-upload.jks}"
[ -f "$KEYSTORE" ] || { echo "No encuentro la clave de subida en $KEYSTORE"; exit 1; }
# Gradle 8.11.1 / AGP 8.7.2 necesitan Java 21 (ver README)
export JAVA_HOME="${JAVA_HOME_21:-/opt/homebrew/opt/openjdk@21}"
read -rs "PASS?Contraseña de la clave de subida: "; echo
cd "$(dirname "$0")/../android"
./gradlew bundleRelease --console=plain \
  -Pandroid.injected.signing.store.file="$KEYSTORE" \
  -Pandroid.injected.signing.store.password="$PASS" \
  -Pandroid.injected.signing.key.alias=upload \
  -Pandroid.injected.signing.key.password="$PASS"
echo
echo "Listo: android/app/build/outputs/bundle/release/app-release.aab"
