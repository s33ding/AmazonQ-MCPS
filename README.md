# AmazonQ-MCPS
This repository is dedicated to the development of the Machine Learning and Cognitive Processing System (MCPS) for Amazon Q. It focuses on building advanced AI models and systems that enhance cognitive capabilities, streamline decision-making, and optimize data processing for Amazon Q, leveraging cutting-edge techniques in machine learning and AI.

## MCP Architecture

Model Context Protocol (MCP) enables AI assistants to connect with external tools and data sources. This simple architecture allows extending AI capabilities through standardized communication.

### How it Works

```
┌─────────────────┐    MCP Protocol    ┌─────────────────┐
│                 │ ◄─────────────────► │                 │
│   AI Assistant  │                    │   MCP Server    │
│   (Amazon Q)    │                    │  (Your Tools)   │
│                 │                    │                 │
└─────────────────┘                    └─────────────────┘
```

### Components

- **AI Assistant**: Amazon Q or other MCP-compatible clients
- **MCP Server**: Your Python server that provides tools
- **Protocol**: JSON-RPC communication over stdin/stdout

### Simple Example

Our MCP server provides a "greet" tool:

1. AI Assistant asks: "What tools are available?"
2. MCP Server responds: "I have a 'greet' tool"
3. AI Assistant calls: `greet(name="Roberto")`
4. MCP Server returns: "Hello, Roberto! Welcome to MCP."

## Getting Started

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run the MCP server:
   ```bash
   python simple_mcp_server.py
   ```

3. The server communicates via stdin/stdout with MCP clients like Amazon Q.
