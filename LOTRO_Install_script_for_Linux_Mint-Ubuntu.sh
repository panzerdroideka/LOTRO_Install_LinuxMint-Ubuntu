¤Dette er en utmerket idé. Jeg har satt sammen et komplett og kommentert ¤installasjonsskript basert på alle de vellykkede stegene vi har gått gjennom. ¤Du kan kopiere dette skriptet, lagre det som en fil og kjøre det i terminalen.
¤
¤**Slik bruker du skriptet:**
¤
¤1.  **Kopier koden** og lim den inn i en ny fil.
¤2.  Lagre filen med et navn som `install-lotro.sh`.
¤3.  **Gjør filen kjørbar** i terminalen: `chmod +x install-lotro.sh`
¤4.  **Kjør skriptet:** `./install-lotro.sh`
¤
-----

```bash
#!/bin/bash

# ==========================================================
# LOTRO Installasjonsskript for Linux Mint / Ubuntu
# ----------------------------------------------------------
# Dette skriptet automatiserer installasjonen og optimaliseringen
# av The Lord of the Rings Online basert på vellykket feilsøking
# for Voyo i7 med Intel HD 620-grafikk.
#
# Det inkluderer:
# - Installasjon av nødvendige verktøy (Lutris, Wine)
# - Konfigurering av Lutris med optimaliserte innstillinger
# - Installasjon av viktige Wine-komponenter (winhttp, quartz, etc.)
# - Automatisk justering av spillets konfigurasjonsfil
# ==========================================================

# ----------------------------------------------------------
# 1. Konfigurasjonsvariabler - Tilpass disse om nødvendig
# ----------------------------------------------------------
# Her definerer du stien der LOTRO skal installeres.
# Denne mappen vil fungere som din Wine-prefix.
LOTRO_PATH="$HOME/Games/lotro"

# Ditt brukernavn på Linux-systemet (for å finne Dokumenter-mappen)
USERNAME=$(whoami)

# Lutris konfigurasjonsfil i YAML-format
LUTRIS_YAML=$(cat <<EOF
game:
  exe: LotroLauncher.exe
  prefix: $LOTRO_PATH
lutris:
  installer_version: 1.0.0
  runner: wine
  version: lutris-ge-8-26-x86_64
system:
  fsync: true
  # Legg til Gamemode hvis du ønsker det
  # gamemode: true
wine:
  dxvk: false
  esync: true
EOF
)

# ----------------------------------------------------------
# 2. Installer nødvendige pakker
# ----------------------------------------------------------
echo "Starter installasjon av nødvendige pakker..."
sudo apt update
sudo apt install -y lutris wine winetricks

# Sjekk om installasjonen var vellykket
if [ $? -ne 0 ]; then
    echo "Feil: Kunne ikke installere nødvendige pakker. Avslutter."
    exit 1
fi

# ----------------------------------------------------------
# 3. Konfigurer Lutris for LOTRO
# ----------------------------------------------------------
echo "Konfigurerer Lutris..."
mkdir -p "$LOTRO_PATH"
# Lager en midlertidig fil med Lutris konfigurasjonen
echo "$LUTRIS_YAML" > /tmp/lotro.yml
# Importerer konfigurasjonen til Lutris
lutris -i /tmp/lotro.yml

# ----------------------------------------------------------
# 4. Installer nødvendige Wine-komponenter
# ----------------------------------------------------------
echo "Installerer Windows-komponenter (winhttp, d3dx9_43, quartz)..."
WINEPREFIX="$LOTRO_PATH" winetricks winhttp d3dx9_43 quartz

# ----------------------------------------------------------
# 5. Veiledning til brukeren
# ----------------------------------------------------------
echo "Installasjon og grunnleggende konfigurasjon er fullført!"
echo "Neste steg er å starte spillet for første gang via Lutris."
echo "Det vil da laste ned alle spillets filer."
echo ""
echo "Viktig: Når du blir spurt om å aktivere DirectX 11, velg NEI."
echo ""
read -p "Trykk [Enter] når nedlastingen er fullført og du har logget inn en gang..."

# ----------------------------------------------------------
# 6. Optimaliser spillets konfigurasjonsfil
# ----------------------------------------------------------
echo "Optimaliserer UserPreferences.ini-filen..."

# Sti til spillets Documents-mappe
LOTRO_DOCS_PATH="$HOME/Documents/The Lord of the Rings Online"

# Vent til filen eksisterer
if [ ! -f "$LOTRO_DOCS_PATH/UserPreferences.ini" ]; then
    echo "Feil: UserPreferences.ini-filen ble ikke funnet. Sjekk at du har startet spillet en gang."
    exit 1
fi

# Endre de viktigste parameterne med sed
sed -i 's/TripleBuffering=False/TripleBuffering=True/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"
sed -i 's/MaximumFrameRate=.*/MaximumFrameRate=60/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"
sed -i 's/GraphicsCore=.*/GraphicsCore=D3D9/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"
sed -i 's/BlobShadows=.*/BlobShadows=False/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"
sed -i 's/AmbientOcclusion=.*/AmbientOcclusion=False/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"
sed -i 's/LandscapeDrawDistance=.*/LandscapeDrawDistance=Low/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"
sed -i 's/ObjectDrawDistance=.*/ObjectDrawDistance=Low/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"
sed -i 's/ShadowMapQuality=.*/ShadowMapQuality=0/g' "$LOTRO_DOCS_PATH/UserPreferences.ini"

echo "Ferdig! LOTRO er nå installert og optimalisert."
echo "Du kan nå starte spillet fra Lutris og finjustere innstillingene inne i spillet."

```
