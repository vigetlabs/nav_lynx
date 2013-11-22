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
      NavLinkHelper::LinkGenerator.should_receive(:new).with(:request, "My Title", "/path", {}, {})
        .and_return(link_generator)

      helper.nav_link_to("My Title", "/path")
    end

    it 'accepts a block that returns the title' do
      NavLinkHelper::LinkGenerator.should_receive(:new).with(:request, "My Title", "/path", {}, {})
        .and_return(link_generator)

      helper.nav_link_to("/path") do
        "My Title"
      end
    end

    it "accepts options and html_options parameters" do
      NavLinkHelper::LinkGenerator.should_receive(:new).with(:request, "My Title", "/path", :html_options, :options)
        .and_return(link_generator)

      helper.nav_link_to("My Title", "/path", :html_options, :options)
    end
  end

  require 'spec_helper'

  describe NavLinkHelper::LinkGenerator do
    describe '#to_html' do
      subject { described_class::LinkGenerator }
      let(:request){ helper.request }

      it "outputs a simple link when appropriate" do
        subject.new(request, 'Hi', '/projects').to_html.should == '<a href="/projects">Hi</a>'
      end

      it "knows when to flag the link as current" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects').to_html.should == '<a href="/projects" class="selected">Hi</a>'
      end

      it "flags the link as current if the request method is POST instead of the default (GET)" do
        request.stub(:fullpath => '/projects', :method => "POST")
        subject.new(request, 'Hi', '/projects').to_html.should == '<a href="/projects" class="selected">Hi</a>'
      end

      it "does not flag the link as current if there are parameters in the path" do
        request.stub(:fullpath).and_return('/projects?all=true')
        subject.new(request, 'Hi', '/projects').to_html.should == '<a href="/projects">Hi</a>'
      end

      it "flags the link as selected if there are parameters in the path but we are ignoring parameters" do
        request.stub(:fullpath).and_return('/projects?all=true')
        subject.new(request, 'Hi', '/projects', {}, :ignore_params => true).to_html
          .should == '<a href="/projects" class="selected">Hi</a>'
      end

      it "allows the specification of an alternate selected class" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects', {}, :selected_class => 'current').to_html
          .should == '<a href="/projects" class="current">Hi</a>'
      end

      it "generates a wrapper for the link when specified" do
        subject.new(request, 'Hi', '/projects', {}, :wrapper => 'li').to_html
          .should == '<li><a href="/projects">Hi</a></li>'
      end

      it "provides a class for the wrapper when specified" do
        subject.new(request, 'Hi', '/projects', {}, :wrapper => 'li', :wrapper_class => 'container').to_html
          .should == '<li class="container"><a href="/projects">Hi</a></li>'
      end

      it "provides a class for the wrapper when specified along with a selected class if needed" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects', {}, :wrapper => 'li', :wrapper_class => 'container').to_html
          .should == '<li class="selected container"><a href="/projects">Hi</a></li>'
      end

      it "allows specification of the link classes" do
        subject.new(request, 'Hi', '/projects', :class => 'one two').to_html
          .should == '<a href="/projects" class="one two">Hi</a>'
      end

      it "combines custom link classes when the link is selected" do
        request.stub(:fullpath).and_return('/projects')
        subject.new(request, 'Hi', '/projects', :class => 'one two').to_html
          .should == '<a href="/projects" class="one two selected">Hi</a>'
      end

      it "ignores the ID in the path when provided with a segment" do
        request.stub(:fullpath).and_return('/projects/2')
        subject.new(request, 'Hi', '/projects', {}, :url_segment => 1).to_html
          .should == '<a href="/projects" class="selected">Hi</a>'
      end

      it "handles deep URL segments" do
        request.stub(:fullpath).and_return('/projects/2/3')
        subject.new(request, 'Hi', '/projects/2', {}, :url_segment => 2).to_html
          .should == '<a href="/projects/2" class="selected">Hi</a>'
      end

      it "knows to not match on the first segment when requested" do
        request.stub(:fullpath).and_return('/projects/2/3')
        subject.new(request, 'Hi', '/projects/1', {}, :url_segment => 2).to_html
          .should == '<a href="/projects/1">Hi</a>'
      end

      it "handles matching on the controller segment" do
        Rails.application.routes.stub(:recognize_path).with('/members/1').and_return(:controller => 'members')
        Rails.application.routes.stub(:recognize_path).with('/members/pages/1').and_return(:controller => 'members')

        request.stub(:fullpath).and_return('/members/pages/1')
        request.stub(:path).and_return('/members/pages/1')

        subject.new(request, 'Hi', '/members/1', {}, :controller_segment => 1).to_html
          .should == '<a href="/members/1" class="selected">Hi</a>'
      end
    end
  end
end

