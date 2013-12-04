ADMIN="stefan"
ADMINPWD="ziegler12"
USER="mspublic"
USERPWD="mspublic"

DB_NAME="xanadu"
PG_VERSION="9.1"
DB_SCHEMA="av_geschaeftskontrolle"

# Auskommentieren falls man z.B. nur DB neu anlegen will.
#echo "Create database user"
#sudo -u postgres psql -d postgres -c "CREATE ROLE $ADMIN CREATEDB LOGIN PASSWORD '$ADMINPWD';"
#sudo -u postgres psql -d postgres -c "CREATE ROLE $USER LOGIN PASSWORD '$USERPWD';"

#echo "Create database: $DB_NAME"
#sudo -u postgres createdb --owner $ADMIN $DB_NAME
#sudo -u postgres createlang plpgsql $DB_NAME
#sudo -u postgres psql -d $DB_NAME -c "ALTER SCHEMA public OWNER TO $ADMIN;"

echo "Load postgis"
sudo -u postgres psql -d $DB_NAME -f /usr/share/postgresql/$PG_VERSION/contrib/postgis-1.5/postgis.sql
sudo -u postgres psql -d $DB_NAME -f /usr/share/postgresql/$PG_VERSION/contrib/postgis-1.5/spatial_ref_sys.sql


echo "Create schema: $DB_SCHEMA"
#sudo -u postgres psql -d $DB_NAME -c "CREATE SCHEMA $DB_SCHEMA;"
#sudo -u postgres psql -d $DB_NAME -c "ALTER SCHEMA $DB_SCHEMA OWNER TO $ADMIN;"
#sudo -u postgres psql -d $DB_NAME -c "GRANT USAGE ON SCHEMA $DB_SCHEMA TO $USER;"



