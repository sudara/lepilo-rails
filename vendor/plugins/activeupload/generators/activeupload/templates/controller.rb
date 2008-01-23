require 'fileutils'

class AttachmentsController < ApplicationController
  def create
    @f = Attachment.new()
    if @f.save
      render :text => "#{@f.id}"
    end
  end

  def upload
    @f = Attachment.find(params[:id])
    @f.filename = params[:Filename]
    @f.size = params[:Filedata].size

    if @f.save
      dirname = @f.dirname
      FileUtils.mkdir_p(dirname)
      file = File.new(@f.path, "wb")
      file.write(params[:Filedata].read)
      file.close
      render :text => "#{@f.id}"
    end
  end

  def show
    attachment = Attachment.find(params[:id])
    send_file attachment.path
  end
end

