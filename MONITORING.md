📊 Monitoring & Observabilité

## Objectif

Mettre en place une stack d’observabilité pour surveiller une application conteneurisée (NestJS / Vue / Postgres).

## Monitoring vs Observabilité

* **Monitoring** : surveiller l’état du système (CPU, erreurs, uptime)
* **Observabilité** : comprendre le comportement interne du système grâce aux données collectées


## Les 3 piliers

* **Métriques** : données numériques (CPU, nombre de requêtes)
* **Logs** : événements textuels (erreurs, actions utilisateur)
* **Traces** : suivi d’une requête (non implémenté ici)


## Composants utilisés

### Prometheus

* Collecte les métriques
* Scrape les services (ex: backend NestJS)
* Accessible sur : http://localhost:9090

### Grafana

* Visualisation des données
* Création de dashboards
* Accessible sur : http://localhost:3000

### Loki

* Stockage des logs
* Optimisé pour logs applicatifs
* Port : 3100 (interne)

### Promtail

* Agent de collecte des logs
* Envoie les logs vers Loki

## Architecture

```
[NestJS Backend] ---> Prometheus ---> Grafana
        |
        v
     Promtail ---> Loki ---> Grafana
```


## Intégration avec l’application

* Le backend expose un endpoint `/metrics`
* Prometheus récupère ces métriques
* Promtail collecte les logs Docker
* Grafana centralise métriques + logs

## Ports utilisés

* Grafana : http://localhost:3000
* Prometheus : http://localhost:9090
* Loki : http://localhost:3100 (interne)
