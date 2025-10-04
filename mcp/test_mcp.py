#!/usr/bin/env python3
import json
import subprocess
import sys

def test_mcp_server():
    # Start the server process
    process = subprocess.Popen(
        [sys.executable, 'simple_mcp_server.py'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    # Initialize the server
    init_msg = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {"name": "test-client", "version": "1.0.0"}
        }
    }
    
    # Send initialization
    process.stdin.write(json.dumps(init_msg) + '\n')
    process.stdin.flush()
    
    # Read response
    response = process.stdout.readline()
    print("Init response:", response.strip())
    
    # List tools
    tools_msg = {
        "jsonrpc": "2.0",
        "id": 2,
        "method": "tools/list"
    }
    
    process.stdin.write(json.dumps(tools_msg) + '\n')
    process.stdin.flush()
    
    response = process.stdout.readline()
    print("Tools response:", response.strip())
    
    process.terminate()

if __name__ == "__main__":
    test_mcp_server()
