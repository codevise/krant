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

    # app/assets/javascripts/active_admin.js
    //= require krant/active_admin

    # app/assets/stylesheets/active_admin.scss
    @import "krant/active_admin";

Install migrations and migrate:

    $ bin/rake krant:install:migrations
    $ bin/rake db:migrate

## Usage

### Display Broadcast Messages

Configure the Active Admin view component and add the broadcast
messages admin to the load path:

    # config/initializers/active_admin.rb
    ActiveAdmin.application.load_paths.unshift(Krant::ActiveAdmin.load_path)

    ActiveAdmin.setup do |config|
      config.view_factory.title_bar = Krant::ActiveAdmin.append_broadcast_messages(ActiveAdmin::TitleBar)
    end

### Displaying a News Page

Provide a news collection:

    # lib/my_library.rb
    module MyLibrary
      def self.news
        @news ||= Krant.news_for(:my_library)
      end
    end

Add a news page:

    # app/admins/news.rb
    ActiveAdmin.register_page 'News' do
      menu priority: 100, label: 'News'

      content title: 'News' do
        krant_news(MyLibrary.news)
      end
    end

Create news items for new features:

    # config/initializers/news/some_new_feature.rb
    MyLibrary.news.item(:some_new_feature,
                        title: {
                          en: '',
                          de: ''
                        },
                        body: {
                          en: '',
                          de: ''
                        },
                        link: {
                          en: '',
                          de: ''
                        })

After deploy invoke the rake task to store news items in the database:

    $ bin/rake krant:news:update

## Development

After checking out the repo, run `bin/setup` to install
dependencies. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

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
