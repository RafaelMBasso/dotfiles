#!/usr/bin/env bash

BAT="/sys/class/power_supply/BAT0"

CRIT=15
WARN=30

NOTIFIED="$HOME/.cache/battery_notified"
STATEFILE="$HOME/.cache/battery_state"

STATUS=$(<"$BAT/status")
CAPACITY=$(<"$BAT/capacity")

# ---------- Detecta mudança de estado ----------

LAST_STATUS=$(cat "$STATEFILE" 2>/dev/null)

if [[ "$STATUS" != "$LAST_STATUS" ]]; then

    case "$STATUS" in
        Charging)
            notify-send \
                -u low \
                -i battery-good \
                "Carregador conectado" \
                "Carregando (${CAPACITY}%)."
            ;;

        Discharging)
            notify-send \
                -u low \
                -i battery \
                "Carregador desconectado" \
                "Restam ${CAPACITY}% de bateria."
            ;;

        Full)
            notify-send \
                -u normal \
                -i battery-full \
                "Bateria carregada" \
                "A bateria atingiu 100%."
            ;;
    esac

    echo "$STATUS" > "$STATEFILE"
fi

# ---------- Verifica bateria baixa ----------

if [[ "$STATUS" == "Discharging" ]]; then

    if (( CAPACITY <= CRIT )); then

        if [[ ! -f "$NOTIFIED" ]]; then
            notify-send \
                -u critical \
                -i battery-caution \
                "Bateria crítica" \
                "Restam apenas ${CAPACITY}%."

            touch "$NOTIFIED"
        fi

    elif (( CAPACITY <= WARN )); then

        if [[ ! -f "$NOTIFIED" ]]; then
            notify-send \
                -u normal \
                -i battery-low \
                "Bateria baixa" \
                "Carga atual: ${CAPACITY}%."

            touch "$NOTIFIED"
        fi

    else
        rm -f "$NOTIFIED"
    fi

else
    rm -f "$NOTIFIED"
fi