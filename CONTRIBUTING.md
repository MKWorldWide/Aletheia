# Contributing to Aletheia 🌌

Thank you for your interest in contributing to Aletheia! This document provides guidelines for contributing to the Aletheia project.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Development Setup](#development-setup)
- [Making Changes](#making-changes)
  - [Code Style](#code-style)
  - [Git Commit Guidelines](#git-commit-guidelines)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)
- [Code Review Process](#code-review-process)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

- Python 3.11+
- pip (Python package manager)
- Git
- [Poetry](https://python-poetry.org/) (recommended) or pip
- Node.js 18+ (for frontend development)

### Development Setup

1. **Fork the repository**
   ```bash
   # Fork the repository on GitHub
   # Then clone your fork
   git clone https://github.com/your-username/Aletheia.git
   cd Aletheia
   ```

2. **Set up Python environment**
   ```bash
   # Using pyenv (recommended)
   pyenv install 3.11.0
   pyenv local 3.11.0

   # Create and activate virtual environment
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   # Install development dependencies
   pip install -r requirements-dev.txt
   
   # Install pre-commit hooks
   pre-commit install
   ```

4. **Set up environment variables**
   ```bash
   # Copy the example environment file
   cp .env.example .env
   # Edit the .env file with your configuration
   ```

## Making Changes

### Code Style

#### Python
- Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/) style guide
- Use type hints for all function signatures
- Include docstrings following [Google style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)
- Maximum line length: 88 characters
- Use `black` for code formatting
- Use `isort` for import sorting

#### Swift
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use 4 spaces for indentation
- Maximum line length: 100 characters

### Git Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) for our commit messages. The format should be:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Commit Types
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semicolons, etc. (no code change)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

Example:
```
feat(auth): add OAuth2 authentication

- Add Google OAuth2 provider
- Implement JWT token generation
- Update documentation

Closes #123
```

## Testing

### Running Tests

```bash
# Run all tests
pytest

# Run tests with coverage
pytest --cov=aletheia --cov-report=term-missing

# Run a specific test file
pytest tests/test_module.py

# Run a specific test
pytest tests/test_module.py::test_function
```

### Writing Tests
- Write tests for all new functionality
- Follow the Arrange-Act-Assert pattern
- Use descriptive test names
- Keep tests independent and isolated

## Pull Request Process

1. Fork the repository and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Reporting Issues

When reporting issues, please include:
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Environment details (OS, Python version, etc.)
- Any relevant logs or error messages

## Code Review Process

1. A maintainer will review your PR
2. The PR may go through several rounds of review
3. Once approved, a maintainer will merge your PR

## Community

Join our community channels:
- [Discord](#) (coming soon)
- [GitHub Discussions](#) (coming soon)

## License

By contributing, you agree that your contributions will be licensed under the project's [LICENSE](LICENSE).

### Swift
- Follow Swift API Design Guidelines
- Add documentation comments
- Use MARK comments for organization

## Testing

- Write tests for new functionality
- Ensure all tests pass before submitting
- Test on multiple platforms when possible

## Documentation

- Update README.md for user-facing changes
- Add docstrings for new APIs
- Keep documentation current

Thank you for contributing! 🌟 