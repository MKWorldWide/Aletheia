# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0.0 | :x:                |

## Reporting a Vulnerability

### Responsible Disclosure

We take all security vulnerabilities seriously. If you discover a security issue, please bring it to our attention right away!

### How to Report

Please report security vulnerabilities by emailing our security team at [security@aletheia.dev](mailto:security@aletheia.dev). 

**Please include the following in your report:**
- Description of the vulnerability
- Steps to reproduce the issue
- Impact of the vulnerability
- Any mitigations if known
- Your contact information (optional)

### Response Time

We will acknowledge receipt of your report within 48 hours and will keep you informed of the progress towards fixing the issue.

### Bug Bounty

We currently do not have a formal bug bounty program, but we are happy to recognize and thank contributors who help us improve our security.

## Security Updates

Security updates will be released as patch versions (e.g., 1.0.1, 1.0.2) for the latest minor version.

## Secure Development

### Dependencies

We use Dependabot to keep our dependencies up to date with the latest security patches.

### Code Review

All code changes are peer-reviewed before being merged into the main branch.

### Automated Scanning

We use the following automated security tools:
- GitHub's built-in secret scanning
- Dependabot for dependency vulnerability scanning
- CodeQL for static code analysis

## Security Best Practices

### For Users
- Always keep your dependencies up to date
- Never commit secrets or sensitive information to version control
- Use strong, unique passwords
- Enable 2FA for all accounts with access to this repository

### For Developers
- Follow the principle of least privilege
- Validate all user inputs
- Use parameterized queries to prevent SQL injection
- Keep dependencies up to date
- Never commit secrets to version control

## Incident Response

1. **Identification**: Detect and confirm the security incident
2. **Containment**: Limit the scope and impact of the incident
3. **Eradication**: Remove the cause of the incident
4. **Recovery**: Restore systems to normal operation
5. **Lessons Learned**: Document the incident and improve processes

## Contact

For any security-related questions or concerns, please contact [security@aletheia.dev](mailto:security@aletheia.dev).

---
Last Updated: 2025-08-29
