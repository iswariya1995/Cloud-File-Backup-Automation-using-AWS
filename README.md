# Cloud-File-Backup-Automation-using-AWS

## 📌 Project Overview

This project demonstrates a **near-real-time synchronization system between Amazon Elastic File System (EFS) and Amazon S3** within a **custom AWS VPC**.

The solution automatically syncs files stored in **EFS to S3**, ensuring data backup, durability, and availability for analytics or disaster recovery.

The synchronization is achieved using **EC2, inotify tools, AWS CLI, and automated scripts** running inside the VPC.

---

# 🎯 Objectives

* Design a secure synchronization mechanism between **Amazon EFS and Amazon S3**
* Deploy infrastructure inside a **custom VPC**
* Implement **near real-time data synchronization**
* Ensure **secure and automated file backup**
* Document architecture, implementation steps, and challenges

---

# 🛠 AWS Services Used

| AWS Service    | Purpose                                 |
| -------------- | --------------------------------------- |
| **Amazon EFS** | Primary shared file storage             |
| **Amazon S3**  | Backup and archival storage             |
| **Amazon EC2** | Runs synchronization scripts            |
| **AWS IAM**    | Controls secure access to AWS resources |
| **Amazon VPC** | Provides isolated network environment   |

---

# 🏗 Architecture Overview

EFS → EC2 (inotify monitoring) → AWS CLI → S3

Files created or modified in **EFS** are detected by **inotify**, and the changes are automatically synced to **Amazon S3**.

<p align="center">
<img width="500" alt="EFS to S3 Architecture" src="https://github.com/user-attachments/assets/4eff33cf-5a89-4eaf-9a88-67ec428f2529" />
</p>

---

# ⚙️ Implementation Steps

## Step 1: Create Custom VPC

* Created a **custom VPC**
* Configured **public and private subnets**
* Configured **route tables**

---

## Step 2: Setup AWS Resources

### Amazon EFS Setup

Created an EFS filesystem:

```
efsproject
```

Mounted the EFS filesystem on EC2 instances.

---

### Amazon S3 Setup

Created an S3 bucket for storing synchronized data.

```
efs-sync-backup-bucket
```

---

### EC2 Setup

Created **two EC2 instances**

```
instance1
instance2
```

These instances run the synchronization scripts.

---

# 🔐 IAM Configuration

Configured IAM roles to allow EC2 instances to access:

* Amazon EFS
* Amazon S3

Permissions include:

* S3 PutObject
* S3 DeleteObject
* S3 ListBucket

---

# 💻 CLI Setup on EC2

Install required packages:

```
sudo yum update -y
sudo yum install -y amazon-efs-utils inotify-tools aws-cli
```

Create shared directory:

```
sudo mkdir -p /share/projects
sudo chown -R ec2-user:ec2-user /share/projects
```

Mount EFS:

```
sudo mount -t efs fs-id:/ /share/projects
```

---

# 🔄 EFS to S3 Sync Script

Create script:

```
vi efs_sync.sh
```

Example script logic:

* Monitor directory changes using **inotify**
* Upload new files to **S3**
* Delete removed files from **S3**
* Maintain synchronization logs

Make script executable:

```
chmod +x efs_sync.sh
```

---

# ⚙️ Configure Systemd Service

Create service file:

```
sudo vi /etc/systemd/system/efs-sync.service
```

Start service:

```
sudo systemctl daemon-reload
sudo systemctl enable efs-sync.service
sudo systemctl start efs-sync.service
sudo systemctl status efs-sync.service
```

This ensures the sync service runs automatically.

---

# ⏱ Scheduled Sync Using Cron

Add backup verification every 30 minutes:

```
crontab -e
```

```
*/30 * * * * /usr/bin/aws s3 sync /share/projects s3://YOUR_BUCKET_NAME --delete --only-show-errors >> /var/log/efs-sync-cron.log 2>&1
```

---

# ⚠ Challenges Faced

**EFS Mount Issues**

* Resolved by enabling **TCP port 2049** in security groups.

**IAM Permission Errors**

* Fixed by assigning correct **S3 permissions to EC2 IAM role**.

**Sync Delay**

* Implemented **inotify monitoring** for near real-time synchronization.

---

# 📚 Lessons Learned

* Learned to configure **AWS networking using VPC**
* Implemented **event-driven file synchronization**
* Understood the importance of **IAM security policies**
* Explored **AWS DataSync as an enterprise alternative**

---

# ✅ Conclusion

This project successfully implemented a **secure, automated, and near real-time synchronization system between Amazon EFS and Amazon S3**.

The architecture can be extended using:

* AWS DataSync
* Lambda automation
* CloudWatch monitoring

This approach provides **high availability, cost efficiency, and reliable backup solutions for cloud environments.**

---

# 🚀 Future Improvements

* Implement **AWS DataSync**
* Add **CloudWatch monitoring**
* Automate deployment using **Terraform or CloudFormation**

---

⭐ If you find this project useful, feel free to star the repository!
