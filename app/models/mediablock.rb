class Mediablock < ActiveRecord::Base
  # image = name vom dateifeld im formular
  #validates_presence_of   :image, :on => :create
  #validates_presence_of   :title,
  #                        :description
  has_many :block_links, :order => :position, :as => :linked, :dependent => :destroy
  
  def resize
    @format
  end
  
  def resize=(format)
    @format = format
  end
  
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
    File.open(path, "wb") do |f|
      f.write( File.open(@importfile, "rb").read ) if @importflag
      f.write( @tmp_file.read ) unless @importflag
    end
    do_mini_magick path   
  end
  
  def after_destroy
    path = "#{RAILS_ROOT}/public/data/images/#{self.filename}"
    delete_img path
    path = "#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}"
    delete_img path
    path = "#{RAILS_ROOT}/public/data/originals/#{self.original}"
    delete_img path
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
    @image = MiniMagick::Image.from_file(path)
    if self.resize != "false"
      @image.resize self.resize
    end
    @image.format "jpg"
    jpgname = "#{RAILS_ROOT}/public/data/images/#{self.filename}"
    @image.write(jpgname)
    @image.resize "x150"
    @image.format "jpg"
    jpgname = "#{RAILS_ROOT}/public/data/thumbnails/#{self.thumbnail}"
    @image.write(jpgname)
  end
  
  def delete_img(path)
    if File.exists?(path)
      File.delete(path)
    end 
  end
end
