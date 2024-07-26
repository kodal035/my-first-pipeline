#!/bin/bash

# Sistem paketlerini güncelle
echo "Sistem paketlerini güncelliyor..."
sudo apt update

# Fontconfig ve OpenJDK 17'yi kur
echo "Fontconfig ve OpenJDK 17'yi kuruyor..."
sudo apt install -y fontconfig openjdk-17-jre

# Java sürümünü kontrol et
echo "Java sürümünü kontrol ediyor..."
java -version

# GPG anahtarını yeniden indir ve yükle
echo "Jenkins GPG anahtarını yeniden indiriyor ve yüklüyor..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Jenkins depo kaydını güncelle
echo "Jenkins depo kaydını güncelliyor..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Paket bilgilerini güncelle
echo "Paket bilgilerini güncelliyor..."
sudo apt-get update

# Jenkins'i kur
echo "Jenkins kurulumu başlatılıyor..."
sudo apt-get install -y jenkins

# Jenkins servisinin sistem açılışında otomatik başlatılmasını sağla
echo "Jenkins servisinin otomatik başlatılmasını sağlıyor..."
sudo systemctl enable jenkins

# Jenkins servisinin hemen başlatılmasını sağla
echo "Jenkins servisi başlatılıyor..."
sudo systemctl start jenkins

# Jenkins için gerekli groovy betiklerini oluşturma dizini
echo "Jenkins groovy betik dizini oluşturuluyor..."
sudo mkdir -p /var/lib/jenkins/init.groovy.d

# Admin kullanıcısı oluşturma betiği
echo "Admin kullanıcısı oluşturuluyor..."
sudo bash -c 'cat > /var/lib/jenkins/init.groovy.d/createAdminUser.groovy' << 'EOF'
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "password")
instance.setSecurityRealm(hudsonRealm)
instance.save()
EOF

# Jenkins'i yeniden başlatma
echo "Jenkins yeniden başlatılıyor..."
sudo systemctl restart jenkins

sleep 100

# Jenkins - Kubernetes()minikube integration...

sudo mkdir -p /var/lib/jenkins/.kube
sudo cp ~/.kube/config /var/lib/jenkins/.kube/config
sudo chown jenkins:jenkins /var/lib/jenkins/.kube/config
sudo chmod 600 /var/lib/jenkins/.kube/config



# Gerekli Jenkins eklentilerini kur
# echo "Jenkins eklentilerini kuruyor..."
# java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:password install-plugin git maven-plugin pipeline docker-workflow


# Job oluşturuluyor ve build ediliyor. 

java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:password create-job my-first-pipeline < ./pipeline-job-config.xml
sudo mkdir -p /var/lib/jenkins/workspace/my-first-pipeline
# sudo cp nginx-deployment-service.yaml /var/lib/jenkins/workspace/my-first-pipeline/

sudo cp productcatalogue-service.yaml /var/lib/jenkins/workspace/my-first-pipeline/
sudo cp shopfront-service.yaml /var/lib/jenkins/workspace/my-first-pipeline/
sudo cp stockmanager-service.yaml /var/lib/jenkins/workspace/my-first-pipeline/

echo $?
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:password build my-first-pipeline

# sleep 30
# echo "You can reach nginx through URL: "
# echo "wait for nginx URL: "
# sleep 30
# minikube service nginx-service
