cat latest.dump | docker-compose exec -T db pg_restore -d myapp_development -U postgres
