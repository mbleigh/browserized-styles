require 'browserized_styles'

ActionView::Base.send(:include, BrowserizedStyles)
ActionView::Base.send(:alias_method_chain, :stylesheet_link_tag, :browserization)