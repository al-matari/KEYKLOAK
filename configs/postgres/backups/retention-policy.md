# Postgres Backup Retention

- Lokal: nur ad-hoc Dumps fuer Tests und Recovery-Uebungen.
- Stage: taegliche Backups, Aufbewahrung 14 Tage.
- Prod: taegliche Vollbackups plus regelmaessige PITR-Sicherungen gemaess Betriebsanforderung.
