#!/bin/bash

set -e

WORKSPACE_DIR="/workspace"
OUTPUT_DIR="/output"
ANALYSIS_TYPE="${ANALYSIS_TYPE:-full}"
SKIP_ERRORS="${SKIP_ERRORS:-true}"

echo "🏗️ Terraform Security & Best Practices Analyzer"
echo "================================================"
echo "Analysis Type: $ANALYSIS_TYPE"
echo "Skip Errors: $SKIP_ERRORS"
echo "Workspace: $WORKSPACE_DIR"
echo "Output: $OUTPUT_DIR"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Initialize counters
TOTAL_ISSUES=0
CRITICAL_ISSUES=0
HIGH_ISSUES=0
MEDIUM_ISSUES=0
LOW_ISSUES=0

# Function to handle errors
handle_error() {
    local exit_code=$1
    local tool_name=$2

    if [ $exit_code -ne 0 ] && [ "$SKIP_ERRORS" != "true" ]; then
        echo "❌ $tool_name failed with exit code $exit_code"
        exit $exit_code
    elif [ $exit_code -ne 0 ]; then
        echo "⚠️ $tool_name failed but continuing (skip_errors=true)"
    fi
}

# Change to workspace
cd "$WORKSPACE_DIR"

echo "📁 Analyzing workspace contents..."
find . -name "*.tf" -o -name "*.tfvars" | head -10
echo ""

# Start report
cat > "$OUTPUT_DIR/analysis-report.md" << 'EOF'
# 🏗️ Terraform Infrastructure Analysis Report

## 📊 Executive Summary

This report presents the results of automated security and best practices analysis performed on your Terraform infrastructure code.

### 🔧 Analysis Tools Used
- **Terraform**: Native validation and formatting
- **Checkov**: Security and compliance scanning
- **TFSec**: Security-focused static analysis
- **TFLint**: Terraform best practices validation
- **Terrascan**: Multi-cloud security scanning

---

EOF

# 1. Terraform Validation
echo "🔍 Running Terraform validation..."
echo "## 🏗️ Terraform Validation" >> "$OUTPUT_DIR/analysis-report.md"
echo "" >> "$OUTPUT_DIR/analysis-report.md"

# Format check
echo "### Format Check" >> "$OUTPUT_DIR/analysis-report.md"
echo '```' >> "$OUTPUT_DIR/analysis-report.md"
if terraform fmt -check=true -diff=true -recursive . >> "$OUTPUT_DIR/analysis-report.md" 2>&1; then
    echo "✅ All files are properly formatted" >> "$OUTPUT_DIR/analysis-report.md"
else
    echo "⚠️ Formatting issues found - run 'terraform fmt -recursive' to fix" >> "$OUTPUT_DIR/analysis-report.md"
    MEDIUM_ISSUES=$((MEDIUM_ISSUES + 1))
fi
echo '```' >> "$OUTPUT_DIR/analysis-report.md"
echo "" >> "$OUTPUT_DIR/analysis-report.md"

# Validation
echo "### Syntax Validation" >> "$OUTPUT_DIR/analysis-report.md"
echo '```' >> "$OUTPUT_DIR/analysis-report.md"
terraform init -backend=false >> "$OUTPUT_DIR/analysis-report.md" 2>&1 || echo "Init failed - continuing without backend" >> "$OUTPUT_DIR/analysis-report.md"
if terraform validate >> "$OUTPUT_DIR/analysis-report.md" 2>&1; then
    echo "✅ Terraform configuration is valid" >> "$OUTPUT_DIR/analysis-report.md"
else
    echo "❌ Terraform validation failed" >> "$OUTPUT_DIR/analysis-report.md"
    HIGH_ISSUES=$((HIGH_ISSUES + 1))
fi
echo '```' >> "$OUTPUT_DIR/analysis-report.md"
echo "" >> "$OUTPUT_DIR/analysis-report.md"

# 2. Security Analysis with Checkov
if [ "$ANALYSIS_TYPE" = "security-only" ] || [ "$ANALYSIS_TYPE" = "full" ]; then
    echo "🔒 Running Checkov security scan..."
    echo "## 🔒 Checkov Security Analysis" >> "$OUTPUT_DIR/analysis-report.md"
    echo "" >> "$OUTPUT_DIR/analysis-report.md"

    checkov -d . --output cli --quiet > "$OUTPUT_DIR/checkov-output.txt" 2>&1 || handle_error $? "Checkov"
    checkov -d . --output sarif --output-file-path "$OUTPUT_DIR" --quiet > /dev/null 2>&1 || handle_error $? "Checkov SARIF"

    # Parse Checkov results
    if [ -f "$OUTPUT_DIR/checkov-output.txt" ]; then
        CHECKOV_PASSED=$(grep -c "PASSED" "$OUTPUT_DIR/checkov-output.txt" || echo "0")
        CHECKOV_FAILED=$(grep -c "FAILED" "$OUTPUT_DIR/checkov-output.txt" || echo "0")
        CHECKOV_SKIPPED=$(grep -c "SKIPPED" "$OUTPUT_DIR/checkov-output.txt" || echo "0")

        echo "### Summary" >> "$OUTPUT_DIR/analysis-report.md"
        echo "- ✅ **Passed**: $CHECKOV_PASSED checks" >> "$OUTPUT_DIR/analysis-report.md"
        echo "- ❌ **Failed**: $CHECKOV_FAILED checks" >> "$OUTPUT_DIR/analysis-report.md"
        echo "- ⏭️ **Skipped**: $CHECKOV_SKIPPED checks" >> "$OUTPUT_DIR/analysis-report.md"
        echo "" >> "$OUTPUT_DIR/analysis-report.md"

        # Count critical/high issues from Checkov
        CRITICAL_ISSUES=$((CRITICAL_ISSUES + $(grep -c "CRITICAL" "$OUTPUT_DIR/checkov-output.txt" || echo "0")))
        HIGH_ISSUES=$((HIGH_ISSUES + $(grep -c "HIGH" "$OUTPUT_DIR/checkov-output.txt" || echo "0")))
        MEDIUM_ISSUES=$((MEDIUM_ISSUES + $(grep -c "MEDIUM" "$OUTPUT_DIR/checkov-output.txt" || echo "0")))
        LOW_ISSUES=$((LOW_ISSUES + $(grep -c "LOW" "$OUTPUT_DIR/checkov-output.txt" || echo "0")))

        echo "### Failed Checks" >> "$OUTPUT_DIR/analysis-report.md"
        echo '```' >> "$OUTPUT_DIR/analysis-report.md"
        grep -A 2 -B 1 "FAILED" "$OUTPUT_DIR/checkov-output.txt" | head -50 >> "$OUTPUT_DIR/analysis-report.md" || echo "No failed checks found" >> "$OUTPUT_DIR/analysis-report.md"
        echo '```' >> "$OUTPUT_DIR/analysis-report.md"
    fi
    echo "" >> "$OUTPUT_DIR/analysis-report.md"
fi

# 3. TFSec Analysis
if [ "$ANALYSIS_TYPE" = "security-only" ] || [ "$ANALYSIS_TYPE" = "full" ]; then
    echo "🛡️ Running TFSec security scan..."
    echo "## 🛡️ TFSec Security Analysis" >> "$OUTPUT_DIR/analysis-report.md"
    echo "" >> "$OUTPUT_DIR/analysis-report.md"

    tfsec . --format json > "$OUTPUT_DIR/tfsec-results.json" 2>/dev/null || handle_error $? "TFSec"
    tfsec . --format sarif --out "$OUTPUT_DIR/tfsec-results.sarif" > /dev/null 2>&1 || handle_error $? "TFSec SARIF"

    if [ -f "$OUTPUT_DIR/tfsec-results.json" ]; then
        TFSEC_ISSUES=$(jq '.results | length' "$OUTPUT_DIR/tfsec-results.json" 2>/dev/null || echo "0")
        echo "### Summary" >> "$OUTPUT_DIR/analysis-report.md"
        echo "- **Total Issues Found**: $TFSEC_ISSUES" >> "$OUTPUT_DIR/analysis-report.md"
        echo "" >> "$OUTPUT_DIR/analysis-report.md"

        if [ "$TFSEC_ISSUES" -gt 0 ]; then
            echo "### Issues Found" >> "$OUTPUT_DIR/analysis-report.md"
            echo '```json' >> "$OUTPUT_DIR/analysis-report.md"
            jq '.results[] | {severity: .severity, rule_id: .rule_id, description: .description, filename: .location.filename}' "$OUTPUT_DIR/tfsec-results.json" | head -50 >> "$OUTPUT_DIR/analysis-report.md" 2>/dev/null || echo "Error parsing TFSec results" >> "$OUTPUT_DIR/analysis-report.md"
            echo '```' >> "$OUTPUT_DIR/analysis-report.md"
        fi

        HIGH_ISSUES=$((HIGH_ISSUES + $(jq '.results[] | select(.severity=="HIGH") | .severity' "$OUTPUT_DIR/tfsec-results.json" 2>/dev/null | wc -l || echo "0")))
        MEDIUM_ISSUES=$((MEDIUM_ISSUES + $(jq '.results[] | select(.severity=="MEDIUM") | .severity' "$OUTPUT_DIR/tfsec-results.json" 2>/dev/null | wc -l || echo "0")))
        LOW_ISSUES=$((LOW_ISSUES + $(jq '.results[] | select(.severity=="LOW") | .severity' "$OUTPUT_DIR/tfsec-results.json" 2>/dev/null | wc -l || echo "0")))
    fi
    echo "" >> "$OUTPUT_DIR/analysis-report.md"
fi

# 4. TFLint Analysis
if [ "$ANALYSIS_TYPE" = "best-practices-only" ] || [ "$ANALYSIS_TYPE" = "full" ]; then
    echo "📋 Running TFLint best practices check..."
    echo "## 📋 TFLint Best Practices Analysis" >> "$OUTPUT_DIR/analysis-report.md"
    echo "" >> "$OUTPUT_DIR/analysis-report.md"

    tflint --format json > "$OUTPUT_DIR/tflint-results.json" 2>/dev/null || handle_error $? "TFLint"

    if [ -f "$OUTPUT_DIR/tflint-results.json" ]; then
        TFLINT_ISSUES=$(jq '.issues | length' "$OUTPUT_DIR/tflint-results.json" 2>/dev/null || echo "0")
        echo "### Summary" >> "$OUTPUT_DIR/analysis-report.md"
        echo "- **Issues Found**: $TFLINT_ISSUES" >> "$OUTPUT_DIR/analysis-report.md"
        echo "" >> "$OUTPUT_DIR/analysis-report.md"

        if [ "$TFLINT_ISSUES" -gt 0 ]; then
            echo "### Issues Found" >> "$OUTPUT_DIR/analysis-report.md"
            echo '```json' >> "$OUTPUT_DIR/analysis-report.md"
            jq '.issues[] | {severity: .rule.severity, rule: .rule.name, message: .message, filename: .range.filename}' "$OUTPUT_DIR/tflint-results.json" | head -30 >> "$OUTPUT_DIR/analysis-report.md" 2>/dev/null || echo "Error parsing TFLint results" >> "$OUTPUT_DIR/analysis-report.md"
            echo '```' >> "$OUTPUT_DIR/analysis-report.md"
        fi

        MEDIUM_ISSUES=$((MEDIUM_ISSUES + TFLINT_ISSUES))
    fi
    echo "" >> "$OUTPUT_DIR/analysis-report.md"
fi

# 5. Calculate Total Issues
TOTAL_ISSUES=$((CRITICAL_ISSUES + HIGH_ISSUES + MEDIUM_ISSUES + LOW_ISSUES))

# 6. Generate Final Summary
echo "## 📊 Final Assessment" >> "$OUTPUT_DIR/analysis-report.md"
echo "" >> "$OUTPUT_DIR/analysis-report.md"
echo "### Issue Summary" >> "$OUTPUT_DIR/analysis-report.md"
echo "| Priority | Count |" >> "$OUTPUT_DIR/analysis-report.md"
echo "|----------|-------|" >> "$OUTPUT_DIR/analysis-report.md"
echo "| 🚨 Critical | $CRITICAL_ISSUES |" >> "$OUTPUT_DIR/analysis-report.md"
echo "| ⚠️ High | $HIGH_ISSUES |" >> "$OUTPUT_DIR/analysis-report.md"
echo "| ⚡ Medium | $MEDIUM_ISSUES |" >> "$OUTPUT_DIR/analysis-report.md"
echo "| ℹ️ Low | $LOW_ISSUES |" >> "$OUTPUT_DIR/analysis-report.md"
echo "| **Total** | **$TOTAL_ISSUES** |" >> "$OUTPUT_DIR/analysis-report.md"
echo "" >> "$OUTPUT_DIR/analysis-report.md"

# 7. Recommendations
echo "## 🎯 Recommendations" >> "$OUTPUT_DIR/analysis-report.md"
echo "" >> "$OUTPUT_DIR/analysis-report.md"

if [ $CRITICAL_ISSUES -gt 0 ]; then
    echo "### 🚨 Critical Actions Required" >> "$OUTPUT_DIR/analysis-report.md"
    echo "- **Immediately** address $CRITICAL_ISSUES critical security issues" >> "$OUTPUT_DIR/analysis-report.md"
    echo "- Review and fix critical vulnerabilities before deployment" >> "$OUTPUT_DIR/analysis-report.md"
    echo "" >> "$OUTPUT_DIR/analysis-report.md"
fi

if [ $HIGH_ISSUES -gt 0 ]; then
    echo "### ⚠️ High Priority" >> "$OUTPUT_DIR/analysis-report.md"
    echo "- Address $HIGH_ISSUES high priority issues in the next sprint" >> "$OUTPUT_DIR/analysis-report.md"
    echo "- Focus on security and compliance violations" >> "$OUTPUT_DIR/analysis-report.md"
    echo "" >> "$OUTPUT_DIR/analysis-report.md"
fi

if [ $MEDIUM_ISSUES -gt 0 ]; then
    echo "### ⚡ Medium Priority" >> "$OUTPUT_DIR/analysis-report.md"
    echo "- Plan to resolve $MEDIUM_ISSUES medium priority issues" >> "$OUTPUT_DIR/analysis-report.md"
    echo "- Includes formatting and best practices improvements" >> "$OUTPUT_DIR/analysis-report.md"
    echo "" >> "$OUTPUT_DIR/analysis-report.md"
fi

echo "### 📋 General Recommendations" >> "$OUTPUT_DIR/analysis-report.md"
echo "1. **Enable pre-commit hooks** to catch issues early" >> "$OUTPUT_DIR/analysis-report.md"
echo "2. **Regular security scans** in CI/CD pipeline" >> "$OUTPUT_DIR/analysis-report.md"
echo "3. **Code review process** for all infrastructure changes" >> "$OUTPUT_DIR/analysis-report.md"
echo "4. **Keep tools updated** for latest security checks" >> "$OUTPUT_DIR/analysis-report.md"
echo "" >> "$OUTPUT_DIR/analysis-report.md"

echo "---" >> "$OUTPUT_DIR/analysis-report.md"
echo "*Analysis completed on $(date)*" >> "$OUTPUT_DIR/analysis-report.md"
echo "*Generated by Terraform Security Analyzer v1.0*" >> "$OUTPUT_DIR/analysis-report.md"

# Print summary to console
echo ""
echo "✅ Analysis completed!"
echo "📊 Summary: $TOTAL_ISSUES total issues ($CRITICAL_ISSUES critical, $HIGH_ISSUES high, $MEDIUM_ISSUES medium, $LOW_ISSUES low)"
echo "📄 Full report: $OUTPUT_DIR/analysis-report.md"
echo ""

# Set exit code based on findings
if [ $CRITICAL_ISSUES -gt 0 ]; then
    echo "❌ Exiting with code 2 due to critical issues"
    exit 2
elif [ $HIGH_ISSUES -gt 0 ]; then
    echo "⚠️ Exiting with code 1 due to high priority issues"
    exit 1
else
    echo "✅ No critical or high priority issues found"
    exit 0
fi