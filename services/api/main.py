import os
from typing import Any

import httpx
from fastapi import FastAPI, HTTPException, Request

app = FastAPI(title="Netflix Platform API")

TMDB_BASE_URL = os.getenv(
    "TMDB_BASE_URL",
    "https://api.themoviedb.org/3",
).rstrip("/")

TMDB_API_KEY = os.getenv("TMDB_API_KEY")


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
    if not TMDB_API_KEY:
        raise HTTPException(
            status_code=503,
            detail="TMDB_API_KEY is not configured",
        )

    return {"status": "ready"}


async def proxy_to_tmdb(tmdb_path: str, request: Request) -> Any:
    if not TMDB_API_KEY:
        raise HTTPException(
            status_code=500,
            detail="TMDB_API_KEY is not configured",
        )

    params = dict(request.query_params)
    params["api_key"] = TMDB_API_KEY

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