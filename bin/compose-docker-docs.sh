#!/bin/bash -e

temp_dir=$(mktemp -d)
work_dir="${temp_dir}/docker-docs"

git clone --recursive --depth 1 https://github.com/docker/docker.github.io ${work_dir}
pushd "${work_dir}"

patch << EOF
--- a/docker-compose.yml	2022-04-05 10:54:44.869721600 +0200
+++ docker.github.io/docker-compose.yml	2022-03-30 06:39:59.843301300 +0200
@@ -19,3 +19,4 @@
     image: docs/docstage
     ports:
      - "4000:4000"
+    restart: unless-stopped
EOF

docker compose up --detach --build

popd
rm -rf "${temp_dir}"
