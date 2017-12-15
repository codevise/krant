module Krant
  # A collection of news items
  class News
    # Create a news collection for the given scope.
    #
    # @param scope [Module|Class|String] Used to prevent naming
    # clashes between different news collections, when news item are
    # persited to the database.
    def self.about(scope)
      new(scope: scope.to_s)
    end

    # @api private
    def initialize(scope:)
      @templates = {}
      @scope = scope
    end

    # Define a new item that will be stored in the database on next
    # `persist` call. Usually called from an initializer, either in
    # the main application or a plugin gem.
    #
    # @param name [String] Unique name for the item. It is good
    #   practice to use the name of the library or plugin as a prefix
    #   and separate different parts of the name with dots. Especially
    #   when multiple plugin gems define news for a common scope, this
    #   prevents naming clashes.
    #
    # @param [Hash] options
    #
    # @option options [Hash] :title A hash with locales as keys and
    #   short titles that can displayed in a header as values.
    #
    # @option options [Hash] :text A hash with locales as keys and
    #   longer descriptions of the new feature as values. Use Markdown
    #   to format the text.
    #
    # @example Add a news item
    #   MyApp.news.item('some_plugin.social_share_links',
    #                   title: {
    #                     en: 'Social Share Links',
    #                     de: 'Teilen Links'
    #                   },
    #                   text: {
    #                     en: 'Now displays links to [Twitter](http://twitter.com).'
    #                     en: 'Zeigt nun Links zu [Twitter](http://twitter.com).'
    #                   })
    #
    def item(name, attributes)
      @templates[name.to_s] = attributes
    end

    # Create database records for each new news item. Together with
    # the "last seen" timestamp of a user, the corresponding creation
    # timestamps will be used to determine seen/unseen state of each
    # news item.
    def persist
      @templates.keys.each do |name|
        NewsItem.find_or_create_by(scope: @scope, name: name)
      end
    end

    # @api private
    def all(for_user:)
      last_seen_at = last_seen(for_user)

      persisted_items.order('created_at desc').select do |news_item|
        news_item.seen = last_seen_at && news_item.created_at <= last_seen_at
        news_item.template = @templates[news_item.name]
      end
    end

    # @api private
    def unseen_items?(for_user:)
      last_seen_at = last_seen(for_user)

      scope = persisted_items
      scope = scope.where('created_at > ?', last_seen_at) if last_seen_at
      scope.exists?
    end

    # @api private
    def seen_by!(user)
      LastSeenState.find_or_create_by(scope: @scope, user: user).touch
    end

    private

    def persisted_items
      NewsItem.where(scope: @scope)
    end

    def last_seen(user)
      LastSeenState.where(scope: @scope, user: user).first.try(:updated_at)
    end
  end
end
