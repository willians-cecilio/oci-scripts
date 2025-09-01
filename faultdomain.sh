#!/bin/bash

INSTANCE_ID="ocid1........"
OCI="/root/bin/oci"

# Coleta os dados da instancia
output=$($OCI compute instance get --instance-id "$INSTANCE_ID")

state=$(echo "$output" | jq -r '.data."lifecycle-state"')
fault_domain=$(echo "$output" | jq -r '.data."fault-domain"')

echo "Estado atual: $state"
echo "FD atual: $fault_domain"

# Verifica se a instacia esta parada
if [[ "$state" == "STOPPED" ]]; then
    # Rotaciona o fault domain
    case "$fault_domain" in
        "FAULT-DOMAIN-1") new_domain="FAULT-DOMAIN-2" ;;
        "FAULT-DOMAIN-2") new_domain="FAULT-DOMAIN-3" ;;
        "FAULT-DOMAIN-3") new_domain="FAULT-DOMAIN-1" ;;
        *) new_domain="$fault_domain" ;;
    esac

    echo "Alterando o FD para: $new_domain"
    $OCI compute instance update \
        --instance-id "$INSTANCE_ID" \
        --fault-domain "$new_domain"

    echo "Aguardando 5 minutos antes de iniciar novamente..."
    sleep 300

    echo "Inicializando instancia..."
    $OCI compute instance action \
        --instance-id "$INSTANCE_ID" \
        --action START
else
    echo "A instancia esta $state, nada sera alterado."
fi
