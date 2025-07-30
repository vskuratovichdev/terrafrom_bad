# Terraform Code Analysis Instruction

## Overview
This instruction provides a comprehensive framework for analyzing Terraform Infrastructure as Code (IaC) projects against industry best practices, security standards, and operational excellence principles.

## Analysis Categories

### 1. Code Structure & Organization
- **Module Structure**: Evaluate modular design, reusability, and separation of concerns
- **File Organization**: Check proper file naming, directory structure, and logical grouping
- **Code Readability**: Assess variable naming, comments, and documentation quality
- **Consistency**: Verify consistent coding patterns across the project

### 2. Security Analysis
- **Resource Security**: Evaluate security configurations for all resources
- **Network Security**: Analyze VNet configurations, NSGs, and network access controls
- **Identity & Access**: Review IAM roles, managed identities, and access policies
- **Secrets Management**: Check for hardcoded secrets and proper Key Vault usage
- **Encryption**: Verify encryption at rest and in transit configurations
- **Public Access**: Identify resources with public endpoints and assess necessity

### 3. Best Practices Compliance
- **Naming Conventions**: Evaluate adherence to Azure naming standards
- **Resource Tagging**: Check comprehensive and consistent tagging strategy
- **Provider Versioning**: Verify pinned provider versions and compatibility
- **State Management**: Assess remote state configuration and locking mechanisms
- **Variable Management**: Review variable definitions, types, and default values
- **Output Management**: Evaluate output definitions and sensitive data handling

### 4. Operational Excellence
- **Monitoring & Logging**: Check Application Insights, Log Analytics integration
- **Backup & DR**: Evaluate backup strategies and disaster recovery planning
- **Scalability**: Assess auto-scaling configurations and resource sizing
- **Cost Optimization**: Review resource SKUs and cost-effective configurations
- **Environment Management**: Check multi-environment support and separation

### 5. Performance & Reliability
- **Resource Dependencies**: Analyze proper dependency management
- **Error Handling**: Check for proper error handling and validation
- **Resource Limits**: Evaluate appropriate resource sizing and limits
- **High Availability**: Assess HA configurations and redundancy

### 6. Compliance & Governance
- **Policy Compliance**: Check adherence to organizational policies
- **Regulatory Requirements**: Evaluate compliance with industry standards
- **Data Governance**: Review data classification and handling policies
- **Audit Trail**: Assess audit logging and compliance monitoring

## Analysis Checklist

### Security Checklist
- [ ] No hardcoded secrets, passwords, or API keys
- [ ] All storage accounts have proper access controls
- [ ] Network security groups have restrictive rules
- [ ] Key Vault access policies are properly configured
- [ ] Managed identities used instead of service principals where possible
- [ ] Public endpoints are secured or disabled
- [ ] SSL/TLS enforced for all communications
- [ ] Database authentication properly configured

### Infrastructure Checklist
- [ ] Resources are properly tagged
- [ ] Naming convention is consistent and meaningful
- [ ] Resource groups are logically organized
- [ ] Proper dependency management between resources
- [ ] Environment-specific configurations are parameterized
- [ ] State file is stored remotely with locking
- [ ] Provider versions are pinned

### Operational Checklist
- [ ] Monitoring and alerting configured
- [ ] Backup strategies implemented
- [ ] Auto-scaling configured where appropriate
- [ ] Cost optimization measures in place
- [ ] Documentation is comprehensive and up-to-date
- [ ] CI/CD pipeline properly configured

## Analysis Output Format

### Findings Classification
- **Critical**: Security vulnerabilities, compliance violations
- **High**: Best practice violations affecting reliability/security
- **Medium**: Optimization opportunities, minor best practice deviations
- **Low**: Code quality improvements, documentation enhancements

### Report Structure
1. **Executive Summary**
   - Overall assessment score
   - Critical findings count
   - Key recommendations

2. **Detailed Findings**
   - Category-wise analysis
   - Specific file/line references
   - Impact assessment
   - Remediation steps

3. **Recommendations**
   - Prioritized action items
   - Implementation guidance
   - Best practice references

4. **Compliance Status**
   - Security compliance score
   - Best practices adherence
   - Areas for improvement

## Specific Analysis Areas for Azure Terraform

### Azure-Specific Security
- App Service authentication and authorization
- Storage account network rules and private endpoints
- Key Vault network access and soft delete
- SQL Server firewall rules and authentication
- Container Apps security configurations
- Static Web Apps custom authentication

### Azure Resource Optimization
- App Service Plan sizing and scaling
- SQL Database DTU/vCore optimization
- Storage account performance tiers
- Application Insights sampling rates
- Log Analytics workspace retention

### Azure Networking
- VNet and subnet design
- NAT Gateway configurations
- Service endpoints usage
- Private endpoints implementation
- DNS configurations

## Implementation Guidelines

### Step 1: Automated Analysis
Run static analysis tools:
- `terraform validate`
- `terraform plan`
- `checkov` for security scanning
- `tflint` for best practices
- `terrascan` for policy compliance

### Step 2: Manual Review
- Review each module for best practices
- Analyze variable and output definitions
- Check documentation completeness
- Verify environment-specific configurations

### Step 3: Security Assessment
- Scan for hardcoded secrets
- Review network security configurations
- Analyze IAM and access controls
- Check encryption configurations

### Step 4: Report Generation
- Compile findings into structured report
- Prioritize recommendations
- Provide remediation guidance
- Include compliance assessment

## Tools and Resources

### Analysis Tools
- **Checkov**: Security and compliance scanning
- **TFLint**: Terraform linting and best practices
- **Terrascan**: Policy as code scanning
- **TFSec**: Security-focused static analysis
- **Terraform Docs**: Documentation generation

### Reference Standards
- Azure Well-Architected Framework
- CIS Azure Benchmarks
- NIST Cybersecurity Framework
- Terraform Best Practices Guide
- Azure Security Baseline

This instruction should be used as a comprehensive guide to evaluate Terraform projects systematically and ensure they meet industry standards for security, reliability, and operational excellence.