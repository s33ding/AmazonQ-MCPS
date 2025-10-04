#!/usr/bin/env python3
"""
MCP Server Setup Script for Amazon Q

This script configures the MCP server to work with Amazon Q CLI.
Run this after installing the MCP server to enable the 'greet' tool.
"""

import json
import os
import sys
from pathlib import Path

def setup_mcp_server():
    """Configure MCP server for Amazon Q CLI"""
    
    # Get current script directory
    script_dir = Path(__file__).parent.absolute()
    server_path = script_dir / "simple_mcp_server.py"
    
    # Amazon Q MCP configuration directory
    mcp_dir = Path.home() / ".aws" / "amazonq" / "mcpAdmin"
    
    # Create directory if it doesn't exist
    mcp_dir.mkdir(parents=True, exist_ok=True)
    
    # Enable MCP
    state_file = mcp_dir / "mcp-state.json"
    state_file.write_text(json.dumps({"enabled": True}, indent=2))
    
    # Configure server
    servers_config = {
        "simple-mcp": {
            "command": "python3",
            "args": [str(server_path)],
            "env": {}
        }
    }
    
    servers_file = mcp_dir / "servers.json"
    servers_file.write_text(json.dumps(servers_config, indent=2))
    
    print(f"✅ MCP server configured at: {servers_file}")
    print(f"✅ Server path: {server_path}")
    print("\nTo use:")
    print("1. Restart Amazon Q CLI: q chat")
    print("2. Ask: 'What tools are available?'")
    print("3. Test: 'Use the greet tool with my name'")

if __name__ == "__main__":
    setup_mcp_server()
