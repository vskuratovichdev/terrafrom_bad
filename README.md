# 🏗️ Terraform Security Analyzer

A comprehensive Docker-based security analyzer for Terraform infrastructure code that can be reused across any GitHub repository.

> **Note**: This repository contains both a Terraform project AND the security analyzer. See [README-terraform-project.md](README-terraform-project.md) for the original Terraform project documentation.

## 🚀 Quick Start

### For Repository Owners (Build & Publish)

1. **Fork this repository** (or copy the analyzer files to your own repo)
2. **Push to main branch** - Docker image automatically builds and publishes to:
   ```
   ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest
   ```

### For Users (Use in Any Repository)

1. **Copy one file** to your Terraform repository:
   ```
   .github/workflows/use-published-analyzer.yml
   ```

2. **Update the image name** in the workflow:
   ```yaml
   env:
     DOCKER_IMAGE: ghcr.io/YOUR_USERNAME/terraform-security-analyzer:latest
   ```

3. **That's it!** Analysis runs automatically on Terraform changes.

## 📦 What's Included

- **Terraform** - Native validation and formatting
- **Checkov** - Security and compliance scanning
- **TFSec** - Security-focused static analysis
- **TFLint** - Best practices validation
- **Terrascan** - Multi-cloud security scanning

## 🎯 Key Features

✅ **Zero local building** - Uses pre-built Docker image
✅ **Automatic PR comments** with analysis results
✅ **GitHub Security integration** via SARIF files
✅ **Multi-platform support** (AMD64 + ARM64)
✅ **Configurable analysis types** (full, security-only, best-practices-only)
✅ **Enterprise ready** with security attestations

## 📋 Analyzer Files

```
├── Dockerfile                              # Multi-tool security analyzer image
├── scripts/
│   └── analyze.sh                         # Main analysis script
├── .github/workflows/
│   ├── build-and-publish-docker.yml       # Builds & publishes image
│   └── use-published-analyzer.yml         # Template for other repos
├── .dockerignore                          # Docker build optimization
└── README-reusable-analyzer.md           # Detailed usage guide
```

## 📊 Analysis Output

- **Markdown reports** with executive summaries
- **SARIF files** for GitHub Security tab
- **JSON results** for programmatic processing
- **Severity classification** (Critical, High, Medium, Low)
- **Actionable recommendations**

## 🔧 Configuration

### Analysis Types
- `full` - Complete security + best practices analysis
- `security-only` - Focus on security vulnerabilities
- `best-practices-only` - Code quality and formatting

### Environment Variables
- `ANALYSIS_TYPE` - Type of analysis to perform
- `SKIP_ERRORS` - Continue on tool failures (default: true)

## 📖 Documentation

- **[Reusable Analyzer Guide](README-reusable-analyzer.md)** - Complete setup and usage instructions
- **[Original Terraform Project](README-terraform-project.md)** - Documentation for the Terraform infrastructure

## 🚀 Local Testing

Test the analyzer on this repository:

```bash
# Build the image
docker build -t terraform-security-analyzer .

# Run analysis on this repo
mkdir -p output
docker run --rm \
  -v "$(pwd):/workspace:ro" \
  -v "$(pwd)/output:/output" \
  terraform-security-analyzer

# View results
cat output/analysis-report.md
```

## 🤝 Contributing

1. Fork the repository
2. Make your changes to tools or analysis logic
3. Test with sample Terraform code
4. Submit a pull request

## 📄 License

MIT License - Use freely in commercial and open-source projects.

---

*Making Terraform security analysis simple, automated, and reusable across your entire organization.*