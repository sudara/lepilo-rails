class ActiveuploadGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # m.directory "lib"
      # m.template 'README', "README"
      m.template 'model.rb',
                  File.join('app/models',
                            "attachment.rb")
      m.template 'controller.rb',
                  File.join('app/controllers',
                            "attachments_controller.rb")
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "create_attachments"
    end
  end
end

