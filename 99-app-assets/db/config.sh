SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
DB_GRANT_CMD="GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'${DB_SHORTNAME}' IDENTIFIED BY '${DB_PASSWORD}';"

echo "Creating Grant"
docker run --rm mysql:5.7 mysql --host ${DB_FQDN} --user ${DB_USER}@${DB_SHORTNAME} -p${DB_PASSWORD} -Bse "${DB_GRANT_CMD}"

echo "Creating tables and populating DB"
docker run --mount type=bind,source="${SCRIPTS_DIR}",target=/sql --rm mysql:5.7 mysql --host ${DB_FQDN} --user ${DB_USER}@${DB_SHORTNAME} -p${DB_PASSWORD} ${DB_NAME} -Bse "SOURCE /sql/database.sql"