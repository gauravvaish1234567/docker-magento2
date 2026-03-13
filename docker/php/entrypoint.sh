#!/usr/bin/env sh
set -e

MAGENTO_DIR="/var/www/html"
MAGENTO_BIN="$MAGENTO_DIR/bin/magento"

run_magento_maintenance() {
  echo "Magento installation detected. Running startup maintenance commands..."
  php "$MAGENTO_BIN" setup:upgrade
  php "$MAGENTO_BIN" setup:static-content:deploy -f
  php "$MAGENTO_BIN" cache:flush
  php "$MAGENTO_BIN" indexer:reindex
}

if [ -f "$MAGENTO_BIN" ] && [ -f "$MAGENTO_DIR/app/etc/env.php" ]; then
  run_magento_maintenance
else
  echo "Magento is not installed yet (missing bin/magento or app/etc/env.php). Skipping startup maintenance."
fi

exec php-fpm
