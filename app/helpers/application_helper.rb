  # Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def render_tabs(tabs)
    tabs.collect { |tab| link_to((image_tag(tab.first)), tab.last, ({:class => 'active'} if current_page?(tab.last))) }
  end
  
  def shorten (string, count = 30)
  	if string.length >= count 
  		shortened = string[0, count]
  		splitted = shortened.split(/\s/)
  		words = splitted.length
  		splitted[0, words-1].join(" ") + '...'
  	else 
  		string
  	end
  end
  
  def list_for(record, *args, &block)
    raise ArgumentError unless (record.children || record.is_a?(Array)) || !block_given?
    prefix  = args.first.is_a?(Hash) ? nil : args.shift
    options = args.last.is_a?(Hash) ? args.pop.symbolize_keys! : {}
    
    # That works...
    # concat li_block.call(Topic.root), li_block.binding
    output = ""

    for li in (record.is_a?(Array) ? record : record.children)
      output += content_tag(:li, (capture block.call li),
        options.merge({ :class => "#{dom_class(li)} #{options[:class]}".strip, :id => dom_id(li, prefix) }))
    end
     
    
    # generate the ul 
    #concat content_tag_for(:ul, root_of_tree, *args, &new)
    concat output, block.binding
  end
  
 # def lis_for(ul_record, options, &block)
 #  newblock = ul_record.children.collect do |item|
 #    next if item.parent && options[:recursive]
 #    yield item
 #  end
 # end
 # 
 # def li_for(li, args, &block)
 #   li_content = capture block.call(li)
 #  # concat content_tag_for :li, li, args, &lambda{ li_content}
 # end
end


#  root_of_tree.collect do |item|
#    next if item.parent && options[:recursive]
#      concat content_tag_for(:li, item, &block) block.binding
#      #concat(sexy_ul_for(item.children, false, &block), block.binding) if item.children.size > 0
#  end
#  item), block.binding
#end