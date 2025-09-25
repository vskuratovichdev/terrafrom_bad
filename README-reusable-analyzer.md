# 🚀 Reusable Terraform Security Analyzer

A pre-built Docker image for Terraform security analysis that can be used across any GitHub repository without local building.

## 📦 Published Image

```
ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest
```

## 🎯 Quick Setup for Any Repository

### Option 1: Copy Single Workflow File (Recommended)

1. **Copy this file to any Terraform repository:**
   ```
   .github/workflows/use-published-analyzer.yml
   ```

2. **That's it!** The analysis will automatically run on:
   - Pull requests touching `.tf`, `.tfvars`, or `.hcl` files
   - Pushes to main/master branch
   - Manual trigger via GitHub Actions UI

### Option 2: Custom Workflow

```yaml
name: Terraform Security Analysis

on: [push, pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      packages: read
      security-events: write

    steps:
      - uses: actions/checkout@v4

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Run Terraform Analysis
        run: |
          mkdir -p analysis-output
          docker run --rm \
            -v "$PWD:/workspace:ro" \
            -v "$PWD/analysis-output:/output" \
            -e ANALYSIS_TYPE=full \
            ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest

      - name: Upload results
        uses: actions/upload-artifact@v4
        with:
          name: terraform-analysis
          path: analysis-output/
```

## 🏗️ Building and Publishing Your Own Image

### Step 1: Fork and Setup

1. **Fork this repository**
2. **The Docker image will automatically build and publish to:**
   ```
   ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest
   ```

### Step 2: Automatic Publishing

The image is automatically built and published when:
- ✅ Push to main branch (publishes `:latest`)
- ✅ Create tags (publishes `:tag-name`)
- ✅ Manual workflow trigger with custom tag

### Step 3: Using in Other Repositories

Update the image name in your workflows:
```yaml
env:
  DOCKER_IMAGE: ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest
```

## 🔧 Configuration Options

### Analysis Types

| Type | Description | Tools Used |
|------|-------------|------------|
| `full` | Complete analysis (default) | All tools |
| `security-only` | Security focus | Checkov, TFSec, Terrascan |
| `best-practices-only` | Code quality focus | TFLint, Terraform validation |

### GitHub Actions Inputs

```yaml
inputs:
  analysis_type:
    default: 'full'
    options: ['full', 'security-only', 'best-practices-only']
  image_tag:
    default: 'latest'
    description: 'Docker image tag to use'
  skip_errors:
    default: true
    description: 'Continue on tool failures'
```

## 📊 What You Get

### ✅ Automated Analysis
- **Security vulnerabilities** detection
- **Compliance** checking (CIS, NIST, SOC2)
- **Best practices** validation
- **Multi-cloud** support (AWS, Azure, GCP)

### 📋 Rich Reporting
- **Pull request comments** with analysis results
- **GitHub Security tab** integration via SARIF
- **Workflow artifacts** with detailed reports
- **Executive summaries** with actionable items

### 🔒 Security Integration
- **SARIF files** uploaded to GitHub Security
- **Vulnerability tracking** across commits
- **Compliance monitoring** over time

## 🎯 Example Usage Scenarios

### 1. New Repository Setup
```bash
# Copy just one file
curl -o .github/workflows/terraform-analysis.yml \
  https://raw.githubusercontent.com/YOUR_USERNAME/terraform-analyzer/main/.github/workflows/use-published-analyzer.yml

# Commit and push
git add .github/workflows/terraform-analysis.yml
git commit -m "Add Terraform security analysis"
git push
```

### 2. Custom Analysis Pipeline
```yaml
- name: Security-Only Analysis
  run: |
    docker run --rm \
      -v "$PWD:/workspace:ro" \
      -v "$PWD/output:/output" \
      -e ANALYSIS_TYPE=security-only \
      ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest
```

### 3. Specific Version/Tag
```yaml
env:
  DOCKER_IMAGE: ghcr.io/YOUR_USERNAME/terraform-security-analyzer:v1.2.0
```

## 🚀 Advanced Features

### Multi-Repository Management

Create a **template repository** with the workflow file, then:
1. Use GitHub's "Use this template" feature
2. All new repositories get automatic Terraform analysis

### Organization-Wide Deployment

1. **Build once** in your organization's repository
2. **Use everywhere** across all Terraform projects
3. **Centralized updates** - update the image, all repos benefit

### Custom Tool Configurations

Fork the repository and modify:
- `Dockerfile` - Add/remove security tools
- `scripts/analyze.sh` - Customize analysis logic
- Rebuild and publish your custom image

## 🔍 Troubleshooting

### Common Issues

1. **Image pull fails:**
   ```
   Error: Failed to pull image
   Solution: Ensure repository has 'packages: read' permission
   ```

2. **No Terraform files found:**
   ```
   The workflow automatically detects and handles repositories without .tf files
   ```

3. **Analysis fails on large repositories:**
   ```yaml
   # Use security-only for faster analysis
   env:
     ANALYSIS_TYPE: security-only
   ```

### Debug Mode
```yaml
- name: Debug Analysis
  run: |
    docker run --rm \
      -v "$PWD:/workspace:ro" \
      -v "$PWD/output:/output" \
      -e ANALYSIS_TYPE=full \
      -e SKIP_ERRORS=false \
      ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest
```

## 📈 Monitoring and Metrics

### GitHub Insights
- View analysis results in **Actions** tab
- Track security issues in **Security** tab
- Monitor trends via **Insights** graphs

### Custom Notifications
Extend the workflow to notify:
- Slack channels
- Microsoft Teams
- Email alerts
- Custom webhooks

```yaml
- name: Notify on Critical Issues
  if: contains(steps.analysis.outputs.result, 'CRITICAL')
  uses: your-org/slack-notify@v1
  with:
    message: "Critical Terraform issues found in ${{ github.repository }}"
```

## 🏢 Enterprise Features

### Compliance Reporting
- **SOC2** compliance tracking
- **CIS benchmarks** validation
- **Custom policies** enforcement

### Integration Capabilities
- **SIEM systems** via SARIF/JSON output
- **Vulnerability management** tools
- **Infrastructure as Code** platforms

### Scaling Considerations
- **Parallel execution** for large codebases
- **Selective analysis** for changed files only
- **Caching strategies** for faster runs

## 🔄 Maintenance

### Image Updates
Images are automatically rebuilt:
- **Weekly** for security updates
- **On tool updates** (Checkov, TFSec, etc.)
- **On manual trigger**

### Version Management
- `:latest` - Always current version
- `:v1.0.0` - Specific release versions
- `:main-abc123` - Specific commit versions

## 📄 License

MIT License - Use freely in commercial and open-source projects.

---

*Making Terraform security analysis simple, automated, and reusable across your entire organization.*