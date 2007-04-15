# lib/upload.rb, the upload drb server
require 'rubygems'
require 'drb'
require 'gem_plugin'
GemPlugin::Manager.instance.load 'mongrel' => GemPlugin::INCLUDE
DRb.start_service 'druby://0.0.0.0:2999', Mongrel::UploadProgress.new
DRb.thread.join