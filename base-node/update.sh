mkdir -p /opt/data/base-node
chown -R 1000:1000 /opt/data/base-node

mkdir -p /opt/data/jwtsecret
chown -R 1000:1000 /opt/data/jwtsecret

docker-compose pull
docker-compose down
docker-compose up -d
