# MCP Servers Setup

This repository contains the implementation of Model Context Protocol (MCP) servers, including Sequential Thinking, Memory, and GitHub integration capabilities.

## Prerequisites

1. **NodeJS Installation**
   - Download and install NodeJS from the [official website](https://nodejs.org/)
   - Verify installation:
     ```bash
     node --version
     npm --version
     ```

## Setup Instructions

### 1. Sequential Thinking MCP
The Sequential Thinking MCP server provides advanced problem-solving capabilities through a structured thinking process.

- Supports dynamic and reflective problem-solving
- Enables step-by-step analysis
- Allows for course correction and revision of thoughts
- Maintains context across multiple steps

### 2. Memory MCP
The Memory MCP server provides persistent storage and retrieval of information.

- Stores and manages knowledge graph entities
- Supports relations between entities
- Enables observation tracking
- Provides search capabilities

### 3. GitHub MCP
The GitHub MCP server enables interaction with GitHub repositories and features.

- Repository management
- Issue and PR handling
- File operations
- Branch management
- Search capabilities

## Environment Setup

1. **GitHub Authentication**
   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN=your_token_here
   ```
   - Required scopes:
     - `repo` (Full control of repositories)
     - `workflow` (Optional, for GitHub Actions)
     - `read:org` (Optional, for organization access)

## Usage

Each MCP server provides specific functionality through a standardized protocol:

- Sequential Thinking: Problem-solving and analysis
- Memory: Knowledge storage and retrieval
- GitHub: Repository and code management

## Development

The servers are implemented in TypeScript and follow best practices for maintainability and scalability.

## Repository Structure

```
servers/
├── .github/
│   ├── workflows/         # GitHub Actions workflow configurations
│   ├── codeql/           # Code scanning and security analysis
│   └── CODEOWNERS        # Code ownership and review assignments
├── src/
│   ├── memory/           # Memory MCP implementation
│   ├── github/           # GitHub MCP implementation
│   └── sequential/       # Sequential Thinking MCP implementation
└── tests/                # Test suites for all MCPs
```

## Security Measures

1. **Code Scanning**
   - CodeQL analysis enabled for automated security scanning
   - Regular vulnerability checks through GitHub Actions
   - Custom CodeQL configurations in `.github/codeql/codeql-config.yml`

2. **Branch Protection**
   - Main branch protected against direct pushes
   - Required reviews before merging
   - Status checks must pass before merging
   - Branch is up-to-date before merging

3. **Access Control**
   - CODEOWNERS file defines required reviewers
   - Personal access tokens with limited scopes
   - Regular token rotation and access reviews

## Workflow Configurations

1. **Continuous Integration**
   - Automated testing on pull requests
   - TypeScript compilation checks
   - Linting and code style enforcement
   - Version compatibility checks

2. **Code Quality**
   - Automated code reviews
   - Security scanning
   - Dependency updates through Dependabot
   - Performance monitoring

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your PR:
- Follows the existing code style
- Includes appropriate tests
- Updates documentation as needed
- Passes all CI checks

## License

This project is licensed under the MIT License - see the LICENSE file for details.
