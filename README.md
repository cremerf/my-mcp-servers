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

### 4. Git MCP
The Git MCP server provides local Git repository interaction and automation capabilities.

- Repository status checking
- File staging and committing
- Diff operations (staged, unstaged, between branches)
- Branch management
- Commit history viewing

Configuration:
```bash
# Using uvx (recommended)
uvx mcp-server-git --repository /path/to/your/repo
```

### 5. Brave Search MCP
The Brave Search MCP server enables web and local search capabilities.

- Web search with pagination and filtering
- Local business and place search
- Detailed information for businesses
- Smart fallback from local to web search
- Support for diverse content types

Configuration:
```bash
# Required environment variable
export BRAVE_API_KEY=your_api_key_here
```

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
