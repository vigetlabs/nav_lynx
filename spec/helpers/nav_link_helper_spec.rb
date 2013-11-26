require 'spec_helper'

describe NavLinkHelper do
  describe '#nav_link' do
    let(:link_generator) do
      lg = double("LinkGenerator")
      lg.stub(:to_html => true)
      lg
    end

    before { helper.stub(:request => :request) }

    it 'accepts only a title and a path' do
      NavLinkHelper::LinkGenerator.should_receive(:new).with(:request, "My Title", "/path", {}, {}, controller)
        .and_return(link_generator)

      helper.nav_link_to("My Title", "/path")
    end

    it 'accepts a block that returns the title' do
      NavLinkHelper::LinkGenerator.should_receive(:new).with(:request, "My Title", "/path", {}, {}, controller)
        .and_return(link_generator)

      helper.nav_link_to("/path") do
        "My Title"
      end
    end

    it "accepts options and html_options parameters" do
      NavLinkHelper::LinkGenerator.should_receive(:new).with(:request, "My Title", "/path", :html_options, :options, controller)
        .and_return(link_generator)

      helper.nav_link_to("My Title", "/path", :html_options, :options)
    end
  end

  describe NavLinkHelper::LinkGenerator do
    describe '#to_html' do
      subject { described_class::LinkGenerator }
      let(:request){ helper.request }

      it "outputs a simple link when appropriate" do
        subject.new(request, 'Hi', '/projects', {}, {}, controller).to_html.should == '<a href="/projects">Hi</a>'
      end

      it "accepts a hash for the URL parameter" do
        subject.new(request, 'Hi', {:controller => 'projects', :action => 'index'}, {}, {}, controller).to_html.should == '<a href="/projects">Hi</a>'
      end

      it "knows when to flag the link as current" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects', {}, {}, controller).to_html.should have_tag("a.selected[href='/projects']", :text => "Hi")
      end

      it "does not flag the link as current if there are parameters in the path" do
        request.stub(:fullpath).and_return('/projects?all=true')
        subject.new(request, 'Hi', '/projects', {}, {}, controller).to_html.should == '<a href="/projects">Hi</a>'
      end

      it "flags the link as selected if there are parameters in the path but we are ignoring parameters" do
        request.stub(:fullpath).and_return('/projects?all=true')
        subject.new(request, 'Hi', '/projects', {}, {:ignore_params => true}, controller).to_html
          .should have_tag("a.selected[href='/projects']", :text => "Hi")
      end

      it "allows the specification of an alternate selected class" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects', {}, {:selected_class => 'current'}, controller).to_html
          .should have_tag("a.current[href='/projects']", :text => "Hi")
      end

      it "generates a wrapper for the link when specified" do
        subject.new(request, 'Hi', '/projects', {}, {:wrapper => 'li'}, controller).to_html
          .should == '<li><a href="/projects">Hi</a></li>'
      end

      it "provides a class for the wrapper when specified" do
        subject.new(request, 'Hi', '/projects', {}, {:wrapper => 'li', :wrapper_class => 'container'}, controller).to_html
          .should == '<li class="container"><a href="/projects">Hi</a></li>'
      end

      it "provides a class for the wrapper when specified along with a selected class if neeeded" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects', {}, {:wrapper => 'li', :wrapper_class => 'container'}, controller).to_html
          .should == '<li class="selected container"><a href="/projects">Hi</a></li>'
      end

      it "allows specification of the link classes" do
        subject.new(request, 'Hi', '/projects', {:class => 'one two'}, {}, controller).to_html
          .should have_tag("a.one.two[href='/projects']", :text => "Hi")
      end

      it "combines custom link classes when the link is selected" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects', {:class => 'one two'}, {}, controller).to_html
          .should have_tag("a.selected.one.two[href='/projects']", :text => "Hi")
      end

      it "ignores the ID in the path when provided with a segment" do
        request.stub(:fullpath).and_return('/projects/2')
        subject.new(request, 'Hi', '/projects', {}, {:url_segment => 1}, controller).to_html
          .should have_tag("a.selected[href='/projects']", :text => "Hi")
      end

      it "handles deep URL segments" do
        request.stub(:fullpath).and_return('/projects/2/3')
        subject.new(request, 'Hi', '/projects/2', {}, {:url_segment => 2}, controller).to_html
          .should have_tag("a.selected[href='/projects/2']", :text => "Hi")
      end

      it "knows to not match on the first segment when requested" do
        request.stub(:fullpath).and_return('/projects/2/3')
        subject.new(request, 'Hi', '/projects/1', {}, {:url_segment => 2}, controller).to_html
          .should == '<a href="/projects/1">Hi</a>'
      end

      it "handles matching on the controller segment" do
        Rails.application.routes.stub(:recognize_path).with('/members/1').and_return(:controller => 'members')
        Rails.application.routes.stub(:recognize_path).with('/members/pages/1').and_return(:controller => 'members')

        request.stub(:fullpath).and_return('/members/pages/1')
        request.stub(:path).and_return('/members/pages/1')

        subject.new(request, 'Hi', '/members/1', {}, {:controller_segment => 1}, controller).to_html
          .should have_tag("a.selected[href='/members/1']", :text => "Hi")
      end

      it "handles the case when the current request path is a POST route & has no GET route" do
        # scenario where a route exists only for POST, so GET fails
        Rails.application.routes.stub(:recognize_path).with('/projects/something').and_raise(ActionController::RoutingError.new("No route matches '/projects'"))
        Rails.application.routes.stub(:recognize_path).with('/projects').and_return(:controller => 'projects', :action => 'index')

        request.stub(:fullpath => '/projects/something', :path => '/projects/something')
        subject.new(request, 'Hi', '/projects', {}, {}, controller).to_html.should == '<a href="/projects">Hi</a>'
      end
    end
  end
end

