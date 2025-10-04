#!/usr/bin/env python3
"""
Simple MCP Server Example

This is a basic Model Context Protocol (MCP) server implementation in Python.
MCP allows applications to provide context and tools to AI assistants.

This server demonstrates:
- How to create an MCP server
- How to define tools with input schemas
- How to handle tool calls and return responses
- How to run the server using stdio transport

To use this server:
1. Install the mcp package: pip install mcp
2. Run this script: python simple_mcp_server.py
3. The server will communicate via stdin/stdout with MCP clients

This example provides a simple "greet" tool that takes a name parameter
and returns a greeting message.
"""

# Import required libraries for MCP server
import asyncio
from mcp.server import Server
from mcp.types import Tool, TextContent

# Create the MCP server instance with a name
app = Server("simple-mcp")

# Define what tools this server provides
@app.list_tools()
async def list_tools():
    return [
        Tool(
            name="greet",  # Tool name that clients will call
            description="Generate a greeting message",  # What the tool does
            inputSchema={  # Define expected parameters
                "type": "object",
                "properties": {
                    "name": {"type": "string", "description": "Name to greet"}
                },
                "required": ["name"]  # Which parameters are mandatory
            }
        )
    ]

# Handle tool execution when called by client
@app.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "greet":
        # Extract the name parameter from arguments
        user_name = arguments.get("name", "World")
        # Return response as TextContent
        return [TextContent(type="text", text=f"Hello, {user_name}! Welcome to MCP.")]
    
    # Handle unknown tools
    raise ValueError(f"Unknown tool: {name}")

# Main function to run the server
async def main():
    # Use stdio transport (communicates via stdin/stdout)
    from mcp.server.stdio import stdio_server
    async with stdio_server() as (read_stream, write_stream):
        await app.run(read_stream, write_stream, app.create_initialization_options())

# Start the server when script is run directly
if __name__ == "__main__":
    asyncio.run(main())
