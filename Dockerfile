# Upstream's image, pinned. It already reads PORT, seeds the admin key from
# API_MASTER_KEY on first boot and keeps everything under /app/data.
FROM ghcr.io/rmyndharis/openwa:0.29.1
