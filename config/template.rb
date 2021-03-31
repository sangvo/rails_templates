if DATABASE_TYPE == "mysql"
  copy_file "config/database_mysql.yml", "config/database.yml", force: true
else
  copy_file "config/database_postgresql.yml", "config/database.yml", force: true
end
template "config/application.sample.yml", force: true
