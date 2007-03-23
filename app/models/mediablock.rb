class Mediablock < ActiveRecord::Base
  # image = name vom dateifeld im formular
  #validates_presence_of   :title,
  #                        :description
  has_and_belongs_to_many :block_links
  
  def file=(incoming_file)
    @tmp_file = incoming_file
    
    self.original_name = base_part_of(incoming_file.original_filename)
    self.content_type = incoming_file.content_type.chomp
    self.title = self.original_name
    manage_img self.original_name
  end

  def importfile=(incoming_file)
    @importflag = true
    @importfile = incoming_file
    generate_title = original_name.split('/')
    imported_file = generate_title.last
    self.title = imported_file
    manage_img original_name

  end
  
  def after_save
      path = "#{RAILS_ROOT}/public/data/originals/#{self.original}"
      if @importflag
        File.open(path, "wb") do |f|
          f.write( File.open(@importfile, "rb").read )
        end
        do_mini_magick path   
      else
        File.open(path, "wb") do |f|
          f.write( @tmp_file.read )
        end
        do_mini_magick path
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
  
  def manage_img(original_name)
    timestamp = Time.now
    tstmp = timestamp.to_i.to_s
    get_extension = original_name.split('.')
    file_extension = get_extension.last
    filetype = "jpg"
    self.original = "#{tstmp}.#{file_extension}"
    self.filename = "#{tstmp}.#{filetype}"
    self.thumbnail = "#{tstmp}.#{filetype}"
  end
  
  def do_mini_magick(path)
    image = MiniMagick::Image.from_file(path)
    image.resize "x350"
    jpgname = "#{RAILS_ROOT}/public/data/images/#{self.filename}"
    image.write(jpgname)
    image.resize "x150"
    jpgname = "#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}"
    image.write(jpgname)
  end
end
