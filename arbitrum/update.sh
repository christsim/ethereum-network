mkdir -p /opt/data/arbitrum
chown -R 1000:1000 /opt/data/arbitrum

mkdir -p /opt/data/jwtsecret
chown -R 1000:1000 /opt/data/jwtsecret

docker-compose pull
docker-compose down
docker-compose up -d

