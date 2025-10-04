FROM python:3.11-slim

WORKDIR /app

COPY ../mcp/requirements.txt .
RUN pip install -r requirements.txt

COPY ../mcp/simple_mcp_server.py .

EXPOSE 8080

CMD ["python", "simple_mcp_server.py"]
