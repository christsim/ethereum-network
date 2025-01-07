mkdir -p /opt/data/lighthouse-beacon
chown -R 1000:1000 /opt/data/lighthouse-beacon

mkdir -p /opt/data/jwtsecret
chown -R 1000:1000 /opt/data/jwtsecret

docker-compose pull
docker-compose down
docker-compose up -d
