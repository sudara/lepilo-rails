# FileUpload

module ActionView
  module Helpers
    module ActiveUploadHelper
      def attachments_field(options = {})

        defaults = { :filesize => 30720, :filetypes => [ "*.*" ] }
        options = defaults.merge(options)

        html = ""
        attachment_ids = Array.new
        object.attachments.each do |attachment|
          attachment_ids << attachment.id
        end
        html << %(<div id="SWFUpload">                                               \n)
        if options[:add]
          html << %(<div id="SWFUploadTarget">                                       \n)
          html << %(</div>                                                           \n)
          html << %(<div id="SWFUploadMessage">                                      \n)
          html << %(</div>                                                           \n)
          html << %(<h4 id="queueinfo">The Queue is empty</h4>                       \n)
        end
        html << %(<div id="SWFUploadFileListingFiles">                               \n)
        html << %(  <input type="hidden" name="#{options[:name]}" id="_object_attachment_id" value="#{attachment_ids.join(',')}"/>\n)
        html << %(<ul>                                                               \n)
        if options[:edit]
          object.attachments.each do |attachment|
            html << %(<li class="SWFUploadFileItem uploadCompleted" id="attachment_#{attachment.id}">      \n)
            html << %(<a href="javascript:removeAttachment('_object_attachment_id', #{attachment.id}, 'attachment_#{attachment.id}')" class="cancelbtn"><img class="icon deleteFile" src="/images/delete.png" border="0" /></a> \n)
            html << %(<span class="fileName"><a href="/attachments/show/#{attachment.id}">#{attachment.to_label}</a></span> \n)
            html << %(</li>                                                         \n)
          end
        end
        html << %(</ul>                                                              \n)
        html << %(</div>                                                             \n)
        if options[:add]
          html << %(<script>                                                         \n)
          html << %(<!--                                                             \n)
          html << %(  if( MM_FlashCanPlay ) {                                        \n)

          html << %(  var swfu;                                                      \n)
          html << %(  var result;                                                    \n)
          html << %(  window.onload = function() {                                   \n)
          html <<  "    swfu = new SWFUpload({                                       \n"
          html << %(      upload_script : "/attachments/upload",                     \n)
          html << %(      target : "SWFUploadTarget",                                \n)
          html << %(      flash_path : "/flash/SWFUpload.swf",                       \n)
          html << %(      allowed_filesize : #{options[:filesize]},                  \n)
          html << %(      allowed_filetypes : "#{options[:filetypes].join(';')}",    \n)
          html << %(      allowed_filetypes_description : "All files...",            \n)
          html << %(      browse_link_innerhtml : "Browse",                          \n)
          html << %(      upload_link_innerhtml : "Upload queue",                    \n)
          html << %(      browse_link_class : "swfuploadbtn browsebtn",              \n)
          html << %(      upload_link_class : "swfuploadbtn uploadbtn",              \n)
          html << %(      flash_loaded_callback : 'swfu.flashLoaded',                \n)
          html << %(      upload_file_queued_callback : "fileQueued",                \n)
          html << %(      upload_file_start_callback : 'uploadFileStart',            \n)
          html << %(      upload_progress_callback : 'uploadProgress',               \n)
          html << %(      upload_file_complete_callback : 'uploadFileComplete',      \n)
          html << %(      upload_file_cancel_callback : 'uploadFileCancelled',       \n)
          html << %(      upload_queue_complete_callback : 'uploadQueueComplete',    \n)
          html << %(      upload_error_callback : 'uploadError',                     \n)
          html << %(      upload_cancel_callback : 'uploadCancel',                   \n)
          html << %(      auto_upload : true                                         \n)
          html <<  "    });                                                          \n"
          html << %(  };                                                             \n)

          html << %(  } else {                                                       \n)
          html << %(    alert('You must have flash installed to upload files.');     \n)
          html << %(  }                                                              \n)
          html << %(-->                                                              \n)
          html << %(</script>                                                        \n)
        end
        html << %(</div>                                                             \n)
        html
      end
    end

    module FormHelper
      def attachments_field(object_name, method, options = {})
        name = "#{object_name}[#{method}]"
        id = "#{object_name}_#{method}"
        options = options.merge( { :name => name, :id => id, :method => method, :object_name => object_name })
        InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_attachments_tag(options)
      end
    end

    class FormBuilder
      def attachments_field(method, options = {})
        @template.attachments_field(@object_name, method, options.merge(:object => @object))
      end
    end

    class InstanceTag #:nodoc
      include ActiveUploadHelper

      def to_attachments_tag(options = {})
        attachments_field options
      end
    end
  end
end

module ApplicationHelper
  def view_attachments_field(object, options = {})
    html  = %(<div class="attachments_container">                                       \n)
    object.attachments.each do |attachment|
      html << %(<div class="attachment">                                                \n)
      html << %(<a href="/attachments/show/#{attachment.id}">#{attachment.to_label}</a> \n)
      html << %(</div>                                                                  \n)
    end
    html << %(</div>                                                                    \n)
    html
  end
end
