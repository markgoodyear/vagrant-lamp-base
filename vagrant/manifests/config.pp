####################################
# Base config
# Advanced setup will require editing default.pp
####################################

# Database settings
$db_name = 'database'
$db_user = 'root'
$db_pass = 'root'
$db_host = 'localhost'
$db_sql  = '/var/www/db/database.sql'

# Named vhost
$vhost_name   = 'project'
$vhost_server = 'project.dev'
$vhost_alias  = 'www.project.dev'
