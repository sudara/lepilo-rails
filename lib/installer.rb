#class Lepilo
  class Installer
    DB_CONFIG = File.join(RAILS_ROOT, 'config', 'database.yml')

    def self.ensure_environment(copy_from, copy_to)
      copy_from = File.join(RAILS_ROOT, 'config', 'environments', copy_from+'.rb')
      copy_to = File.join(RAILS_ROOT, 'config', 'environments', copy_to+'.rb')
      
      if File.exists?(copy_to)
      else
        # if its not a default environment, we need to copy a file
        FileUtils.cp(copy_from, copy_to) 
      end
    end
    
    def self.add_database_entry(entry)
      if ActiveRecord::Base.configurations[entry['environment']]
        ActiveRecord::Base.configurations[entry['environment']].delete
      end
      ActiveRecord::Base.configurations[entry['environment']] = entry.except 'environment'
    end    
    
    def self.write_database_file
      require 'yaml'
      config = ActiveRecord::Base.configurations
      File.open(DB_CONFIG, 'w'){ |f| f.write config.to_yaml }
    end
    
    def self.ensure_database_file
      File.cp(File.join(RAILS_ROOT, 'config', 'database.example.yml'), DB_CONFIG) unless File.exists? DB_CONFIG
    end
  end
#end