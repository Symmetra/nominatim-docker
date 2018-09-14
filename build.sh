docker build .   -t dm-nominatim-docker   --build-arg BUILD_THREADS=6   --build-arg BUILD_MEMORY=6GB   --build-arg OSM2PGSQL_CACHE=4500   --build-arg RUNTIME_THREADS=3   --build-arg RUNTIME_MEMORY=4GB   --build-arg PBF_URL="http://download.geofabrik.de/europe/monaco-latest.osm.pbf http://download.geofabrik.de/europe/andorra-latest.osm.pbf http://download.geofabrik.de/europe/latvia-latest.osm.pbf http://download.geofabrik.de/europe/switzerland-latest.osm.pbf"   --build-arg REPLICATION_URL="http://download.geofabrik.de/europe/monaco-updates http://download.geofabrik.de/europe/andorra-updates http://download.geofabrik.de/europe/latvia-updates http://download.geofabrik.de/europe/switzerland-updates"
