# PLAN BLUE/GREEN DEPLOYMENT

## Objectif

Mettre en place une stratégie de déploiement blue/green permettant :

* zéro downtime
* rollback instantané
* coexistence de deux versions de l’application


## Architecture

### Fichiers Docker Compose

* `docker-compose.base.yml`

  * Postgres (base de données partagée)
  * Reverse proxy (Nginx)

* `docker-compose.blue.yml`

  * backend-blue
  * frontend-blue

* `docker-compose.green.yml`

  * backend-green
  * frontend-green



## Lancement

### Démarrage de l’infrastructure

```bash
docker compose -f docker-compose.base.yml up -d
```

### Déploiement version blue

```bash
docker compose -f docker-compose.base.yml -f docker-compose.blue.yml up -d
```

### Déploiement version green

```bash
docker compose -f docker-compose.base.yml -f docker-compose.green.yml up -d
```

## Stratégie de bascule

Le reverse proxy Nginx utilise un fichier de configuration pour déterminer la version active :

* `blue` → route vers backend-blue
* `green` → route vers backend-green

La bascule se fait en :

1. modifiant la config Nginx
2. rechargeant Nginx (`nginx -s reload`)


## Scénario de déploiement

### Situation initiale

* Version active : **blue**

### Nouveau déploiement

1. Déployer la nouvelle version sur **green**
2. Vérifier que green fonctionne
3. Basculer le proxy vers **green**
4. (optionnel) arrêter blue


## Rollback

En cas de problème :

1. remettre la config proxy sur **blue**
2. recharger Nginx

rollback instantané sans redéploiement


## Avantages

* zéro interruption utilisateur
* rollback immédiat
* isolation des versions
* compatible CI/CD
