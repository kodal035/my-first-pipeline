#!/bin/bash

# Dosya yolunu tanımlayın
kube_config_path="/home/ubuntu/.kube/config"

# Key değerlerini kontrol et ve gerekirse değiştir
if sudo grep -q "certificate-authority:" "$kube_config_path"; then
    sudo sed -i "s|certificate-authority:|certificate-authority-data:|g" "$kube_config_path"
fi

if sudo grep -q "client-certificate:" "$kube_config_path"; then
    sudo sed -i "s|client-certificate:|client-certificate-data:|g" "$kube_config_path"
fi

if sudo grep -q "client-key:" "$kube_config_path"; then
    sudo sed -i "s|client-key:|client-key-data:|g" "$kube_config_path"
fi

echo "Kube config dosyasındaki key değerleri başarıyla güncellendi."

# Base64 kodlama ile değerleri oluşturun
ca_crt_path="/home/ubuntu/.minikube/ca.crt"
client_crt_path="/home/ubuntu/.minikube/profiles/minikube/client.crt"
client_key_path="/home/ubuntu/.minikube/profiles/minikube/client.key"

ca_cert_data=$(sudo cat "$ca_crt_path" | base64 -w 0)
client_cert_data=$(sudo cat "$client_crt_path" | base64 -w 0)
client_key_data=$(sudo cat "$client_key_path" | base64 -w 0)

# `config` dosyasındaki değerleri güncelleyin
sudo sed -i "s|certificate-authority-data: .*|certificate-authority-data: $ca_cert_data|" "$kube_config_path"
sudo sed -i "s|client-certificate-data: .*|client-certificate-data: $client_cert_data|" "$kube_config_path"
sudo sed -i "s|client-key-data: .*|client-key-data: $client_key_data|" "$kube_config_path"

echo "Kube config dosyasındaki tüm gerekli değerler başarıyla güncellendi."

sudo chmod 644 /home/ubuntu/.kube/config
chmod +x update_kube_config.sh
