class Mediablock < ActiveRecord::Base
  # image = name vom dateifeld im formular
  #validates_presence_of   :title,
  #                        :description
  has_and_belongs_to_many :block_links
  
  def file=(incoming_file)
    @tmp_file = incoming_file
    
    timestamp = Time.now
    self.original_name = base_part_of(incoming_file.original_filename)
    self.content_type = incoming_file.content_type.chomp
    self.title = self.original_name
    tstmp = timestamp.to_i.to_s
    get_extension = original_name.split('.')
    file_extension = get_extension[get_extension.length - 1]
    filetype = "jpg"
    self.original = "#{tstmp}.#{file_extension}"
    self.filename = "#{tstmp}.#{filetype}"
    self.thumbnail = "#{tstmp}.#{filetype}"
  end

  def importfile=(incoming_file)
    @importfile = incoming_file
    
    @importflag = true
    timestamp = Time.now
    generate_title = original_name.split('/')
    imported_file = generate_title[generate_title.length - 1]
    self.title = imported_file
    tstmp = timestamp.to_i.to_s
    get_extension = original_name.split('.')
    file_extension = get_extension[get_extension.length - 1]
    filetype = "jpg"
    self.original = "#{tstmp}.#{file_extension}"
    self.filename = "#{tstmp}.#{filetype}"
    self.thumbnail = "#{tstmp}.#{filetype}"

  end
  
  def after_save
      if @importflag
        File.open("#{RAILS_ROOT}/public/data/originals/#{self.original}", "wb") do |f|
          f.write(  File.read( @importfile ) )
          f.close
        end

        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/data/originals/#{self.original}")

        #resize to 400X300
        image.resize "x350"
        #now save it with a different name
        jpgname = "#{RAILS_ROOT}/public/data/images/#{self.filename}"
        image.write(jpgname)

        image.resize "x150"
        jpgname = "#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}"
        image.write(jpgname)
        
        #f.write( File.read(@tmp_file) )
#        import = Magick::Image.read(@import_file).first
        # import.write("#{RAILS_ROOT}/public/data/originals/#{self.filename}")

#        image = import.change_geometry!('x350') { |cols, rows, img|
#          img.resize!(cols, rows)
#        }
#        image.format = "JPG"
#        image.write("#{RAILS_ROOT}/public/data/images/#{self.filename}")
        
#        thumbnail = import.change_geometry!('x150') { |cols, rows, img|
#          img.resize!(cols, rows)
#        }
#        thumbnail.format = "JPG"
#        thumbnail.write("#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}")
      else
        File.open("#{RAILS_ROOT}/public/data/originals/#{self.original}", "wb") do |f|
          f.write( @tmp_file.read )
        end
        
        image = MiniMagick::Image.from_file("#{RAILS_ROOT}/public/data/originals/#{self.original}")

        #resize to 400X300
        image.resize "x350"
        #now save it with a different name
        jpgname = "#{RAILS_ROOT}/public/data/images/#{self.filename}"
        image.write(jpgname)

        image.resize "x150"
        jpgname = "#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}"
        image.write(jpgname)


#        original = Magick::Image.read("#{RAILS_ROOT}/public/data/originals/#{self.original}").first
#        image = original.change_geometry!('x350') { |cols, rows, img|
#          img.resize!(cols, rows)
#        }
#        image.format = "JPG"
#        image.write("#{RAILS_ROOT}/public/data/images/#{self.filename}")
#
#        thumbnail = original.change_geometry!('x150') { |cols, rows, img|
 #         img.resize!(cols, rows)
 #       }
  #      thumbnail.format = "JPG"
   #     thumbnail.write("#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}")
    end
  end
  
  def after_destroy
    if File.exists?("#{RAILS_ROOT}/public/data/images/#{self.filename}")
      File.delete("#{RAILS_ROOT}/public/data/images/#{self.filename}")
    end

    if File.exists?("#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}")
      File.delete("#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}")
    end

    if File.exists?("#{RAILS_ROOT}/public/data/originals/#{self.original}")
      File.delete("#{RAILS_ROOT}/public/data/originals/#{self.original}")
    end
    
    @blocks = BlockLink.find_all_by_mediablock_id(self.id)
    for block in @blocks
      block.destroy
    end
    
  end
  
private
  def base_part_of(filename)
    filename = File.basename(filename.strip)
    # remove leading period, whitespace and \ / : * ? " ' < > |
    filename = filename.gsub(%r{^\.|[\s/\\\*\:\?'"<>\|]}, '_')
  end
  
end
