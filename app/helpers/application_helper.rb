  # Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def render_tabs(tabs)
    tabs.collect { |tab| link_to((image_tag(tab.first)), tab.last, ({:class => 'active'} if current_page?(tab.last))) }
  end
  
end