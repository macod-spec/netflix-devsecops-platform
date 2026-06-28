import os
from pathlib import Path
from typing import Any

import httpx
from fastapi import FastAPI, HTTPException, Request

app = FastAPI(title="Netflix Platform API")

TMDB_BASE_URL = os.getenv(
    "TMDB_BASE_URL",
    "https://api.themoviedb.org/3",
).rstrip("/")

TMDB_API_KEY_FILE = os.getenv("TMDB_API_KEY_FILE")


def read_secret_file(secret_file_path: str | None) -> str | None:
    """
    Read a secret value from a mounted file.

    In Azure AKS, the TMDB API key is expected to be mounted from
    Azure Key Vault through the Secrets Store CSI Driver.

    For local development, this function returns None and the app
    falls back to the TMDB_API_KEY environment variable.
    """
    if not secret_file_path:
        return None

    try:
        secret_value = Path(secret_file_path).read_text(encoding="utf-8").strip()
    except FileNotFoundError:
        return None
    except OSError:
        return None

    return secret_value or None


def get_tmdb_api_key() -> str | None:
    """
    Resolve the TMDB API key.

    Priority:
    1. Azure Key Vault mounted secret file, via TMDB_API_KEY_FILE
    2. Local/dev environment variable, via TMDB_API_KEY
    """
    return read_secret_file(TMDB_API_KEY_FILE) or os.getenv("TMDB_API_KEY")


@app.get("/")
def root() -> dict[str, str]:
    return {
        "service": "netflix-platform-api",
        "status": "running",
    }


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "healthy"}


@app.get("/ready")
def ready() -> dict[str, str]:
    if not get_tmdb_api_key():
        raise HTTPException(
            status_code=503,
            detail="TMDB API key is not configured",
        )

    return {"status": "ready"}


async def proxy_to_tmdb(tmdb_path: str, request: Request) -> Any:
    tmdb_api_key = get_tmdb_api_key()

    if not tmdb_api_key:
        raise HTTPException(
            status_code=500,
            detail="TMDB API key is not configured",
        )

    params = dict(request.query_params)
    params["api_key"] = tmdb_api_key

    url = TMDB_BASE_URL + "/" + tmdb_path.lstrip("/")

    async with httpx.AsyncClient(timeout=15.0) as client:
        response = await client.get(url, params=params)

    if response.status_code >= 400:
        raise HTTPException(
            status_code=response.status_code,
            detail=response.text,
        )

    return response.json()


@app.get("/api/{tmdb_path:path}")
async def proxy_with_api_prefix(tmdb_path: str, request: Request) -> Any:
    return await proxy_to_tmdb(tmdb_path, request)


@app.get("/{tmdb_path:path}")
async def proxy_without_api_prefix(tmdb_path: str, request: Request) -> Any:
    return await proxy_to_tmdb(tmdb_path, request)
