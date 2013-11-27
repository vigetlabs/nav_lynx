module NavLYNX
  class Engine < ::Rails::Engine
    config.nav_lynx = ActiveSupport::OrderedOptions.new

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
    end

    initializer "redirector.apply_options" do |app|
      NavLYNX.selected_class = app.config.nav_lynx.selected_class || 'selected'
    end
  end
end
