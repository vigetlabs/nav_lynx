# NavLYNX

[![Code Climate](https://codeclimate.com/github/vigetlabs/nav_lynx.png)](https://codeclimate.com/github/vigetlabs/nav_lynx)

The nav_link_to helper works just like the standard Rails link_to helper, but adds a 'selected' class to your link (or its wrapper) if certain criteria are met. By default, if the link's destination url is the same url as the url of the current page, a default class of 'selected' is added to the link.

    <%= nav_link_to 'My Page', my_path %>

When `my_path` is the same as the current page url, this outputs:

    <a class="selected" href="http://example.com/page">My Page</a>

For more options and full usage details, see: http://viget.com/extend/rails-selected-nav-link-helper

### Usage with blocks:

Same usage as `link_to`:

    <%= nav_link_to 'http://example.com/page' do %>
      <strong>My Page</strong>
    <% end %>

## Install

1. Add this to your Gemfile and then `bundle install`:
  <pre><code>gem 'nav_lynx'</code></pre>
2. Use `nav_link_to` helper in your views.

## Config option

There is one config option `selected_class`. If you want a different class then "selected" for selected nav items globally you can use this option to change that. You can set this inside your configuration in `config/application.rb` of your Rails application like so:

    module MyApplication
      class Application < Rails::Application
        # ...
        
        config.nav_lynx.selected_class = 'current'
      end
    end

## Contributing to NavLYNX
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Viget. See MIT_LICENSE for further details.
