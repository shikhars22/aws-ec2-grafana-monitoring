# Docker, Prometheus, and Grafana EC2 Setup

This repository documents the step-by-step setup to install Docker and run containerized **Prometheus** and **Grafana Enterprise** instances on an AWS EC2 machine (Ubuntu) to monitor systems and build visualization dashboards.

---

## 📁 Repository Structure

* **`install_docker.sh`**: Automated shell script to configure Docker and group permissions on Ubuntu.
* **`README.md`**: Guide for setup, running containers, configuring AWS security groups, and dashboard creation.
* **`.gitignore`**: Excludes python virtual environments (`.venv/`) and private credentials/private keys (`*.pem`).

---

## 🚀 Step 1: Install Docker on EC2

### 1. Transfer the Script to EC2 (`scp`)
From your local machine, run this command inside the `MLOpsLearning/grafanaMonitoring` directory:
```bash
scp -i awsSupportDocs/rsa-key-skg-mlFlow.pem install_docker.sh ubuntu@3.109.133.18:~/
```

### 2. Connect to EC2 & Run Installer (`ssh`)
SSH into your instance and run the script:
```bash
# Connect to EC2
ssh -i awsSupportDocs/rsa-key-skg-mlFlow.pem ubuntu@3.109.133.18

# Run script
chmod +x install_docker.sh
./install_docker.sh
```

---

## 📈 Step 2: Install and Run Prometheus & Grafana

Once Docker is installed, execute the following commands in the EC2 instance terminal to start the containers:

### 1. Run Prometheus
Run Prometheus in detached mode (using the `-d` flag so it runs in the background):
```bash
docker run -d -p 9090:9090 --name=prometheus prom/prometheus
```
* **Port**: `9090`

### 2. Run Grafana Enterprise
Run Grafana Enterprise in detached mode:
```bash
docker run -d -p 3000:3000 --name=grafana grafana/grafana-enterprise
```
* **Port**: `3000`

---

## 🛡️ Step 3: Configure AWS Security Group Inbound Rules

To access the user interfaces of Prometheus and Grafana from your local web browser, you must open these ports on your EC2 Instance's Security Group:

1. Go to the **AWS EC2 Console**.
2. Select your running instance and click on the **Security** tab.
3. Click on your active **Security Group**.
4. Click **Edit inbound rules** and add the following two rules:
   * **Rule 1**: Type `Custom TCP`, Port Range `9090`, Source `My IP` (or `Anywhere-IPv4` if you want public access).
   * **Rule 2**: Type `Custom TCP`, Port Range `3000`, Source `My IP` (or `Anywhere-IPv4` if you want public access).
5. Click **Save rules**.

---

## 📊 Step 4: Link Prometheus to Grafana & Create Dashboard

Once the ports are open, configure the monitoring stack:

1. **Access Interfaces**:
   * Prometheus UI: `http://3.109.133.18:9090`
   * Grafana UI: `http://3.109.133.18:3000` (Default credentials: Admin / Admin)

2. **Add Data Source in Grafana**:
   * Log into Grafana, navigate to **Connections** -> **Data sources**.
   * Click **Add data source** and select **Prometheus**.
   * In the **Connection URL** input field, add your EC2 instance public IP and Prometheus port:
     `http://3.109.133.18:9090`
   * Scroll to the bottom and click **Save & test**. (You should see a green success notification: *"Data source is working"*).

3. **Metrics Source**:
   * Prometheus automatically scrapes and exposes its own performance metrics at the following endpoint:
     🔗 `http://3.109.133.18:9090/metrics`
   * Grafana polls this `/metrics` HTTP endpoint to gather data and build real-time dashboard visualizations.

4. **Create a Dashboard**:
   * Go to **Dashboards** -> **New Dashboard** -> **Add visualization**.
   * Select the **Prometheus** data source you just added.
   * Query metrics (e.g., CPU, memory, or request counters from the `/metrics` endpoint) and click **Apply** to build and save your visual panels.
