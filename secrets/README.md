# Secrets

Diese Verzeichnisse sind nur Platzhalter fuer umgebungsspezifische Secrets.

- Keine echten Zugangsdaten committen.
- Lokal reicht fuer den Start in der Regel `.env.local`.
- `scripts/bootstrap/create-secrets.sh` kann lokale Platzhalterdateien unter `secrets/dev/` erzeugen.
- Fuer spaetere `dev`, `stage` und `prod` Setups koennen hier verschluesselte oder extern referenzierte Secrets abgelegt werden.
