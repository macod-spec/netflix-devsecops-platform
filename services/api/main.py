import os
from typing import Dict

import httpx
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Netflix Platform API",
    description="Backend API layer for the Netflix-style frontend. Proxies approved movie/content requests to TMDB.",
    version="1.0.0",
)

TMDB_BASE_URL = os.getenv("TMDB_BASE_URL", "https://api.themoviedb.org/3").rstrip("/")
TMDB_API_KEY = os.getenv("TMDB_API_KEY")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["GET"],
    allow_headers=["*"],
)


@app.get("/")
def root() -> Dict[str, str]:
    return {
        "service": "netflix-platform-api",
        "status": "running",
    }


@app.get("/health")
def health() -> Dict[str, str]:
    return {"status": "healthy"}


@app.get("/ready")
def ready() -> Dict[str, str]:
    if not TMDB_API_KEY:
        raise HTTPException(status_code=503, detail="TMDB_API_KEY is        raise HTTPException(statutatus": "ready"}


async def proxy_to_tmdb(tmdb_paasync def proxy_to_tmdb(tmdb_paasync def proxy_tKEY:async def proxy_to_tmdb(tmdb_paasync def proxy_toailasync def _KEY is not configured")

    params = dict(request.query_params)
    params["api_key"] = TMDB_API_KEY

    url = f"{TMDB_BASE_URL}/{tmdb_path.lstrip('/')}"
    url = f"{TMDB_Bpx.AsyncClient(timeout=15.0) as client:
        response = await client.get(url, params=para        response = await client.get(ur0:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    return    return    returnapp.get    return    return   ")
asyasyasyasyasy_tasyasyasyasyasy_tasyasdb_path:asyasyasyasstasyasyasyasyasy_tasyasyasyasyasy_tasyatmdb(asyasyasyasyasy_tasyasyasy.geasya{tmdasyasyasyasyasy_tancasyasyasyasyasy_tasyasyasya_prefix(tmdb_path: str, request: Request):
    return await proxy_to_tmdb(tmdb_path, request)
