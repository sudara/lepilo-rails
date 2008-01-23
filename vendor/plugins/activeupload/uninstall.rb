require 'fileutils'
# Uninstall hook code here

public_dir = File.dirname(__FILE__) + "/../../../public"

FileUtils.rm(public_dir + "/javascripts/SWFUpload.js")
FileUtils.rm(public_dir + "/javascripts/swfupload_callbacks.js")
FileUtils.rm(public_dir + "/stylesheets/swfupload_theme.css")
FileUtils.rm(public_dir + "/images/progressbar.png")

FileUtils.rm(public_dir + "/flash/SWFUpload.swf")
if Dir.entries(public_dir + "/flash").empty?
	FileUtils.rmdir(public_dir + "/flash")
end
