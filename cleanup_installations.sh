#!/bin/bash

# Docker kaldırma işlemleri
echo "Docker'ı kaldırıyor..."

# Docker servislerini durdur
sudo systemctl stop docker
sudo systemctl stop docker.socket

# Docker paketlerini kaldır
sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt-get autoremove -y
sudo apt-get clean

# Kalan Docker dosyalarını sil
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Docker grubunu kaldır
sudo groupdel docker

# Docker ile ilgili kullanıcıyı kaldır
# sudo userdel -r dockeruser # Yalnızca gerekiyorsa

# Jenkins kaldırma işlemleri
echo "Jenkins'i kaldırıyor..."
sudo systemctl stop jenkins
sudo apt-get remove --purge -y jenkins
sudo apt-get autoremove -y
sudo apt-get clean

# Minikube ve kubectl kaldırma işlemleri
echo "Minikube'u ve kubectl'i kaldırıyor..."
sudo rm /usr/local/bin/minikube
sudo rm /usr/local/bin/kubectl

# Kubernetes konfigürasyon dosyasını sil
echo "Kubernetes konfigürasyon dosyasını siliyor..."
rm -rf ~/.kube/config

# Minikube kaynakları temizleme
echo "Minikube kaynaklarını temizliyor..."
minikube delete

# Jenkins groovy betiklerini ve yapılandırma dosyalarını sil
echo "Jenkins groovy betiklerini ve yapılandırma dosyalarını siliyor..."
sudo rm -rf /var/lib/jenkins/init.groovy.d
sudo rm -rf /var/lib/jenkins/.kube

# Kubectl siliniyor

sudo apt-get remove -y kubectl

echo "Temizlik işlemi tamamlandı."


