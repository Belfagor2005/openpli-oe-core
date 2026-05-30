#!/bin/bash

## 20251124  script bash by Lululla for make images
## UPDATED with all correct models for scarthgap branch

# Function to show messages with custom colors
function print_message {
    local msg_type=$1
    local msg=$2
    case $msg_type in
        "info") echo -e "\033[1;34m[INFO] $msg\033[0m" ;;  # Blue
        "error") echo -e "\033[1;31m[ERROR] $msg\033[0m" ;;  # Red
        "success") echo -e "\033[1;32m[SUCCESS] $msg\033[0m" ;;  # Green
        *) echo "$msg" ;;
    esac
}

# Function to rename ZIP files
function rename_zip_file() {
    local model=$1
    sleep 2
    
    local original_zip=$(find build/tmp/deploy/images/"$model" -maxdepth 1 -name "*.zip" -type f 2>/dev/null | head -1)
    
    if [ -f "$original_zip" ]; then
        local new_name="corvoboys-$(basename "$original_zip")"
        local new_path="$(dirname "$original_zip")/$new_name"
        
        if mv "$original_zip" "$new_path" 2>/dev/null; then
            print_message "success" "✓ File rinominato: $new_name"
            ln -sf "$new_name" "$original_zip" 2>/dev/null
            return 0
        else
            print_message "error" "✗ Impossibile rinominare il file ZIP"
            return 1
        fi
    else
        print_message "error" "✗ Nessun file ZIP trovato per $model"
        return 1
    fi
}

# Function progress bar
function progress_bar {
    local total=$1
    local current=0
    while [ $current -le $total ]; do
        let "progress=($current*100)/$total"
        echo -n "#"
        sleep 0.1
        let "current++"
    done
    echo
}

# Init Cleaning
rm -f build/bitbake.lock build/bitbake.sock
print_message "info" "Initializing cleaning..."

# Producers and models
declare -A PRODUCERS=(
    [0]="Abcom"
    [1]="Amiko"
    [2]="Axas"
    [3]="Dream"
    [4]="Edision"
    [5]="Formuler"
    [6]="Gfutures"
    [7]="Gi"
    [8]="Gigablue"
    [9]="Maxytec"
    [10]="Miraclebox"
    [11]="Octagon"
    [12]="Qviart"
    [13]="Sab"
    [14]="Spycat"
    [15]="Technomate"
    [16]="Uclan"
    [17]="Vuplus"
    [18]="Xp"
    [19]="Xpeedc"
    [20]="Xsarius"
    [21]="Xtrend"
    [22]="Zgemma"
)

# Models for each manufacturer
declare -A MODELS_Abcom=(
    [0]="pulse4k"
    [1]="pulse4kmini"
)

declare -A MODELS_Amiko=(
    [0]="vipercombo"
    [1]="vipercombohdd"
    [2]="viperslim"
    [3]="vipert2c"
)

declare -A MODELS_Axas=(
    [0]="e4hd"
)

declare -A MODELS_Dream=(
    [0]="dm8000"
)

declare -A MODELS_Edision=(
    [0]="osmega"
    [1]="osmini"
    [2]="osmini4k"
    [3]="osminiplus"
    [4]="osmio4k"
    [5]="osmio4kplus"
    [6]="osnino"
    [7]="osninoplus"
    [8]="osninopro"
)

declare -A MODELS_Formuler=(
    [0]="formuler1"
    [1]="formuler3"
    [2]="formuler4"
    [3]="formuler4turbo"
)

declare -A MODELS_Gfutures=(
    [0]="bre2ze4k"
    [1]="hd11"
    [2]="hd51"
    [3]="hd60"
    [4]="hd61"
    [5]="hd66se"
    [6]="hd500c"
    [7]="hd530c"
    [8]="hd1100"
    [9]="hd1200"
    [10]="hd1265"
    [11]="hd1500"
    [12]="hd2400"
    [13]="vs1000"
    [14]="vs1500"
)

declare -A MODELS_Gi=(
    [0]="et1x000"  # Fixed: was et1x00
    [1]="et7000mini"
)

declare -A MODELS_Gigablue=(
    [0]="gbquad4k"
    [1]="gbtrio4k"
    [2]="gbue4k"
    [3]="gbtrio4kpro"  # Added missing model
)

declare -A MODELS_Maxytec=(
    [0]="multibox"
    [1]="multiboxpro"
    [2]="multiboxse"
)

declare -A MODELS_Miraclebox=(
    [0]="mbmicro"
    [1]="mbmicrov2"
    [2]="mbtwinplus"
)

declare -A MODELS_Octagon=(
    [0]="sfx6008"
    [1]="sf8008"
    [2]="sf8008m"
    [3]="sx88v2"
)

declare -A MODELS_Qviart=(
    [0]="dual"
    [1]="lunix"      # Added
    [2]="lunix3-4k"  # Added
    [3]="lunix4k"    # Added
)

declare -A MODELS_Sab=(
    [0]="alphatriplehd"
)

declare -A MODELS_Spycat=(
    [0]="spycatmini"
    [1]="spycat"
    [2]="spycatminiplus"
)

declare -A MODELS_Technomate=(
    [0]="tmnano3tcombo"
    [1]="tmnano3tcombo4k"
)

declare -A MODELS_Uclan=(
    [0]="ustym4kpro"
    [1]="ustym4ks2ottx"
)

declare -A MODELS_Vuplus=(
    [0]="vuduo"
    [1]="vuduo2"
    [2]="vuduo4k"
    [3]="vuduo4kse"
    [4]="vusolo"
    [5]="vusolo2"
    [6]="vusolo4k"
    [7]="vusolose"
    [8]="vuultimo"
    [9]="vuultimo4k"
    [10]="vuuno"
    [11]="vuuno4k"
    [12]="vuuno4kse"
    [13]="vuzero"
    [14]="vuzero4k"
)

declare -A MODELS_Xp=(
    [0]="xp1000"
)

declare -A MODELS_Xpeedc=(
    [0]="xpeedc"
)

declare -A MODELS_Xsarius=(
    [0]="fusionhd"
    [1]="fusionhdse"
    [2]="galaxy4k"
    [3]="purehd"
    [4]="purehdse"
    [5]="revo4k"
)

declare -A MODELS_Xtrend=(
    [0]="et4x00"
    [1]="et5x00"
    [2]="et6x00"
    [3]="et7x00"
    [4]="et8x00"
    [5]="et9x00"
    [6]="et8000"
    [7]="et8500"
    [8]="et10000"
)

declare -A MODELS_Zgemma=(
    [0]="sh1"
    [1]="h3"
    [2]="h4"
    [3]="h5"
    [4]="h6"         # Added
    [5]="h7"
    [6]="h8"
    [7]="h9"
    [8]="h9combo"
    [9]="h9combose"
    [10]="h9se"
    [11]="h10"
    [12]="h10se"
    [13]="h11"
    [14]="h17"
    [15]="h17twin"
    [16]="hzero"
    [17]="i55"
    [18]="i55plus"
    [19]="i55se"
    [20]="lc"
)

# Sort producers in alphabetical order
sorted_producers=($(for p in "${!PRODUCERS[@]}"; do echo "$p ${PRODUCERS[$p]}"; done | sort -k2 | cut -d ' ' -f 1))

# Dialog to select the manufacturer
list=()
for i in "${!sorted_producers[@]}"; do
    list+=("$i" "${PRODUCERS[$i]}")
done

producer=$(dialog --stdout --clear --backtitle "Image Builder by Lululla" --menu "Image Builder by Lululla\nSelect Manufacturer" 40 50 40 "${list[@]}")

[ -z "$producer" ] && clear && exit

# Assign models based on the selected producer
case ${PRODUCERS[$producer]} in
    "Abcom") models=("${MODELS_Abcom[@]}") ;;
    "Amiko") models=("${MODELS_Amiko[@]}") ;;
    "Axas") models=("${MODELS_Axas[@]}") ;;
    "Dream") models=("${MODELS_Dream[@]}") ;;
    "Edision") models=("${MODELS_Edision[@]}") ;;
    "Formuler") models=("${MODELS_Formuler[@]}") ;;
    "Gfutures") models=("${MODELS_Gfutures[@]}") ;;
    "Gi") models=("${MODELS_Gi[@]}") ;;
    "Gigablue") models=("${MODELS_Gigablue[@]}") ;;
    "Maxytec") models=("${MODELS_Maxytec[@]}") ;;
    "Miraclebox") models=("${MODELS_Miraclebox[@]}") ;;
    "Octagon") models=("${MODELS_Octagon[@]}") ;;
    "Qviart") models=("${MODELS_Qviart[@]}") ;;
    "Sab") models=("${MODELS_Sab[@]}") ;;
    "Spycat") models=("${MODELS_Spycat[@]}") ;;
    "Technomate") models=("${MODELS_Technomate[@]}") ;;
    "Uclan") models=("${MODELS_Uclan[@]}") ;;
    "Vuplus") models=("${MODELS_Vuplus[@]}") ;;
    "Xp") models=("${MODELS_Xp[@]}") ;;
    "Xpeedc") models=("${MODELS_Xpeedc[@]}") ;;
    "Xsarius") models=("${MODELS_Xsarius[@]}") ;;
    "Xtrend") models=("${MODELS_Xtrend[@]}") ;;
    "Zgemma") models=("${MODELS_Zgemma[@]}") ;;
    *) clear && exit ;;
esac

# Sort models alphabetically
sorted_models=($(for m in "${!models[@]}"; do echo "$m ${models[$m]}"; done | sort -k2 | cut -d ' ' -f 1))

# Dialog to select the model
list=()
for i in "${!sorted_models[@]}"; do
    list+=("$i" "${models[$i]}")
done

model=$(dialog --stdout --clear --menu "Select Model ${PRODUCERS[$producer]}" 40 50 40 "${list[@]}")
[ -z "$model" ] && clear && exit

selected_model=${models[$model]}
print_message "info" "Building image for ${PRODUCERS[$producer]} $selected_model..."

# Add dialog to select between Image or Feed
build_option=$(dialog --stdout --clear --menu "Select Build Option" 40 50 2 \
    "1" "Image" \
    "2" "Feed")

[ -z "$build_option" ] && clear && exit

# Build based on the selected option

case $build_option in
    1)
        print_message "info" "Starting build for ${selected_model} as image..."
        make update && MACHINE=${selected_model} make image
        
        # Rinomina il file ZIP
        rename_zip_file "$selected_model"
        ;;

    # 1)
        # print_message "info" "Starting build for ${selected_model} as image..."
        # make update && MACHINE=${selected_model} make image
        # ;;
    2)
        print_message "info" "Starting build for ${selected_model} as feed..."
        make update && MACHINE=${selected_model} make feed
        ;;
    *)
        print_message "error" "Invalid selection. Exiting..."
        exit 1
        ;;
esac

exit 0