____

# TP 1 : Workflow Git & Qualité du Code

## 1/ Règles Git

Ce projet suit un workflow structuré pour garantir un historique propre et un développement collaboratif efficace.

### Branches principales
- `main` → version stable et prête au déploiement  
- `develop` → environnement d’intégration, reçoit les fonctionnalités validées

### Branches de développement
Toute nouvelle fonctionnalité doit être développée dans une branche dédiée : `feature/<nom-de-la-feature>`

Exemple : `feature/auth-login`

### Pull Requests obligatoires
- Toute feature doit être fusionnée via une **Pull Request vers `develop`**
- Revue obligatoire
- Pas de merge direct sans validation

### 🚫 Actions interdites
- ❌ Aucun commit direct sur `main`
- ❌ Aucun commit direct sur `develop`
- ❌ Pas de merge commit si "Require linear history" est activé

### Rule protection screenshot

![rules](screenshots/tp1_rules.png)

## 2/ Convention de commit (Commitlint)

Le projet suit le standard **Conventional Commits** pour maintenir des messages de commit clairs et exploitables.

### Exemples valides
- `feat: add authentication`
- `fix: fix PostgreSQL connection issue`
- `refactor: simplify user service`
- `docs: add Git rules to README`
- `chore: update dependencies`

### Types les plus utilisés
- `feat`: nouvelle fonctionnalité  
- `fix`: correction de bug  
- `refactor`: amélioration interne du code  
- `docs`: documentation  
- `chore`: tâches diverses (MAJ dépendances, config…)  
- `test`: ajout ou mise à jour des tests  


## 3/ Hooks Husky actifs

Afin de garantir la qualité du code avant chaque commit, le projet utilise **Husky** et **Commitlint**.

### Hook `pre-commit`
Exécute automatiquement :
- Lint du **frontend**
- Lint du **backend**

➡️ Le commit est bloqué si des erreurs ESLint sont détectées.

### Hook `commit-msg`
Vérifie automatiquement que le message de commit respecte Conventional Commits.

➡️ Un commit avec un message non conforme est refusé.

____

# TP2 – Intégration Continue (CI) : Build, Lint, Tests & Analyse automatisée

### Captures : 
- Runner local
![alt text](screenshots/tp2_1.png)

- Tableau de bord Sonar 
![alt text](screenshots/tp2_2.png)

- PR bloqué
![alt text](screenshots/tp2_3.png)

- Quality Gate enfin passé (une fois supprimé 🤡)
![alt text](screenshots/tp2_4.png)

- Tests CI passés
![alt text](screenshots/tp2_5.png)

[![SonarQube Cloud](https://sonarcloud.io/images/project_badges/sonarcloud-light.svg)](https://sonarcloud.io/summary/new_code?id=anastasiiaal_TP_DevSecOps)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=anastasiiaal_TP_DevSecOps&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=anastasiiaal_TP_DevSecOps)


____

# TP3 – Dockerisation et orchestration

### Screenhots
- Docker de backend lancé
![alt text](screenshots/tp3_1.png)

- Docker frontend lancé
![alt text](screenshots/tp3_2.png)

- Les deux sur Docker desktop
![alt text](screenshots/tp3_3.png)

- Première connexion sur http://localhost:8080/login (pas de BDD encore)
![alt text](screenshots/tp3_4.png)

- Docker compose up lancé
![alt text](screenshots/tp3_5.1.png)
![alt text](screenshots/tp3_5.2.png)
![alt text](screenshots/tp3_5.3.png)

- App après l'ajout de la BDD & seeds
![alt text](screenshots/tp3_6.png)

- Containers sur Docker desktop
![alt text](screenshots/tp3_7.png)
![alt text](screenshots/tp3_8.png)

- Secrets du repo
![alt text](screenshots/tp3_9.png) 

- Images dans le registre
![alt text](screenshots/tp3_10.png)

- Tous les jobs passés
![alt text](screenshots/tp3_11.png)


## Liens images
- Image backend : ghcr.io/anastasiiaal/cloudnative-backend:52a81481d90206efe287db5f0efa257d9fddaa64
- Image frontend : ghcr.io/anastasiiaal/cloudnative-frontend:52a81481d90206efe287db5f0efa257d9fddaa64
____

# TP4 – Déploiement automatique de l’application depuis la CI locale

### Déploiement local automatisé

Le projet intègre un pipeline CI/CD complet exécuté sur un runner local self-hosted.

### Workflow global
````
lint → build → tests → sonar → docker-images → deploy
````

Le stage deploy est exécuté automatiquement après la construction et la publication des images Docker.


## Propriétés du déploiement

- Le déploiement est automatique et lancé depuis GitHub Actions.
- Il est exécuté sur un runner local self-hosted.
- Il est idempotent : il peut être relancé plusieurs fois sans erreur.
- Les données Postgres sont conservées, car aucune option destructrice n’est utilisée.
- Les images sont récupérées depuis le registre distant GHCR avant redémarrage de la stack.

## Déploiement automatisé

Pour mettre en place le déploiement automatique, il faut :

1. **Créer le script `/scripts/deploy.ps1`**
   - ce script contient la logique de déploiement :
     - arrêt des conteneurs existants,
     - récupération des images Docker depuis le registre,
     - redémarrage de la stack avec Docker Compose.

2. **Ajouter le job `deploy` dans le fichier `/.github/workflows/ci.yml`**
   - ce job est exécuté après le build et le push des images Docker,
   - il appelle automatiquement le script `scripts/deploy.ps1`.

3. **Générer et lancer un runner local self-hosted**
   - le runner doit être configuré sur le dépôt GitHub,
   - il doit être démarré localement avec `run.cmd`,
   - il permet d’exécuter le pipeline directement sur la machine locale.

## Résultat

Une fois ces éléments configurés :

- le pipeline GitHub Actions exécute automatiquement le job `deploy`,
- le déploiement se lance sans intervention manuelle,
- la stack est redémarrée depuis les images publiées dans le registre.

## Captures
- Runner crée
![alt text](screenshots/tp4_3.png)

- Runner configuré en local
![alt text](screenshots/tp4_2.png)

- Pipeline automatique exécuté avec succès  
![alt text](screenshots/tp4_4.png)

⚠️ Déploiement déclenché automatiquement lors des push sur la branche `main` et des merge requests

____

