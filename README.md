# Krant

Display app news and broadcast messages in Active Admin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'krant'
```

And then execute:

    $ bundle

Include javascripts and stylesheets:

    # app/assets/stylesheets/active_admin.scss

    // After active_admin/base has been imported
    @import "krant/active_admin";

Install migrations and migrate:

    $ bin/rake krant:install:migrations
    $ bin/rake db:migrate

### Display Broadcast Messages

Configure the Active Admin view component and add the broadcast
messages admin to the load path:

    # config/initializers/active_admin.rb
    ActiveAdmin.application.load_paths.unshift(Krant.active_admin_load_path)

    ActiveAdmin.setup do |config|
      config.view_factory.header = Krant::Views::HeaderWithBroadcastMessages
    end

Configure for which locales you want to enter broadcast message
translations. The corresponding text fields will be displayed:

    # config/initializers/krant.rb
    Krant.broadcast_message_locales = [:en, :fr, :es]

Messages with different translations can now be configured via the
admin interface and will be displayed once marked as active.

The color of the broadcast message bar can be configured via SCSS

    # app/assets/stylesheets/active_admin.scss

    $krant-broadcast-message-bar-color: #fff3bd;
    $krant-broadcast-message-bar-border-color: transparent;

    @import "krant/active_admin";

### Displaying a News Page

Provide a news collection:

    # lib/my_app.rb
    module MyApp
      def self.news
        @news ||= Krant::News.about(MyApp)
      end
    end

The passed parameter is only used as a namespace for item names. You
can also pass a string. Passing a constant is an easy way to ensure
uniqness.

Add a news page:

    # app/admins/news.rb
    ActiveAdmin.register_page 'news' do
      Krant.active_admin_news_page(self)

      content title: 'News' do
        krant_news_list(MyApp.news)
      end
    end

If you are using the CanCan authorization adapter, grant access to the
page and its `seen` action:

    # app/models/ability.rb
    can [:read, :seen], ActiveAdmin::Page, name: 'news'

Add a link to the news page into the utility navigation:

    config.namespace :admin do |admin|
      admin.build_menu :utility_navigation do |menu|
        Krant.add_active_admin_news_menu_item_to(menu,
                                                 news: MyApp.news,
                                                 url: -> { admin_news_path })
      end
    end

Create news items for new features:

    # config/initializers/news/some_new_feature.rb
    MyApp.news.item(:some_new_feature,
                     title: {
                       en: 'Some title',
                       de: 'Ein Titel'
                     },
                     body: {
                       en: 'Some text using [Markdown](http://http://commonmark.org/).',
                       de: 'Text mit [Markdown](http://http://commonmark.org/).',
                     })

Define a Rake tasks to persists news items in the database:

    # Rakefile
    require 'krant/tasks'
    Krant::Trasks.install { MyApp.news }

and run the defined task after each deploy:

    $ bin/rake news:persist

## Development

After checking out the repo, run `bin/setup` to install
dependencies. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To run the tests install bundled gems and invoke RSpec:

```
$ bundle
$ bundle exec rspec
```

The test suite can be run against different versions of Rails and
Active Admin (see `Appraisals` file):

```
$ appraisal install
$ appraisal rspec
```

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/codevise/krant. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected
to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
