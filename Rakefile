require 'active_support'
require 'active_record'

require File.expand_path('../boot', __FILE__)

def get_env name, default=nil
  ENV[name] || ENV[name.downcase] || default
end

namespace :db do
  desc "prepare environment (utility)"
  task :env do
    require 'bundler'
    env = get_env 'RACK_ENV', 'development'
    Bundler.require :default, env.to_sym
    unless defined?(DB_CONFIG)
      databases = YAML.load_file File.dirname(__FILE__) + '/config/database.yml'
      DB_CONFIG = databases[env]
    end
    puts "loaded config for #{env}"
  end

  desc "connect db (utility)"
  task connect: :env do
    "connecting to #{DB_CONFIG['database']}"
    ActiveRecord::Base.establish_connection DB_CONFIG
  end

  desc "create db for current RACK_ENV"
  task create: :env do
    puts "creating db #{DB_CONFIG['database']}"
    ActiveRecord::Base.establish_connection DB_CONFIG.merge('database' => nil)
    ActiveRecord::Base.connection.create_database DB_CONFIG['database'], charset: 'utf8'
    ActiveRecord::Base.establish_connection DB_CONFIG
  end

  desc 'drop db for current RACK_ENV'
  task drop: :env do
    if get_env('RACK_ENV') == 'production'
      puts "cannot drop production database!"
    else
      puts "dropping db #{DB_CONFIG['database']}"
      ActiveRecord::Base.establish_connection DB_CONFIG.merge('database' => nil)
      ActiveRecord::Base.connection.drop_database DB_CONFIG['database']
    end
  end
  
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migration => :connect do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
  
  desc 'run migrations'
  task migrate: :connect do
    version = get_env 'VERSION'
    version = version ? version.to_i : nil
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate 'db/migrate', version
  end

  desc 'rollback migrations (STEP = 1 by default)'
  task rollback: :connect do
    step = get_env 'STEP'
    step = step ? step.to_i : 1
    ActiveRecord::Migrator.rollback 'db/migrate', step
  end

  desc "show current schema version"
  task version: :connect do
    puts ActiveRecord::Migrator.current_version
  end
  
  desc 'Load the seed data from db/seeds.rb'
  task :seed do
    seed_file = File.join('db/seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end

end