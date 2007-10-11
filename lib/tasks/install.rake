# Lepilo Deluxe Installer
# Author: Sudara
#
# All "hardcore" functionality lives in installer.rb
#
# Inspired from, and chunks of code stolen from "Rake Install Tasks for RAM" by Garry Dolley


DEFAULT_ENVIRONMENTS = ['production', 'development', 'test']
DB_ADAPTERS = [
  { :mysql          => 'MySQL'           },
  { :postgresql     => 'PostgreSQL'      },
  { :sqlite         => 'SQLite'          },
  { :sqlite3        => 'SQLite3'         },
  { :firebird       => 'Firebird'        },
  { :sqlserver      => 'SQL Server'      },
  { :sqlserver_odbc => 'SQL Server ODBC' },
  { :db2            => 'DB2'             },
  { :oracle         => 'Oracle'          },
  { :sybase         => 'Sybase'          },
  { :openbase       => 'OpenBase'        }
]

namespace :lepilo do
  
  
  require "#{RAILS_ROOT}/lib/installer"
  require "#{RAILS_ROOT}/lib/tasks/rake_tools"
  include RakeTools
  
  Installer.ensure_database_file
  
  require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

  
  @new_db_entries = {}  # For adding new sites/database.yml entries
  
  task :ensure_database_config do
    require 'active_record'

    clear
    h1  "Getting the Databases squared away..."
    unless ActiveRecord::Base.configurations.size > 0
      DEFAULT_ENVIRONMENTS.each {|env| create_database_entry env}
    end
    

    Rake::Task['lepilo:list_sites'].invoke

    loop do
      flash
      ask "Would you like to setup another website and database?"
      if yes
        Rake::Task['lepilo:new_site'].invoke
      else
        break
      end
    end

    ask "Would you like to make sure each database is created?" 
    Rake::Task['db:create:all'].invoke if yes
  end

  task :preload => :environment do

    h1   "Loading schema into development environment"
    puts "We are going to load in the default database schema into the development"
    puts "This may generate a page or two of output, which you can ignore, unless the"
    puts "migration fails."
    puts ""
    puts "If this step fails, the installer will exit. You must correct the problem"
    puts "causing the failing migration and run this installer again."
    puts ""

    print "Press ENTER to continue..."
    STDIN.getc

    puts ""
    puts "Loading Schema..."
    Rake::Task['db:schema:load'].invoke
  end

  desc "list existing databases"
  task :list_sites do
    puts "The following sites/databases are known about in Lepilo:"
    br
    ActiveRecord::Base.configurations.each_key{|env| puts "  * " + env}
  end

  task :new_site do
    clear
    create_database_entry
  end

  task :dependencies do
    begin
      # This comes straight from config/environment.rb.
      # If a change to this list is made there, make it here too.
      require 'RMagick'
    rescue LoadError => boom
      puts ""
      puts "We're sorry, but it appears you don't have all the required dependencies"
      puts ""
      puts boom.message
      puts ""
      puts "Lepilo requires the following Ruby libraries:"
      puts ""
      puts "  * RMagick (soon to be made optional)"
      puts ""
      puts "Please make sure you have all these installed and then run 'rake install'"
      puts "again."
      puts ""
      exit
    end
  end

  task :banner do
    clear
    puts <<-BANNER

  Lepilo version 1.0 Installer
  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

  Welcome to Lepilo, the Rails Content Creation System 

  This installer will walk you through the hardest part of getting
  you on Lepilo. Some day, we will laugh at this as we point and
  click through our graphical UI installer, like any other application platform.

  For now, Here is what we are going to do
  
    * Create your first Lepilo database
    * Create a config/database.yml
    * Import the Lepilo database schema
    * Set some defaults (you can change these later)
    * Boot up mongrel, if you like

    BANNER

    ask "Ready?"
    exit unless yes
  end

  desc "Install Lepilo for the first time, or add/remove sites"
  task :install => [:dependencies, :banner, :ensure_database_config ] do
    clear
    h1  "Congratulations!  Lepilo is ready to go!"
    br
    ask  "Would you like to start Lepilo on port 3333 in development mode?"

    server_start_cmd = "./script/server -d -p 3333"

    if yes
      br
      puts "You can run this again:"
      puts server_start_cmd
      puts ""
      begin
        %x{#{server_start_cmd}}
        br
        h2   "Point your browser to: http://" + `hostname`.chomp + ":3333 and create a new account!"
        puts ""
      rescue => boom
        puts "How professional. Somthing went wrong:"
        puts boom.message
      end
    end
    sleep 1 # :)
    br 
    puts "That wasn't too hard, was it?"
    puts ""
    puts "(If it was, be sure to email us and tell us why!)"
    puts ""
    puts "- Samo and Sudara"
  end
  
  def create_database_entry(env = nil)
    entry = {}
    
    # prepend lepilo for our default environments
    if env 
      entry['environment'] = 'lepilo_' + env 
      h2  "Setting up "+env
    else
      h2  "Setting up new site"
      puts "Please enter the name of the site, making sure it is all one word"
      entry['environment'] = STDIN.gets.chomp.downcase
    end
    
    puts ""
    puts "Select your database adapter:\n\n"

    DB_ADAPTERS.each_with_index do |db, num|
      puts "#{num+1}. #{db.to_a[0][1]}"
    end

    puts  ""

    ch = ''
    loop do
      print ": "
      break if (ch = STDIN.gets) =~ /^[1-9][0-9]*$/ and !DB_ADAPTERS[ch.to_i - 1].nil?
    end

    entry['adapter'] = DB_ADAPTERS[ch.to_i - 1].to_a[0][0].to_s
    
    entry['database'] = request "Please enter the database name you wish to create", :default => entry['environment']

    entry['username'] = request "Please enter the database username you wish to use", :default => 'root'

    entry['password'] = request "Please enter the database password you wish to use", :default => ''

    entry['hostname'] = 'localhost' 
    
    Installer.add_database_entry(entry)
    Installer.ensure_environment('production',entry['environment'])
    Installer.write_database_file
    set_flash :notice, "database.yml updated and config/#{entry['environment']} created"
  end
  

end