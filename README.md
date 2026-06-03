# Впровадження практик DevOps для підвищення ефективності розробки програмного забезпечення
**Кваліфікаційна робота бакалавра**

## Опис проєкту
Даний проєкт демонструє реалізацію сучасного DevOps-конвеєра для автоматизації процесів розробки, тестування, контейнеризації, розгортання та моніторингу програмного забезпечення.

Рішення побудоване на основі принципів:
*   Infrastructure as Code (IaC);
*   Continuous Integration / Continuous Deployment (CI/CD);
*   GitOps;
*   Cloud-Native Architecture;
*   Kubernetes Orchestration;
*   DevSecOps.

Проєкт включає автоматизоване створення інфраструктури в Google Cloud Platform, розгортання Kubernetes-кластера, контейнеризацію застосунку мовою Go, реалізацію Canary Deployment та систему моніторингу.

---

## Використані технології

### 🌐 Хмарна інфраструктура
*   **Google Cloud Platform (GCP)**
*   **Google Kubernetes Engine (GKE)**

### 🛠️ Infrastructure as Code
*   **Terraform**
*   **Terragrunt**

### 📦 Контейнеризація
*   **Docker**

### ☸️ Оркестрація контейнерів
*   **Kubernetes**
*   **Helm**

### 🔄 CI/CD та GitOps
*   **GitLab або GitHub**
*   **Jenkins**
*   **ArgoCD**
*   **Argo Rollouts**

### 🗄️ Реєстр артефактів
*   **Sonatype Nexus Repository Manager** або **Docker Hub**

### 📊 Моніторинг
*   **Prometheus**
*   **Grafana**

### 🛡️ DevSecOps
*   **OWASP Dependency-Check**
*   **Trivy**

### 🐹 Мова програмування
*   **Go (Golang)**

---

## Архітектура рішення

```
Розробник
   │
   ▼
GitLab / GitHub
   │
   ▼
Jenkins
   │
   ├── Unit Tests
   ├── OWASP Scan
   ├── Trivy Scan
   └── Docker Build
   │
   ▼
Nexus / Docker Hub
   │
   ▼
GitOps Repository
   │
   ▼
ArgoCD
   │
   ▼
Kubernetes (GKE)
   │
   ▼
Go Application
   │
   ▼
Prometheus + Grafana
```

---

## Структура файлів

```
/diploma-project
│
├── 1-infrastructure/                 # Інфраструктура як код (IaC)
│   ├── root.hcl                      # Провайдер GCP та Remote State
│   │
│   ├── modules/                      # Terraform/Terragrunt модулі
│   │   ├── argo-rollouts/
│   │   │   └── main.tf               # Встановлення Argo Rollouts
│   │   ├── argocd/
│   │   │   └── main.tf               # Встановлення ArgoCD
│   │   ├── cert-manager/
│   │   │   └── main.tf               # Сертифікати Let's Encrypt
│   │   ├── gitlab/
│   │   │   └── main.tf               # Розгортання GitLab
│   │   ├── ingress-nginx/
│   │   │   └── main.tf               # NGINX Ingress Controller
│   │   ├── jenkins/
│   │   │   └── main.tf               # Jenkins CI Server
│   │   ├── nexus/
│   │   │   └── main.tf               # Sonatype Nexus Repository
│   │   ├── prometheus-grafana/
│   │   │   └── main.tf               # Моніторинг та Observability
│   │   └── sonar-qube/
│   │       └── main.tf               # SonarQube для аналізу коду
│   │
│   └── prod/                         # Production середовище
│       ├── argo-rollouts/
│       │   └── terragrunt.hcl        # Конфігурація Argo Rollouts
│       ├── argocd/
│       │   └── terragrunt.hcl        # Конфігурація ArgoCD
│       ├── cert-manager/
│       │   └── terragrunt.hcl        # Сертифікати та Issuer
│       ├── gitlab/
│       │   └── terragrunt.hcl        # Розгортання GitLab
│       ├── gke/
│       │   └── terragrunt.hcl        # Kubernetes-кластер GKE
│       ├── ingress-nginx/
│       │   └── terragrunt.hcl        # NGINX Ingress Controller
│       ├── jenkins/
│       │   └── terragrunt.hcl        # Jenkins CI Server
│       ├── network/
│       │   └── terragrunt.hcl        # VPC та мережева інфраструктура
│       ├── nexus/
│       │   └── terragrunt.hcl        # Sonatype Nexus Repository
│       ├── prometheus-grafana/
│       │   └── terragrunt.hcl        # Prometheus та Grafana
│       ├── services/
│       │   └── terragrunt.hcl        # Допоміжні GCP-сервіси
│       └── sonar-qube/
│           └── terragrunt.hcl        # SonarQube для аналізу якості коду
│
├── 2-go-app/                         # Вихідний код застосунку
│   ├── main.go                       # Основна логіка веб-сервісу
│   ├── main_test.go                  # Модульні тести
│   ├── go.mod                        # Залежності Go
│   ├── Dockerfile                    # Контейнеризація застосунку
│   └── Jenkinsfile                   # Опис CI/CD-конвеєра
│
├── 3-k8s-manifests/                  # GitOps-маніфести Kubernetes
│   ├── namespace.yaml                # Створення окремого namespace для проєкту
│   ├── rollout.yaml                  # Canary Deployment через Argo Rollouts
│   ├── service-stable.yaml           # Сервіс для стабільної версії застосунку
│   ├── service-canary.yaml           # Сервіс для Canary-версії застосунку
│   ├── argocd-app.yaml               # Реєстрація застосунку в ArgoCD
│   ├── app-ingress.yaml              # Ingress для доступу до застосунку
│   ├── argocd-ingress.yaml           # Ingress для ArgoCD
│   ├── argo-rollouts-ingress.yaml    # Ingress для Argo Rollouts Dashboard
│   ├── grafana-ingress.yaml          # Ingress для Grafana
│   ├── prometheus-ingress.yaml       # Ingress для Prometheus
│   ├── jenkins-ingress.yaml          # Ingress для Jenkins
│   ├── jenkins-servicemonitor.yaml   # Моніторинг Jenkins через Prometheus
│   └── sonarqube-ingress.yaml        # Ingress для SonarQube
│
├── docs/                             # Матеріали дипломної роботи
│   ├── architecture.png              # Архітектура інфраструктури
│   ├── cicd-pipeline.png             # Схема CI/CD-конвеєра
│   ├── grafana-dashboard.png         # Моніторинг у Grafana
│   └── canary-deployment.png         # Процес Canary Deployment
│
└── README.md
```

---

## Реалізовані можливості
1.  Автоматичне створення інфраструктури через Terraform та Terragrunt.
2.  Автоматичне розгортання Kubernetes-кластера.
3.  Контейнеризація застосунку за допомогою Docker.
4.  Автоматичне тестування через Jenkins.
5.  Зберігання Docker-образів у Nexus або Docker Hub.
6.  GitOps-розгортання через ArgoCD.
7.  Canary Deployment через Argo Rollouts.
8.  Моніторинг та спостережливість через Prometheus і Grafana.
9.  Перевірка безпеки залежностей через OWASP Dependency-Check.
10. Сканування контейнерних образів через Trivy.

---

## Автор
**Andreas Prinz**  
Факультет кібербезпеки, програмної інженерії та комп'ютерних наук  
*Міжнародний університет*  
**2026**
