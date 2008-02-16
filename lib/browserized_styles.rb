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
  
  def ie?
    browser_name[0..1] == "ie"
  end
  
  def browser_os
    @browser_od ||= begin
      ua = request.env['HTTP_USER_AGENT']
      return nil if ua.nil?
      ua.downcase!
      
      if ua.include?('mac os x') or ua.include?('mac_powerpc')
        'mac'
      elsif ua.include?('windows')
        'win'
      elsif ua.include?('linux')
        'linux'
      else
        nil
      end
    end
  end
  
  def stylesheet_link_tag_with_browserization(*sources)
    browserized_sources = Array.new
    sources.each do |source|
      subbed_source = source.to_s.gsub(".css","")
      
      possible_sources = ["#{subbed_source.to_s}_#{browser_name}", 
                          "#{subbed_source.to_s}_#{browser_os}", 
                          "#{subbed_source.to_s}_#{browser_name}_#{browser_os}"]
      
      possible_sources.unshift("#{subbed_source.to_s}_ie") if ie?
      
      browserized_sources << source
      
      for possible_source in possible_sources
        path = File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,"#{possible_source}.css")
        sass_path = File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,"sass","#{possible_source}.sass")
        browserized_sources << possible_source if File.exist?(path) || File.exist?(sass_path)
      end
    end
  
    stylesheet_link_tag_without_browserization(*browserized_sources)
  end
end