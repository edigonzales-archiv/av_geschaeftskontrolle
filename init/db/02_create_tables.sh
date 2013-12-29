DB_NAME="xanadu"
DB_SCHEMA="av_geschaeftskontrolle"


sudo -u postgres psql -d $DB_NAME -c "DROP SCHEMA IF EXISTS $DB_SCHEMA CASCADE;"
sudo -u postgres psql -d $DB_NAME -f ../../xanadu.sql
sudo -u postgres psql -d $DB_NAME -f ../../insert_data.sql
