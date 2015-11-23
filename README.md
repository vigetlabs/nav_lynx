# NavLYNX

[![Code Climate](https://codeclimate.com/github/vigetlabs/nav_lynx.png)](https://codeclimate.com/github/vigetlabs/nav_lynx) [![Build Status](https://travis-ci.org/vigetlabs/nav_lynx.png?branch=master)](https://travis-ci.org/vigetlabs/nav_lynx) [![Coverage Status](https://coveralls.io/repos/vigetlabs/nav_lynx/badge.png?branch=master)](https://coveralls.io/r/vigetlabs/nav_lynx?branch=master) [![Gem Version](https://badge.fury.io/rb/nav_lynx.png)](http://badge.fury.io/rb/nav_lynx)

NavLYNX provides a `nav_link_to` helper that works just like the standard Rails `link_to` helper, but adds a `selected` class to your link (or its wrapper) if certain criteria are met. By default, if the link's destination url is the same url as the url of the current page, a default class of 'selected' is added to the link.

```erb
<%= nav_link_to 'My Page', my_path %>
```

When `my_path` is the same as the current page url, this outputs:

```html
<a class="selected" href="/page">My Page</a>
```
Currenty NavLYNX only supports `_path` URL helpers, full `_url`'s will not match the current link correctly.

### Usage with blocks:

Same usage as `link_to`:

```erb
<%= nav_link_to 'http://example.com/page' do %>
  <strong>My Page</strong>
<% end %>
```
### Usage with options

```erb
  <%= nav_link_to my_path, html_options, nav_lynx_options %>
```

## Install

1. Add this to your Gemfile:
  <pre><code>gem 'nav_lynx'</code></pre>
2. `bundle install`
3. Use `nav_link_to` helper in your views.

## Config option

There is one config option `selected_class`. If you want a different class then "selected" for selected nav items globally you can use this option to change that. You can set this inside your configuration in `config/application.rb` of your Rails application like so:

```rb
module MyApplication
  class Application < Rails::Application
    # ...

    config.nav_lynx.selected_class = 'current'
  end
end
```

## Inline options
### :selected_class
Overrides the default class of ‘selected’ as the class to be added to your selected nav on a per-link basis.


```erb
<%= nav_link_to 'Page', my_path, {}, {:selected_class => 'customClassName'} %>
```
*Default Value:* `selected`

### :ignore_params
Set this to true if you want the helper to ignore query strings in the url when comparing. The urls `http://example.com/` and `http://example.com/?foo=bar` will be treated as equal.

```erb
<%= nav_link_to 'Page', my_path, {}, {:ignore_params => 'true'} %>
```
*Default Value:* `false`

### :url_segment

Instead of comparing full urls, you can check only segments of the urls. In the path `/news/article`, `news` is segment 1, `article` is segment 2. This is especially useful for category navigation. Assign an index identifying the url segment you wish to match. For example, if a page’s or link’s url is `example.com/news/story`, and you specify `:url_segment => 1`, the helper will look to match `/news/*`.

```erb
<%= nav_link_to 'Page', my_path, {}, {:url_segment => 1} %>
```
*Default Value:* `false`

### :controller_segment

Like `:url_segment`, but compares controllers instead. For example, if your controller is `members/pages`, and you specify `:controller_segment => 1`, the helper will treat any page with `members` as the first segment of the controller as a match.

```erb
<%= nav_link_to 'Page', my_path, {}, {:controller_segment => 1} %>
```
*Default Value:* `false`

### :wrapper

Often times you don’t want your `selected` class directly on the anchor tag. You can wrap your anchor tag in another element with `:wrapper => 'li'` (or any other html element). The `selected` class will be added to this wrapper instead of the anchor. Any `html_options` will still be added directly to the anchor tag.

```erb
<%= nav_link_to 'Page', my_path, {}, {:wrapper => 'li'} %>
```

*Default Value:* `false`

### :wrapper_class
If you want to specify additional classes for your wrapper (whether it is selected or not), you can add them with `:wrapper_class => 'class-name class-name-2'`.

```erb
<%= nav_link_to 'Page', my_path, {}, {:wrapper_class => 'nav-item'} %>
```
*Default Value:* `false`

## Contributing to NavLYNX

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright
Copyright (c) 2014 Viget. See MIT_LICENSE for further details.
Born on Aug 8, 2012 in this [blog post](http://viget.com/extend/rails-selected-nav-link-helper).
