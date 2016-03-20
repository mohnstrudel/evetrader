namespace :drop_db do
  desc 'kill pgsql users so database can be dropped'
  task :kill_postgres_connections do
    on roles(:app) do
      execute 'echo "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname=\'evetrader_production\';" | psql -U postgres'
    end
  end
end