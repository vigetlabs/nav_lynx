## Behold, the nav_lynx:

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
