# 🏗️ Azure Infrastructure as Code - NoteServe Project

This repository contains Terraform configurations for provisioning Azure infrastructure for the NoteServe application. The infrastructure includes networking, compute, storage, and monitoring resources with proper security and VNet integration.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Module Documentation](#module-documentation)
- [Variables Reference](#variables-reference)
- [Outputs Reference](#outputs-reference)
- [Deployment](#deployment)
- [Security Considerations](#security-considerations)
- [Best Practices](#best-practices)

## 🏛️ Architecture Overview

The infrastructure is designed with a modular approach and includes:

### Core Infrastructure
- **Resource Group**: Centralized resource management
- **Virtual Network**: Multi-subnet architecture with NAT Gateway
- **Network Security**: Service endpoints and network rules

### Compute Resources
- **App Service**: Backend API with VNet integration
- **Container App**: Reporting application
- **Static Web App**: Frontend application

### Data & Storage
- **SQL Server**: Managed database with authentication
- **Storage Account**: Blob storage with network rules
- **Key Vault**: Secrets management with network access

### Monitoring & Observability
- **Application Insights**: Application monitoring
- **Log Analytics**: Centralized logging workspace
- **Managed Identity**: Secure authentication

### Network Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Virtual Network                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐         │
│  │   App       │ │   DB        │ │   Build     │         │
│  │  Subnet     │ │  Subnet     │ │  Subnet     │         │
│  │ (10.10.1.0)│ │(10.10.2.0)  │ │(10.10.3.0)  │         │
│  └─────────────┘ └─────────────┘ └─────────────┘         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           VNet Integration Subnet                 │   │
│  │              (10.10.4.0/27)                      │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 Prerequisites

### Required Tools
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/) (for CI/CD)

### Azure Requirements
- Active Azure Subscription
- Service Principal with appropriate permissions
- Azure DevOps Environment configured

### Required Permissions
- **Contributor** role on the target subscription
- **Key Vault Administrator** role (for Key Vault operations)
- **SQL Server Contributor** role (for SQL Server operations)

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone <repository-url>
cd noteserve_iac_provisioner
```

### 2. Configure Environment Variables
```bash
export ARM_CLIENT_ID="your-service-principal-id"
export ARM_CLIENT_SECRET="your-service-principal-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Configure Variables
Copy and modify the environment-specific variables:
```bash
cp env/test.tfvars env/your-environment.tfvars
# Edit the variables file with your values
```

### 5. Plan and Apply
```bash
terraform plan -var-file="env/your-environment.tfvars"
terraform apply -var-file="env/your-environment.tfvars"
```

## 📦 Module Documentation

### 🔧 Provider Configuration

**Type**: `provider`  
**Source**: `hashicorp/azurerm`  
**Version**: `~> 4.35.0`  
**Purpose**: Azure Resource Manager provider configuration

#### Authentication
- **Method**: Service Principal via environment variables
- **Variables**: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`

### 🏢 Resource Group Module

**Type**: `module`  
**Source**: `./modules/resource_group`  
**Purpose**: Centralized resource management and organization

#### Attributes

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `env_prefix` | `string` | Environment prefix for naming | - | ✅ |
| `company_name` | `string` | Company name for resource naming | - | ✅ |
| `location` | `string` | Azure region for resources | - | ✅ |
| `tags` | `map(string)` | Resource tags | `{}` | ❌ |

### 🌐 Virtual Network Module

**Type**: `module`  
**Source**: `./modules/vnet`  
**Purpose**: Network infrastructure with multiple subnets

#### Attributes

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `env_prefix` | `string` | Environment prefix | - | ✅ |
| `company_name` | `string` | Company name | - | ✅ |
| `location` | `string` | Azure region | - | ✅ |
| `address_space` | `list(string)` | VNet address space | - | ✅ |
| `resource_group_name` | `string` | Resource group name | - | ✅ |
| `tags` | `map(string)` | Resource tags | `{}` | ❌ |

### 🔗 Subnet Modules

**Type**: `module`  
**Source**: `./modules/subnet`  
**Purpose**: Network segmentation with service endpoints and delegations

#### Subnet Types

1. **App Subnet** (`subnet_app`)
   - **Purpose**: Network rules for Storage Account and Key Vault
   - **Features**: Service endpoints, App Service delegation, NAT Gateway
   - **Address Range**: `10.10.1.0/24`

2. **VNet Integration Subnet** (`subnet_vnet_integration`)
   - **Purpose**: App Service VNet integration
   - **Features**: Service endpoints, App Service delegation, NAT Gateway
   - **Address Range**: `10.10.4.0/27`

3. **DB Subnet** (`subnet_db`)
   - **Purpose**: Database services
   - **Features**: Service endpoints, NAT Gateway
   - **Address Range**: `10.10.2.0/27`

4. **Build Subnet** (`subnet_build`)
   - **Purpose**: Build/deployment services
   - **Features**: Service endpoints, NAT Gateway
   - **Address Range**: `10.10.3.0/27`

### 🚪 NAT Gateway Module

**Type**: `module`  
**Source**: `./modules/nat_gateway`  
**Purpose**: Outbound internet connectivity and traffic whitelisting

#### Features
- **Outbound Connectivity**: All subnets route through NAT Gateway
- **IP Whitelisting**: Single public IP for external services
- **Security**: Controlled outbound traffic

### 💾 Storage Account Module

**Type**: `module`  
**Source**: `./modules/storage_account`  
**Purpose**: Blob storage with network security

#### Security Features
- **Network Rules**: Restrict access to specific subnets
- **Service Endpoints**: Direct connectivity to Azure services
- **Default Action**: Deny public access

### 🌐 App Service Module

**Type**: `module`  
**Source**: `./modules/app_service`  
**Purpose**: Backend API with VNet integration and network access control

#### Features
- **VNet Integration**: Connected to dedicated subnet
- **Network Access Control**: IP restrictions for specific subnets
- **Public Access**: Enabled with controlled access
- **Outbound Routing**: Through NAT Gateway

#### Network Configuration
- **Public Network Access**: Enabled
- **IP Restrictions**: Allow DB and Build subnets
- **Default Action**: Deny unmatched traffic

### 🔐 Key Vault Module

**Type**: `module`  
**Source**: `./modules/key_vault`  
**Purpose**: Secrets management with network security

#### Security Features
- **Network Rules**: Restrict access to App subnet
- **Service Endpoints**: Direct connectivity
- **Default Action**: Deny public access

### 📊 Monitoring Modules

#### Log Analytics Module
**Type**: `module`  
**Source**: `./modules/log_analytics`  
**Purpose**: Centralized logging workspace

#### Application Insights Module
**Type**: `module`  
**Source**: `./modules/application_insights`  
**Purpose**: Application performance monitoring

### 🗄️ SQL Server Module

**Type**: `module`  
**Source**: `./modules/sql_server`  
**Purpose**: Managed database with authentication

#### Security Features
- **Authentication**: SQL Server authentication
- **Managed Identity**: For secure access to Key Vault
- **Network Security**: Through VNet integration

### 🐳 Container App Module

**Type**: `module`  
**Source**: `./modules/container_app`  
**Purpose**: Reporting application deployment

#### Features
- **Container Registry**: Azure Container Registry support
- **Scaling**: Min/max replicas configuration
- **Environment Variables**: Configurable app settings

### 🎨 Static Web App Module

**Type**: `module`  
**Source**: `./modules/static_web_app`  
**Purpose**: Frontend application hosting

#### Features
- **Global Distribution**: CDN-enabled hosting
- **Application Insights**: Performance monitoring
- **Custom Domain**: Support for custom domains

### 🔑 Managed Identity Module

**Type**: `module`  
**Source**: `./modules/managed_identity`  
**Purpose**: Secure authentication for Azure services

#### Features
- **SQL Server Access**: Database authentication
- **Key Vault Access**: Secrets retrieval
- **Zero Secrets**: No credentials in code

## 📝 Variables Reference

### Core Variables

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `env_prefix` | `string` | Environment prefix (dev, test, prod) | - | ✅ |
| `company_name` | `string` | Company name for resource naming | - | ✅ |
| `location` | `string` | Azure region for deployment | - | ✅ |
| `tags` | `map(string)` | Resource tags | - | ✅ |

### Network Variables

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `vnet_address_space` | `list(string)` | VNet address space | - | ✅ |
| `app_subnet_prefix` | `string` | App subnet CIDR | - | ✅ |
| `db_subnet_prefix` | `string` | DB subnet CIDR | - | ✅ |
| `build_subnet_prefix` | `string` | Build subnet CIDR | - | ✅ |

### Storage Variables

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `storage_account_name` | `string` | Storage account name | - | ✅ |

### Compute Variables

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `app_service_plan_sku` | `string` | App Service Plan SKU | - | ✅ |
| `key_vault_sku` | `string` | Key Vault SKU | - | ✅ |
| `static_web_app_sku` | `string` | Static Web App SKU | - | ✅ |

### Database Variables

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `sql_admin_username` | `string` | SQL Server admin username | - | ✅ |
| `sql_admin_password` | `string` | SQL Server admin password | - | ✅ |
| `sql_database_name` | `string` | Database name | `"noteserve_db"` | ❌ |
| `sql_sku_name` | `string` | Database SKU | `"S2"` | ❌ |
| `sql_max_size_gb` | `number` | Database max size | `2` | ❌ |

### Container App Variables

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `container_image` | `string` | Container image | `"mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"` | ❌ |
| `container_image_version` | `string` | Image version | `"latest"` | ❌ |
| `container_cpu` | `number` | CPU allocation | `0.5` | ❌ |
| `container_memory` | `string` | Memory allocation | `"1Gi"` | ❌ |
| `container_target_port` | `number` | Target port | `80` | ❌ |
| `container_min_replicas` | `number` | Min replicas | `0` | ❌ |
| `container_max_replicas` | `number` | Max replicas | `3` | ❌ |

### Monitoring Variables

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `log_analytics_workspace_sku` | `string` | Log Analytics SKU | - | ✅ |
| `app_insights_type` | `string` | Application Insights type | - | ✅ |
| `tenant_id` | `string` | Azure tenant ID | - | ✅ |

## 📤 Outputs Reference

| Name | Type | Description | Sensitive |
|------|------|-------------|-----------|
| `vnet_name` | `string` | Virtual Network name | ❌ |
| `app_subnet_name` | `string` | App subnet name | ❌ |
| `db_subnet_name` | `string` | DB subnet name | ❌ |
| `build_subnet_name` | `string` | Build subnet name | ❌ |
| `storage_account_name` | `string` | Storage account name | ❌ |
| `backend_url` | `string` | App Service URL | ❌ |
| `key_vault_name` | `string` | Key Vault name | ❌ |
| `log_analytics_workspace_id` | `string` | Log Analytics workspace ID | ❌ |
| `app_insights_connection_string` | `string` | Application Insights connection string | ✅ |
| `frontend_url` | `string` | Static Web App URL | ❌ |
| `reporting_app_url` | `string` | Container App URL | ❌ |
| `reporting_app_fqdn` | `string` | Container App FQDN | ❌ |

## 🚀 Deployment

### Azure DevOps Pipeline

The project includes an Azure DevOps pipeline (`azure-pipelines.yml`) that:

1. **Plan Stage**: Validates and plans Terraform changes
2. **Apply Stage**: Applies changes with approval gates
3. **Authentication**: Uses Service Principal authentication
4. **Environment**: Supports multiple environments

### Manual Deployment

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file="env/test.tfvars"

# Apply changes
terraform apply -var-file="env/test.tfvars"

# Destroy infrastructure (if needed)
terraform destroy -var-file="env/test.tfvars"
```

### Environment-Specific Deployment

```bash
# Development
terraform apply -var-file="env/dev.tfvars"

# Testing
terraform apply -var-file="env/test.tfvars"

# Production
terraform apply -var-file="env/prod.tfvars"
```

## 🔒 Security Considerations

### Network Security
- ✅ **Private Subnets**: All resources in private subnets
- ✅ **Service Endpoints**: Direct connectivity to Azure services
- ✅ **Network Rules**: Restrict access to specific subnets
- ✅ **NAT Gateway**: Controlled outbound traffic

### Authentication & Authorization
- ✅ **Managed Identity**: Zero-secret authentication
- ✅ **Service Principal**: Pipeline authentication
- ✅ **Key Vault**: Secure secrets management
- ✅ **SQL Authentication**: Database access control

### Data Protection
- ✅ **Encryption at Rest**: All storage encrypted
- ✅ **Encryption in Transit**: TLS for all connections
- ✅ **Network Isolation**: VNet-based security

## 📋 Best Practices

### ✅ Implemented Best Practices

1. **Modular Design**: Reusable modules for each resource type
2. **Consistent Naming**: Standardized naming convention
3. **Resource Tagging**: Comprehensive tagging strategy
4. **Network Security**: Private subnets with controlled access
5. **Monitoring**: Application Insights and Log Analytics
6. **Secrets Management**: Key Vault integration
7. **CI/CD**: Automated deployment pipeline

### ⚠️ Recommendations

1. **Backend Configuration**: Use Azure Storage for Terraform state
2. **Environment Separation**: Separate state files per environment
3. **Cost Optimization**: Monitor and optimize resource usage
4. **Disaster Recovery**: Implement backup and recovery procedures
5. **Compliance**: Regular security audits and compliance checks

## 🔗 Useful Links

- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: This infrastructure is designed for production use with proper security measures. Always review and test changes in a non-production environment first.
