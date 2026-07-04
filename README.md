# 🏗️ 2-Tier AWS Infrastructure — Terraform

A production-style 2-Tier AWS architecture deployed entirely as code using Terraform. Includes a custom VPC, public and private subnets, EC2 instances, security groups, and remote state management on S3.

---

## 📐 Architecture Overview

```
                        Internet
                           │
                    [Internet Gateway]
                           │
                    [Public Subnet]
                   [EC2 - Proxy Server]
                           │
                    [Private Subnet]
                   [EC2 - App Server]
                           │
                  [Security Group Rules]
              SSH(22) | HTTP(80) | Tomcat(8080) | MySQL(3306)
```

---

## ☁️ Resources Created

| Resource | Details |
|---|---|
| **VPC** | Custom VPC — `10.0.0.0/16` |
| **Public Subnet** | `10.0.16.0/20` — eu-north-1b |
| **Private Subnet** | `10.0.0.0/20` — eu-north-1a |
| **Internet Gateway** | Attached to VPC |
| **Route Table** | Public route to Internet Gateway |
| **Security Group** | SSH, HTTP, Tomcat, MySQL ports open |
| **EC2 Public** | Proxy Server — public subnet |
| **EC2 Private** | App Server — private subnet |
| **S3 Backend** | Remote state file storage |

---

## 🛠️ Technologies Used

- **Terraform** — Infrastructure as Code
- **AWS EC2** — Virtual servers
- **AWS VPC** — Custom networking
- **AWS S3** — Remote state backend
- **AWS Security Groups** — Firewall rules

---

## 📁 Project Structure

```
terraform-2tier-aws/
├── main.tf          # All AWS resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
└── README.md        # Project documentation
```

---

## ⚙️ Prerequisites

Before you begin make sure you have:

- AWS Account with IAM user configured
- AWS CLI installed and configured (`aws configure`)
- Terraform installed (v1.0+)
- S3 bucket created for remote state
- SSH key pair created in AWS console

---

## 🚀 How to Deploy

**Step 1 — Clone the repository**
```bash
git clone https://github.com/narendra-clouds/terraform-2tier-aws.git
cd terraform-2tier-aws
```

**Step 2 — Update variables**

Edit `variables.tf` and update:
- `ami` — your region's Ubuntu AMI ID
- `key` — your AWS key pair name
- Backend bucket name in `main.tf`

**Step 3 — Initialize Terraform**
```bash
terraform init
```

**Step 4 — Preview the plan**
```bash
terraform plan
```

**Step 5 — Apply and deploy**
```bash
terraform apply
```

Type `yes` when prompted.

**Step 6 — Get server IPs**

After deployment Terraform will output:
```
public_ip  = "xx.xx.xx.xx"
private_ip = "10.0.x.x"
```

**Step 7 — Destroy when done**
```bash
terraform destroy
```

---

## 📤 Outputs

| Output | Description |
|---|---|
| `public_ip` | Public IP of Proxy Server |
| `private_ip` | Private IP of App Server |

---

## 🔐 Security Notes

- MySQL port 3306 is currently open to `0.0.0.0/0` — restrict to private subnet CIDR in production
- Use IAM roles instead of access keys where possible
- Enable S3 bucket versioning for state file safety
- Add DynamoDB table for state locking in production

---

## 📸 Screenshots

> AWS Console after `terraform apply`

<!-- Add your screenshots here after deployment -->

---

## 🧠 Concepts Demonstrated

- Infrastructure as Code with Terraform
- Custom VPC and subnet design
- Public vs Private subnet architecture
- Security Group configuration
- Remote state management with S3
- Output variables for resource information
- Resource dependencies with `depends_on`

---

## 👨‍💻 Author

**Narendra Deshmukh**
- GitHub: [@narendra-clouds](https://github.com/narendra-clouds)
- Email: deshmukhn298@gmail.com
- LinkedIn: [Connect with me](https://linkedin.com/in/)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

⭐ If this project helped you, please give it a star on GitHub!