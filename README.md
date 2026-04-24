# 🚀 DevOps Demo Platform

![CI](https://img.shields.io/badge/CI-GitHub_Actions-blue)
![CD](https://img.shields.io/badge/CD-ArgoCD-orange)
![IaC](https://img.shields.io/badge/IaC-Terraform-purple)
![Cloud](https://img.shields.io/badge/Cloud-Azure-0078D4)
![Kubernetes](https://img.shields.io/badge/K8s-AKS-326CE5)
![License](https://img.shields.io/badge/license-MIT-green)

A production-style **end-to-end DevOps pipeline** deploying a containerized application to **Azure Kubernetes Service (AKS)** using:

* **Terraform** → Infrastructure provisioning
* **GitHub Actions** → CI pipeline
* **Docker + ACR** → Image build & registry
* **Helm** → Kubernetes packaging
* **ArgoCD** → GitOps continuous delivery

---

# 🏗️ Architecture

```text
                ┌────────────────────────────┐
                │        Developer           │
                │   (Push to GitHub Repo)   │
                └────────────┬──────────────┘
                             │
                             ▼
                ┌────────────────────────────┐
                │     GitHub Actions CI      │
                │  - Build Docker Image      │
                │  - Run Security Scans      │
                │  - Push to ACR             │
                └────────────┬──────────────┘
                             │
                             ▼
                ┌────────────────────────────┐
                │ Azure Container Registry   │
                │          (ACR)             │
                └────────────┬──────────────┘
                             │
                             ▼
                ┌────────────────────────────┐
                │        ArgoCD (GitOps)     │
                │   Watches Git (Helm Chart) │
                └────────────┬──────────────┘
                             │
                             ▼
                ┌────────────────────────────┐
                │   Azure Kubernetes (AKS)   │
                │  - Helm Deployment         │
                │  - Service + Ingress       │
                └────────────────────────────┘
```

---

# 📦 Repository Structure

```text
📦devops-demo
 ┣ 📂.github
 ┃ ┗ 📂workflows
 ┃ ┃ ┗ 📜staging-pipeline.yml
 ┣ 📂helm
 ┃ ┗ 📂my-app
 ┃ ┃ ┣ 📂templates
 ┃ ┃ ┃ ┣ 📜deployment.yaml
 ┃ ┃ ┃ ┣ 📜ingress.yaml
 ┃ ┃ ┃ ┗ 📜service.yaml
 ┃ ┃ ┣ 📜Chart.yaml
 ┃ ┃ ┗ 📜values.yaml
 ┣ 📂infrastructure
 ┃ ┣ 📜acr.tf
 ┃ ┣ 📜aks.tf
 ┃ ┣ 📜argocd.tf
 ┃ ┣ 📜github.sp.tf
 ┃ ┣ 📜main.tf
 ┃ ┣ 📜outputs.tf
 ┃ ┣ 📜providers.tf
 ┃ ┣ 📜rbac.tf
 ┃ ┣ 📜terraform.tfstate
 ┃ ┣ 📜terraform.tfstate.backup
 ┃ ┗ 📜variables.tf
 ┣ 📂src
 ┃ ┣ 📂client
 ┃ ┃ ┣ 📂components
 ┃ ┃ ┃ ┗ 📜ExampleComponent.js
 ┃ ┃ ┗ 📜index.js
 ┃ ┗ 📂server
 ┃ ┃ ┗ 📜app.js
 ┣ 📜.dockerignore
 ┣ 📜.gitignore
 ┣ 📜.trivyignore
 ┣ 📜argocd-app.yaml
 ┣ 📜Dockerfile
 ┣ 📜package-lock.json
 ┣ 📜package.json
 ┣ 📜README.md
 ┣ 📜sonar-project.properties
 ┗ 📜webpack.config.js
```

---

# ⚙️ Key Components

## 🔁 CI Pipeline (GitHub Actions)

* Triggered on `staging` branch
* Builds Docker image
* Pushes to Azure Container Registry
* Runs vulnerability scans (Trivy)

## ☁️ Infrastructure (Terraform)

* AKS cluster provisioning
* ACR creation
* ArgoCD installation via Helm
* RBAC & service principals

## ⛵ Deployment (Helm)

* Kubernetes manifests templated via Helm
* Configurable via `values.yaml`

## 🔄 GitOps (ArgoCD)

* Automatically syncs Kubernetes state with Git
* Enables continuous deployment

---

# 🚀 Getting Started

## 1️⃣ Prerequisites

* Azure CLI
* Terraform ≥ 1.5
* Docker
* kubectl
* Helm
* GitHub account

---

## 2️⃣ Clone Repository

```bash
git clone https://github.com/<your-username>/devops-demo.git
cd devops-demo
```

---

## 3️⃣ Setup Azure Authentication

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

---

## 4️⃣ Deploy Infrastructure (Terraform)

```bash
cd infrastructure

terraform init
terraform plan
terraform apply
```
---

## 5️⃣ Configure Kubernetes Access

```bash
az aks get-credentials --resource-group <rg> --name <aks-cluster>
kubectl get nodes
```
Make sure to allow AKS to ACR access for ArgoCD to pull the image from the repo

```bash
az aks update --name <cluster_name> --resource-group <Resource_group> --attach-acr <Registry_name>

```

---

## 6️⃣ Deploy Application via ArgoCD

Apply ArgoCD application:

```bash
kubectl apply -f argocd-app.yaml
```

---

## 7️⃣ Trigger CI/CD Pipeline

Push to staging:

```bash
git checkout -b staging
git push origin staging
```

Pipeline will:

* Build & push image
* ArgoCD auto-syncs deployment

---

# 🔐 Security

* Image scanning via **Trivy**
* Secrets managed via GitHub Secrets
* RBAC enforced on AKS
* `.trivyignore` and `.gitignore` for controlled exclusions