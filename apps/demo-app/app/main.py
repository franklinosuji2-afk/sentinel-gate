"""KubeSentinel demo application.

Exposes /health, /metrics, and /api. Intentionally tiny — the platform around
it (GitOps + policies + scanning + runtime detection) is the interesting part.
"""
from __future__ import annotations

import logging
import os
import socket

from fastapi import FastAPI
from fastapi.responses import JSONResponse, PlainTextResponse
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s %(message)s")
log = logging.getLogger("kubesentinel.demo")

app = FastAPI(title="KubeSentinel Demo API", version="0.1.0")
REQUESTS = Counter("demo_requests_total", "Total API requests", ["endpoint"])


@app.get("/health")
def health() -> JSONResponse:
    REQUESTS.labels("/health").inc()
    return JSONResponse({"status": "ok", "host": socket.gethostname()})


@app.get("/metrics")
def metrics() -> PlainTextResponse:
    return PlainTextResponse(generate_latest(), media_type=CONTENT_TYPE_LATEST)


@app.get("/api")
def api() -> dict:
    REQUESTS.labels("/api").inc()
    log.info("api hit")
    return {
        "app": "kubesentinel-demo",
        "version": os.getenv("APP_VERSION", "0.1.0"),
        "message": "Hello from a policy-compliant pod 👋",
    }
