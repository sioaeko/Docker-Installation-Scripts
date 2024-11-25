#!/bin/bash

# 스크립트를 root 권한으로 실행했는지 확인
if [ "$EUID" -ne 0 ]; then 
    echo "이 스크립트는 root 권한으로 실행해야 합니다."
    echo "다음 명령어로 다시 실행해주세요: sudo bash $0"
    exit 1
fi

# 시스템 패키지 업데이트
echo "시스템 패키지를 업데이트하는 중..."
apt-get update
apt-get upgrade -y

# 필요한 패키지 설치
echo "필요한 패키지를 설치하는 중..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker의 공식 GPG 키 추가
echo "Docker의 공식 GPG 키를 추가하는 중..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Docker 리포지토리 설정
echo "Docker 리포지토리를 설정하는 중..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 패키지 목록 업데이트
apt-get update

# Docker 설치
echo "Docker를 설치하는 중..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Docker Compose 설치
echo "Docker Compose를 설치하는 중..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# 현재 사용자를 docker 그룹에 추가
USER_NAME=$(logname)
usermod -aG docker $USER_NAME

# 설치 확인
echo "설치 버전 확인 중..."
docker --version
docker compose version

echo "설치가 완료되었습니다!"
echo "시스템을 재시작하거나 다음 명령어를 실행하여 docker 그룹 변경사항을 적용하세요:"
echo "newgrp docker"
