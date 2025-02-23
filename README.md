# MCP Servers

This repository contains various Model Context Protocol (MCP) servers for enhancing Cursor's capabilities.

## Prerequisites

Before installation, ensure you have:

1. **Operating System**
   - macOS (with Homebrew) or
   - Linux (with apt-get)

2. **System Requirements**
   - Python 3.10 or higher
   - Node.js 18 or higher (default installation: Node.js 22.13.1)
   - Write permissions in the installation directory

## Installation

The repository includes a comprehensive Makefile for automated installation:

1. First phase (system setup):
```bash
make phase1
```

2. Restart your terminal

3. Second phase (MCP installation):
```bash
make phase2
```

### Additional Make Commands
- `make update-all`: Update all MCP servers
- `make clean`: Remove installed dependencies
- `make clean-deep`: Complete system cleanup

## Available MCP Servers

### 1. Git MCP
Local Git repository interaction and automation:
- Repository status and file operations
- Branch and commit management
- Diff operations (staged, unstaged, between branches)

### 2. Brave Search MCP
Web and local search capabilities:
- Web search with filtering
- Local business search
- News and article search

### 3. GitHub MCP
GitHub integration and automation:
- Repository management
- Issue and PR handling
- Branch operations

### 4. Memory MCP
Persistent storage and retrieval:
- Knowledge graph management
- Entity and relation tracking
- Search capabilities

### 5. Sequential Thinking MCP
Structured problem-solving:
- Step-by-step analysis
- Dynamic thought revision
- Context maintenance

## Configuration

### Required API Keys

1. **Brave Search API Key**
   ```bash
   export BRAVE_API_KEY=your_key_here
   ```
   Get your key at: https://brave.com/search/api/

2. **GitHub Personal Access Token**
   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN=your_token_here
   ```
   Generate at: https://github.com/settings/tokens
   Required scopes: `repo`, `workflow` (optional)

### Cursor Setup

Configure each MCP in Cursor (Settings > Features > MCP):

1. **Git MCP**
   ```json
   {
     "name": "Git",
     "type": "stdio",
     "command": "uvx mcp-server-git --repository /path/to/your/repo"
   }
   ```

2. **Brave Search MCP**
   ```json
   {
     "name": "Brave Search",
     "type": "stdio",
     "command": "npx -y @modelcontextprotocol/server-brave-search"
   }
   ```

3. **GitHub MCP**
   ```json
   {
     "name": "GitHub",
     "type": "stdio",
     "command": "npx -y @modelcontextprotocol/server-github"
   }
   ```

4. **Memory MCP**
   ```json
   {
     "name": "Memory",
     "type": "stdio",
     "command": "npx -y @modelcontextprotocol/server-memory"
   }
   ```

5. **Sequential Thinking MCP**
   ```json
   {
     "name": "Sequential Thinking",
     "type": "stdio",
     "command": "npx -y @modelcontextprotocol/server-sequential-thinking"
   }
   ```

## Troubleshooting

1. **Installation Issues**
   - Run `make verify-installation` to check all components
   - Check system logs for error messages
   - Ensure all prerequisites are met

2. **API Key Issues**
   - Verify environment variables are set correctly
   - Check API key permissions and scopes
   - Ensure keys are not expired

3. **Cursor Configuration**
   - Verify MCP settings in Cursor
   - Check command paths and parameters
   - Restart Cursor after configuration changes
