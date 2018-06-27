#InfiniteCampus uses MSSQL and self signed certificates so we need these credentials to form a connection
$username = "dbusername"
$password = "dbpassword"
$dbserverstring = "db1.domain.tld,1234"
$database = "dbname"
$connectionString = "Server=$dbserverstring;Database=$database;User ID=$username;Password=$password;encrypt=true;trustServerCertificate=true"