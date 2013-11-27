module NavLinkHelper

  def nav_link_to(*args, &block)
    title = block_given? ? capture(&block) : args.shift
    url_options  = args[0]
    html_options = args[1] || {}
    options      = args[2] || {}

    LinkGenerator.new(request, title, url_options, controller,html_options, options).to_html
  end

  class LinkGenerator
    include ActionView::Helpers::UrlHelper
    include Rails.application.routes.url_helpers

    attr_reader :controller

    def initialize(request, title, url_options, controller, html_options = {}, options = {})
      @request      = request
      @title        = title
      @url_options  = url_options
      @html_options = html_options
      @options      = options
      @controller   = controller
    end

    def to_html
      html = link

      if @options[:wrapper]
        html = content_tag(@options[:wrapper], html, :class => wrapper_classes)
      end

      html.html_safe
    end

    private

    def link
      link_to(@title, @url_options, html_options)
    end

    def html_options
      selected? ? @html_options.merge(:class => link_classes) : @html_options
    end

    def selected?
      paths_match? || segments_match?
    end

    def paths_match?
      current_path == link_path
    end

    def current_path
      comparable_path_for(@request.fullpath)
    end

    def link_path
      path = url_for(@url_options)
      comparable_path_for(path)
    end

    def comparable_path_for(path)
      if @options[:ignore_params]
        path.gsub(/\?.*/, '')
      else
        path
      end
    end

    def segments_match?
      path_segment && path_segment == current_segment
    end

    def path_segment
      segment_for(path_controller, current_path)
    end

    def segment_for(controller, path)
      if @options[:controller_segment]
        controller.split('/')[segment_position]
      elsif @options[:url_segment]
        path.split('/')[segment_position]
      end
    end

    def path_controller
      if @url_options.is_a?(Hash) && @url_options[:controller]
        @url_options[:controller]
      else
        controller_for(url_for(@url_options))
      end
    end

    def segment_position
      if @options[:controller_segment]
        @options[:controller_segment] - 1
      elsif @options[:url_segment]
        @options[:url_segment]
      end
    end

    def controller_for(path)
      Rails.application.routes.recognize_path(path)[:controller]
    rescue ActionController::RoutingError
      nil
    end

    def current_segment
      segment_for(current_controller, link_path)
    end

    def current_controller
      controller_for(@request.path)
    end

    def link_classes
      if @html_options[:class]
        @html_options[:class] + " #{selected_class}"
      elsif !@options[:wrapper]
        selected_class
      end
    end

    def selected_class
      @options[:selected_class] || 'selected'
    end

    def wrapper_classes
      if selected?
        "#{selected_class} #{@options[:wrapper_class]}"
      else
        @options[:wrapper_class]
      end
    end
  end

end
