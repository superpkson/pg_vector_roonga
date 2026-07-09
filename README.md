```bash
docker run -d -p 5432:5432 -v postgres:/var/lib/postgres -e POSTGRES_PASSWORD=postgres --restart unless-stopped ghcr.io/superpkson/pg_vr:latest
```
