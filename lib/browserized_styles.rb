module BrowserizedStyles
  # This method was taken from Richard Livsey's browser_detect plugin
  # http://svn.livsey.org/plugins/browser_detect/
  def browser_is? name
    
    name = name.to_s.strip
    
    return true if browser_name == name
    return true if name == 'mozilla' && browser_name == 'gecko'
    return true if name == 'ie' && browser_name.index('ie')
    return true if name == 'webkit' && browser_name == 'safari'
  
  end

  # This method was taken from Richard Livsey's browser_detect plugin
  # with small nil-catching modification
  # http://svn.livsey.org/plugins/browser_detect/
  def browser_name
    @browser_name ||= begin

      ua = request.env['HTTP_USER_AGENT']
      return nil if ua.nil?
      ua.downcase!
      
      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        'ie'+ua[ua.index('msie')+5].chr
      elsif ua.index('gecko/') 
        'gecko'
      elsif ua.index('opera')
        'opera'
      elsif ua.index('konqueror') 
        'konqueror'
      elsif ua.index('applewebkit/')
        'safari'
      elsif ua.index('mozilla/')
        'gecko'
      end
    
    end
  end
  
  def stylesheet_link_tag_with_browserization(*sources)
    browserized_sources = Array.new
    sources.each do |source|
      subbed_source = source.to_s.gsub(".css","")
      browserized_source = "#{subbed_source.to_s}_#{browser_name}"
      path = File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,"#{browserized_source}.css")
      browserized_sources << source
      browserized_sources << browserized_source
    end
  
    stylesheet_link_tag_without_browserization(*browserized_sources)
  end
end