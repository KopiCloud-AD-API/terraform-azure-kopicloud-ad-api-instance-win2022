# Deploy an Azure Virtual Machine with KopiCloud AD API in Windows Server 2022
[![Terraform](https://img.shields.io/badge/terraform-v1.3+-blue.svg)](https://www.terraform.io/downloads.html)
[![KopiCloud-AD](https://img.shields.io/badge/kopiCloud_ad-v1.0+-blueviolet.svg)](https://www.kopicloud-ad-api.com)

The Terraform code in this repo will deploy an Azure Virtual Machine for **KopiCloud AD API** with Windows Server 2022 and SQL Server 2022 Express.

## Network Configuration

The code will create the network resources (Resource Group, VNET, Subnet).

## Notes

- By default, the download and installation of **SQL Server Management Studio** is disabled because it will take lots of time.

- The default Windows username and password are managed by the **terraform.tfvars** file.

## Configuring Azure Credentials

Read the document **Getting Started with Terraform and Microsoft Azure - Section 6** to configure credentials.

https://medium.com/@gmusumeci/getting-started-with-terraform-and-microsoft-azure-a2fcb690eb67

## How to Set Up KopiCloud AD API

1. Get a License - Generate a free trial license (no credit card required) or purchase a license [here](https://www.kopicloud-ad-api.com/get-license).

2. Install **KopiCloud AD API** using the code in this repo.

3. Join the machine to the AD Domain to manage using the API.

4. Create a Service Account with Domain Administrators permissions for the **KopiCloud AD API**.

5. Run the **KopiCloud AD API Config tool** located in the folder **C:\KopiCloud-AD-API-Config** to finish the setup of API.

**Note:** You cannot log in to the **KopiCloud AD API Portal** using the Service Account for security reasons.

## Resources

KopiCloud AD API Official Web Site: https://www.kopicloud-ad-api.com

KopiCloud AD API Documentation: https://help.kopicloud-ad-api.com
