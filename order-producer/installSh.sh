
#!/bin/bash
set -Eeuo pipefail

# ==================================================
# Order Producer - EC2 Ubuntu
# Java 21 + Maven + Docker
# ==================================================

exec > >(tee -a /var/log/order-producer-userdata.log) 2>&1

echo "=== Inicio da preparacao: $(date -Is) ==="

# 1. Atualizar o sistema
apt-get update -y
apt-get upgrade -y

# 2. Instalar ferramentas
apt-get install -y \
  git \
  openjdk-21-jdk \
  maven \
  docker.io \
  ca-certificates

# 3. Ativar Docker
systemctl enable --now docker

# 4. Validar ferramentas
java -version
mvn -version
git --version
docker --version

# 5. Configurar repositorio GitHub
REPO_URL="https://github.com/ThiarllesMaster/order-producer.git"
APP_DIR="/opt/order-producer"

mkdir -p /opt

if [ ! -d "${APP_DIR}/.git" ]; then
    git clone "${REPO_URL}" "${APP_DIR}"
else
    echo "Repositorio ja existe: ${APP_DIR}"
fi

cd "${APP_DIR}"

# 6. Compilar a aplicacao Spring Boot
if [ -f "./mvnw" ]; then
    chmod +x ./mvnw
    ./mvnw clean package -DskipTests
else
    mvn clean package -DskipTests
fi

# 7. Criar Dockerfile apenas se nao existir
if [ ! -f Dockerfile ]; then
    cat > Dockerfile <<'EOF'
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF
fi

# 8. Construir imagem Docker
docker build -t order-producer:1.0 .

# 9. Mostrar resultado
echo "=== Imagem Docker criada ==="
docker images order-producer

echo "=== Preparacao concluida: $(date -Is) ==="
