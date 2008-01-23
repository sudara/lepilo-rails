require 'fileutils'
# Install hook code here

public_dir = File.dirname(__FILE__) + "/../../../public"
plugin_dir = File.dirname(__FILE__) + "/public"

FileUtils.install(plugin_dir + "/javascripts/SWFUpload.js", public_dir + "/javascripts")
FileUtils.install(plugin_dir + "/javascripts/swfupload_callbacks.js", public_dir + "/javascripts")
FileUtils.install(plugin_dir + "/stylesheets/swfupload_theme.css", public_dir + "/stylesheets")
FileUtils.install(plugin_dir + "/images/progressbar.png", public_dir + "/images")
FileUtils.install(plugin_dir + "/images/delete.png", public_dir + "/images")

FileUtils.mkdir_p(public_dir + "/flash")
FileUtils.install(plugin_dir + "/flash/SWFUpload.swf", public_dir + "/flash")

