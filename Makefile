.PHONY: all phase1 phase2 check-os check-permissions verify-versions verify-installation update-all update-git update-brave update-github update-memory update-sequential install-base install-deps install-git install-brave install-github install-memory install-sequential clean clean-deep

# Colors for terminal output
YELLOW := \033[1;33m
GREEN := \033[1;32m
RED := \033[1;31m
BLUE := \033[1;34m
NC := \033[0m # No Color

# OS detection
UNAME_S := $(shell uname -s)

# Required versions
NODE_VERSION := 22
PYTHON_VERSION := 3.10.0
PYENV_VERSION := 2.3.35
NVM_VERSION := 0.39.0
UV_VERSION := 0.1.23

# Base paths
REPO_ROOT := $(shell pwd)
SERVERS_DIR := $(REPO_ROOT)/servers/src
BACKUP_DIR := $(REPO_ROOT)/.backup

# Python command detection
PYTHON_CMD := python3

all:
	@echo "$(YELLOW)This installation requires two phases:$(NC)"
	@echo "1. First run: $(GREEN)make phase1$(NC)"
	@echo "2. Restart your terminal"
	@echo "3. Then run: $(GREEN)make phase2$(NC)"
	@exit 0

check-permissions:
	@echo "$(BLUE)Checking permissions...$(NC)"
	@if [ ! -w "$(REPO_ROOT)" ]; then \
		echo "$(RED)Error: No write permission in repository directory$(NC)"; \
		exit 1; \
	fi
	@if [ ! -w "$(SERVERS_DIR)" ]; then \
		echo "$(RED)Error: No write permission in servers directory$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✓ Permissions OK$(NC)"

verify-versions:
	@echo "$(BLUE)Verifying installed versions...$(NC)"
	@if ! command -v $(PYTHON_CMD) >/dev/null 2>&1; then \
		echo "$(RED)Error: Python command not found. Please ensure Python 3.10+ is installed and accessible.$(NC)"; \
		exit 1; \
	fi
	@echo "Debug: Using Python command: $$(which $(PYTHON_CMD))"
	@PYTHON_VERSION_CHECK=$$(/usr/bin/env -i HOME=$$HOME PATH=/usr/bin:/bin $(PYTHON_CMD) -c "import sys; print('yes' if sys.version_info[:2] >= (3,10) else 'no')" 2>/dev/null) && \
	if [ "$$PYTHON_VERSION_CHECK" = "yes" ]; then \
		echo "$(GREEN)✓ Python version check passed: $$($(PYTHON_CMD) --version)$(NC)"; \
	else \
		echo "$(RED)Error: Python 3.10+ required. Current version: $$($(PYTHON_CMD) --version)$(NC)"; \
		exit 1; \
	fi
	@if ! node -e "process.exit(process.version.match(/^v(\d+)/)[1] >= 22 ? 0 : 1)" 2>/dev/null; then \
		echo "$(RED)Error: Node.js 22+ required$(NC)"; \
		exit 1; \
	fi
	@if command -v pyenv >/dev/null 2>&1; then \
		if ! pyenv --version | grep -q "$(PYENV_VERSION)" 2>/dev/null; then \
			echo "$(YELLOW)Warning: pyenv $(PYENV_VERSION) recommended$(NC)"; \
		fi \
	fi
	@if [ -f "$$HOME/.nvm/nvm.sh" ]; then \
		if ! grep -q "$(NVM_VERSION)" "$$HOME/.nvm/nvm.sh" 2>/dev/null; then \
			echo "$(YELLOW)Warning: nvm $(NVM_VERSION) recommended$(NC)"; \
		fi \
	fi
	@echo "$(GREEN)✓ Versions OK$(NC)"

check-os:
	@echo "$(BLUE)Detecting operating system...$(NC)"
ifeq ($(UNAME_S),Darwin)
	@echo "$(GREEN)✓ macOS detected$(NC)"
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "$(RED)Error: Homebrew is required for macOS$(NC)"; \
		echo "Install from https://brew.sh"; \
		exit 1; \
	fi
else ifeq ($(UNAME_S),Linux)
	@echo "$(GREEN)✓ Linux detected$(NC)"
	@if ! command -v apt-get >/dev/null 2>&1; then \
		echo "$(RED)Error: apt-get is required for Linux$(NC)"; \
		exit 1; \
	fi
else
	@echo "$(RED)Unsupported operating system: $(UNAME_S)$(NC)"
	@exit 1
endif

backup-env:
	@echo "$(BLUE)Creating backup of current environment...$(NC)"
	@mkdir -p $(BACKUP_DIR)
	@if [ -d "$$HOME/.pyenv" ]; then \
		tar czf $(BACKUP_DIR)/pyenv_backup.tar.gz -C $$HOME .pyenv; \
	fi
	@if [ -d "$$HOME/.nvm" ]; then \
		tar czf $(BACKUP_DIR)/nvm_backup.tar.gz -C $$HOME .nvm; \
	fi
	@echo "$(GREEN)✓ Backup created$(NC)"

restore-env:
	@if [ -f "$(BACKUP_DIR)/pyenv_backup.tar.gz" ]; then \
		echo "$(BLUE)Restoring pyenv...$(NC)"; \
		tar xzf $(BACKUP_DIR)/pyenv_backup.tar.gz -C $$HOME; \
	fi
	@if [ -f "$(BACKUP_DIR)/nvm_backup.tar.gz" ]; then \
		echo "$(BLUE)Restoring nvm...$(NC)"; \
		tar xzf $(BACKUP_DIR)/nvm_backup.tar.gz -C $$HOME; \
	fi
	@echo "$(GREEN)✓ Environment restored$(NC)"

phase1: check-os check-permissions backup-env
	@echo "$(BLUE)Phase 1: Installing system requirements...$(NC)"
	@echo "$(BLUE)Checking Python installation...$(NC)"
	@if ! command -v python3 >/dev/null 2>&1; then \
		echo "$(YELLOW)Python not found. Installing...$(NC)"; \
		if [ "$(UNAME_S)" = "Darwin" ]; then \
			brew install python@3.10 || ($(MAKE) restore-env && exit 1); \
		else \
			sudo apt-get update && \
			sudo apt-get install -y python3.10 python3-pip python-is-python3 || ($(MAKE) restore-env && exit 1); \
		fi; \
	else \
		if [ "$(UNAME_S)" = "Linux" ]; then \
			if ! command -v python >/dev/null 2>&1; then \
				echo "$(YELLOW)Installing python-is-python3 package...$(NC)"; \
				sudo apt-get update && \
				sudo apt-get install -y python-is-python3 || ($(MAKE) restore-env && exit 1); \
			fi; \
			if ! command -v pip3 >/dev/null 2>&1; then \
				echo "$(YELLOW)Installing pip...$(NC)"; \
				sudo apt-get update && \
				sudo apt-get install -y python3-pip || ($(MAKE) restore-env && exit 1); \
			fi; \
		fi; \
	fi
	@echo "$(BLUE)Checking Node.js installation...$(NC)"
	@if ! command -v node >/dev/null 2>&1; then \
		echo "$(YELLOW)Node.js not found. Installing...$(NC)"; \
		if [ "$(UNAME_S)" = "Darwin" ]; then \
			brew install node@22 || ($(MAKE) restore-env && exit 1); \
		else \
			curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
			sudo apt-get install -y nodejs || ($(MAKE) restore-env && exit 1); \
		fi; \
	else \
		if node -e "process.exit(process.version.match(/^v(\d+)/)[1] >= 22 ? 0 : 1)" 2>/dev/null; then \
			echo "$(GREEN)✓ Compatible Node.js version found$(NC)"; \
		else \
			echo "$(YELLOW)Installing Node.js $(NODE_VERSION)...$(NC)"; \
			if [ "$(UNAME_S)" = "Darwin" ]; then \
				brew install node@22 || ($(MAKE) restore-env && exit 1); \
			else \
				curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && \
				sudo apt-get install -y nodejs || ($(MAKE) restore-env && exit 1); \
			fi; \
		fi; \
	fi
	@echo "$(BLUE)Installing version managers...$(NC)"
	@if [ -d "$$HOME/.pyenv" ]; then \
		echo "$(YELLOW)pyenv already installed, skipping...$(NC)"; \
	else \
		if [ "$(UNAME_S)" = "Darwin" ]; then \
			brew install pyenv || ($(MAKE) restore-env && exit 1); \
		else \
			curl https://pyenv.run | bash || ($(MAKE) restore-env && exit 1); \
		fi; \
	fi
	@if [ ! -d "$$HOME/.nvm" ]; then \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$(NVM_VERSION)/install.sh | bash || ($(MAKE) restore-env && exit 1); \
	fi
	@echo "$(GREEN)✓ Phase 1 complete!$(NC)"
	@echo "$(YELLOW)Please restart your terminal and run: make phase2$(NC)"

phase2: verify-versions
	@echo "$(BLUE)Phase 2: Installing MCP servers...$(NC)"
	@echo "$(BLUE)Setting up Node.js environment...$(NC)"
	@if [ ! -f "$$HOME/.nvm/nvm.sh" ]; then \
		echo "$(RED)Error: nvm is not installed. Please run 'make phase1' first.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Loading nvm...$(NC)"
	@if ! node -e "process.exit(process.version.match(/^v(\d+)/)[1] >= 22 ? 0 : 1)" 2>/dev/null; then \
		bash -c 'source $$HOME/.nvm/nvm.sh && nvm install 22 && nvm use 22' || exit 1; \
	else \
		echo "$(GREEN)✓ Node.js 22+ already installed$(NC)"; \
	fi
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "$(YELLOW)Installing uv package manager...$(NC)"; \
		/usr/bin/env -i HOME=$$HOME PATH=/usr/bin:/bin $(PYTHON_CMD) -m pip install uv==$(UV_VERSION) || exit 1; \
	fi
	@echo "$(BLUE)Setting up Python environment...$(NC)"
	@PYTHON_VERSION_CHECK=$$(/usr/bin/env -i HOME=$$HOME PATH=/usr/bin:/bin $(PYTHON_CMD) -c "import sys; print('yes' if sys.version_info[:2] >= (3,10) else 'no')" 2>/dev/null) && \
	if [ "$$PYTHON_VERSION_CHECK" = "yes" ]; then \
		echo "$(GREEN)✓ Using system Python $$($(PYTHON_CMD) --version)$(NC)"; \
	else \
		echo "$(RED)Error: Python 3.10+ is required but not found$(NC)"; \
		exit 1; \
	fi
	@$(MAKE) install-git
	@$(MAKE) install-brave
	@$(MAKE) install-github
	@$(MAKE) install-memory
	@$(MAKE) install-sequential
	@$(MAKE) verify-installation
	@$(MAKE) print-instructions

verify-installation:
	@echo "$(BLUE)Verifying installations...$(NC)"
	@cd "$(SERVERS_DIR)/git" && \
		/usr/bin/env -i \
		HOME=$$HOME \
		PATH=/usr/bin:/bin:$$HOME/.local/bin \
		PYTHONPATH="" \
		PYTHONHOME="" \
		. .venv/bin/activate && \
		/usr/bin/python3 -c "import mcp_server_git" || echo "$(RED)Git MCP verification failed$(NC)"
	@cd "$(SERVERS_DIR)/brave-search" && node -e "require('@modelcontextprotocol/server-brave-search')" || echo "$(RED)Brave Search MCP verification failed$(NC)"
	@cd "$(SERVERS_DIR)/github" && node -e "require('@modelcontextprotocol/server-github')" || echo "$(RED)GitHub MCP verification failed$(NC)"
	@cd "$(SERVERS_DIR)/memory" && node -e "require('@modelcontextprotocol/server-memory')" || echo "$(RED)Memory MCP verification failed$(NC)"
	@cd "$(SERVERS_DIR)/sequentialthinking" && node -e "require('@modelcontextprotocol/server-sequential-thinking')" || echo "$(RED)Sequential Thinking MCP verification failed$(NC)"
	@echo "$(GREEN)✓ Installation verification complete$(NC)"

update-all: update-git update-brave update-github update-memory update-sequential

update-git:
	@echo "$(BLUE)Updating Git MCP...$(NC)"
	@cd "$(SERVERS_DIR)/git" && . .venv/bin/activate && uv pip install --upgrade -e .

update-brave:
	@echo "$(BLUE)Updating Brave Search MCP...$(NC)"
	@cd "$(SERVERS_DIR)/brave-search" && npm update

update-github:
	@echo "$(BLUE)Updating GitHub MCP...$(NC)"
	@cd "$(SERVERS_DIR)/github" && npm update

update-memory:
	@echo "$(BLUE)Updating Memory MCP...$(NC)"
	@cd "$(SERVERS_DIR)/memory" && npm update

update-sequential:
	@echo "$(BLUE)Updating Sequential Thinking MCP...$(NC)"
	@cd "$(SERVERS_DIR)/sequentialthinking" && npm update

install-git:
	@echo "$(BLUE)Installing Git MCP...$(NC)"
	@cd "$(SERVERS_DIR)/git" && \
	PYTHON_VERSION_CHECK=$$(/usr/bin/env -i HOME=$$HOME PATH=/usr/bin:/bin $(PYTHON_CMD) -c "import sys; print('yes' if sys.version_info[:2] >= (3,10) else 'no')" 2>/dev/null) && \
	if [ "$$PYTHON_VERSION_CHECK" = "yes" ]; then \
		echo "$(GREEN)Using system Python for Git MCP installation$(NC)" && \
		/usr/bin/env -i \
		HOME=$$HOME \
		PATH=/usr/bin:/bin:$$HOME/.local/bin \
		PYTHONPATH="" \
		PYTHONHOME="" \
		/usr/bin/python3 -m venv .venv && \
		. .venv/bin/activate && \
		/usr/bin/env -i \
		HOME=$$HOME \
		PATH=/usr/bin:/bin:$$HOME/.local/bin \
		PYTHONPATH="" \
		PYTHONHOME="" \
		pip install uv==$(UV_VERSION) && \
		uv pip install -e . || exit 1; \
	else \
		echo "$(RED)Error: Python 3.10+ is required but not found$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✓ Git MCP installed$(NC)"

install-brave:
	@echo "$(BLUE)Installing Brave Search MCP...$(NC)"
	@cd "$(SERVERS_DIR)/brave-search" && npm install
	@echo "$(GREEN)✓ Brave Search MCP installed$(NC)"

install-github:
	@echo "$(BLUE)Installing GitHub MCP...$(NC)"
	@cd "$(SERVERS_DIR)/github" && npm install
	@echo "$(GREEN)✓ GitHub MCP installed$(NC)"

install-memory:
	@echo "$(BLUE)Installing Memory MCP...$(NC)"
	@cd "$(SERVERS_DIR)/memory" && npm install
	@echo "$(GREEN)✓ Memory MCP installed$(NC)"

install-sequential:
	@echo "$(BLUE)Installing Sequential Thinking MCP...$(NC)"
	@cd "$(SERVERS_DIR)/sequentialthinking" && npm install
	@echo "$(GREEN)✓ Sequential Thinking MCP installed$(NC)"

print-instructions:
	@echo "\n$(YELLOW)=== IMPORTANT: API Keys Required ===$(NC)"
	@echo "$(RED)1. Brave Search API Key Required:$(NC)"
	@echo "   - Get your API key from: https://brave.com/search/api/"
	@echo "   - Set it in your environment: export BRAVE_API_KEY=your_key_here"
	@echo "\n$(RED)2. GitHub Personal Access Token Required:$(NC)"
	@echo "   - Generate a token at: https://github.com/settings/tokens"
	@echo "   - Required scopes: repo, workflow (optional)"
	@echo "   - Set it in your environment: export GITHUB_PERSONAL_ACCESS_TOKEN=your_token_here"
	@echo "\n$(YELLOW)=== Cursor MCP Configuration Required ===$(NC)"
	@echo "Configure the following MCPs in Cursor (Settings > Features > MCP):"
	@echo "\n1. Git MCP:"
	@echo "   Name: Git"
	@echo "   Type: stdio"
	@echo "   Command: uvx mcp-server-git --repository /path/to/your/repo"
	@echo "\n2. Brave Search MCP:"
	@echo "   Name: Brave Search"
	@echo "   Type: stdio"
	@echo "   Command: npx -y @modelcontextprotocol/server-brave-search"
	@echo "\n3. GitHub MCP:"
	@echo "   Name: GitHub"
	@echo "   Type: stdio"
	@echo "   Command: npx -y @modelcontextprotocol/server-github"
	@echo "\n4. Memory MCP:"
	@echo "   Name: Memory"
	@echo "   Type: stdio"
	@echo "   Command: npx -y @modelcontextprotocol/server-memory"
	@echo "\n5. Sequential Thinking MCP:"
	@echo "   Name: Sequential Thinking"
	@echo "   Type: stdio"
	@echo "   Command: npx -y @modelcontextprotocol/server-sequential-thinking"
	@echo "\n$(GREEN)✓ Installation complete! Don't forget to configure your MCPs in Cursor and set up your API keys.$(NC)"
	@echo "\n$(YELLOW)Note: You may need to restart your terminal for all changes to take effect.$(NC)"

clean:
	@echo "$(BLUE)Cleaning up...$(NC)"
	@find . -type d -name "node_modules" -exec rm -rf {} +
	@find . -type d -name "dist" -exec rm -rf {} +
	@find . -type d -name ".venv" -exec rm -rf {} +
	@find . -type d -name "__pycache__" -exec rm -rf {} +
	@find . -type f -name "*.pyc" -delete
	@npm cache clean --force
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

clean-deep: clean
	@echo "$(BLUE)Performing deep cleanup...$(NC)"
	@if [ "$(UNAME_S)" = "Darwin" ]; then \
		brew uninstall --force node@18 python@3.10 pyenv 2>/dev/null || true; \
	else \
		sudo apt-get remove -y nodejs python3.10 2>/dev/null || true; \
	fi
	@rm -rf $$HOME/.nvm $$HOME/.pyenv 2>/dev/null || true
	@rm -rf $(BACKUP_DIR)
	@echo "$(GREEN)✓ Deep cleanup complete$(NC)"