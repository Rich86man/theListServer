require './app'
require 'sinatra/activerecord/rake'

require 'active_record'
require 'fileutils'

namespace :db do

  desc "loads database configuration in for other tasks to run"
  task :load_config do
    ActiveRecord::Base.configurations = db_conf
    ActiveRecord::Base.establish_connection db_conf
  end

  desc "creates and migrates your database"
  task :setup => :load_config do
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
  end

  desc "migrate your database"
  task :migrate do
    ActiveRecord::Base.establish_connection db_conf

    ActiveRecord::Migrator.migrate(
        ActiveRecord::Migrator.migrations_paths,
        ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end

  desc 'Drops the database'
  task :drop => :load_config do
    ActiveRecord::Base.connection.drop_database db_conf['database']
  end

  desc 'Creates the database'
  task :create => :load_config do
    create db_conf
  end

  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Base.establish_connection db_conf

    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
  end

  namespace :test do

    desc "drop test database"
    task :drop do
      ENV['RACK_ENV'] = 'test'
      Rake::Task["db:drop"].invoke
    end

    desc "create the test database"
    task :create do
      ENV['RACK_ENV'] = 'test'
      Rake::Task["db:create"].invoke
    end

    desc "setup the test database"
    task :setup do
      ENV['RACK_ENV'] = 'test'
      Rake::Task["db:setup"].invoke
    end
  end

  desc "create an ActiveRecord migration in ./db/migrate"
  task :create_migration do
    name = ENV['NAME']
    abort("no NAME specified. use `rake db:create_migration NAME=create_users`") if !name

    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")
    filename = "#{version}_#{name}.rb"
    migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

    FileUtils.mkdir_p(ActiveRecord::Migrator.migrations_path)

    open(File.join(ActiveRecord::Migrator.migrations_path, filename), 'w') do |f|
      f << (<<-EOS).gsub("      ", "")
      class #{migration_name} < ActiveRecord::Migration
        def self.up
        end

        def self.down
        end
      end
      EOS
    end
  end

end

def env
  ENV['RACK_ENV'] || 'development'
end

def db_conf()
  config = YAML.load(ERB.new(File.read('config/database.yml')).result)[env]
end

def create( config )
  begin
    if config['adapter'] =~ /sqlite/
      if File.exist?(config['database'])
        $stderr.puts "#{config['database']} already exists"
      else
        begin
          # Create the SQLite database
          ActiveRecord::Base.establish_connection(config)
          ActiveRecord::Base.connection
        rescue
          $stderr.puts $!, *($!.backtrace)
          $stderr.puts "Couldn't create database for #{config.inspect}"
        end
      end
      return # Skip the else clause of begin/rescue
    else
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection
    end
  rescue
    case config['adapter']
      when 'mysql2'
        @charset = ENV['CHARSET'] || 'utf8'
        @collation = ENV['COLLATION'] || 'utf8_general_ci'
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => nil))
          ActiveRecord::Base.connection.create_database(config['database'], :charset => (config['charset'] || @charset),
                                                        :collation => (config['collation'] || @collation))
          ActiveRecord::Base.establish_connection(config)
        rescue
          $stderr.puts "Couldn't create database for #{config.inspect}, charset: #{config['charset'] || @charset},
  collation: #{config['collation'] || @collation}"
        end
      when 'postgresql'
        @encoding = config[:encoding] || ENV['CHARSET'] || 'utf8'
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
          ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => @encoding))
          ActiveRecord::Base.establish_connection(config)
        rescue
          $stderr.puts $!, *($!.backtrace)
          $stderr.puts "Couldn't create database for #{config.inspect}"
        end
    end
  else
    $stderr.puts "#{config['database']} already exists"
  end
end