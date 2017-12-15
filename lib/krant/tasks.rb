require 'rake'

module Krant
  # Create database records for each new news item. Together with
  # the "last seen" timestamp of a user, the corresponding creation
  # timestamps will be used to determine seen/unseen state of each
  # news item.
  module Tasks
    extend Rake::DSL

    # Defines a news:persist task that persists news items to the
    # database.
    #
    # @param news [Krant::News] Collection to read items from.
    def self.install(&block)
      desc 'Persist news items'
      task 'news:persist' => 'environment' do
        news = block.call
        puts "Persisting news for #{news.scope}..."
        news.persist do |news_item|
          puts "- #{news_item.name}: #{news_item.title}"
        end
      end
    end
  end
end
