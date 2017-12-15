require 'rails_helper'

require 'support/timecop'

module Krant
  RSpec.describe News do
    describe '#all' do
      it 'allows accessing persisted items' do
        current_user = User.create!
        news = Krant::News.about('my_app')
        news.item(:some_news,
                  title: { en: 'Big news' },
                  text: { en: 'This is brand new' })

        news.persist
        items = news.all(for_user: current_user)

        expect(items.map(&:title)).to eql(['Big news'])
        expect(items.map(&:text)).to eql(['This is brand new'])
      end

      it 'marks items as unseen by default' do
        current_user = User.create!
        news = Krant::News.about('my_app')
        news.item(:some_news,
                  title: { en: 'Big news' },
                  text: { en: 'This is brand new' })

        news.persist
        item = news.all(for_user: current_user).first

        expect(item).to be_unseen
      end

      it 'marks items as seen that were pesisted before the last time the user saw news' do
        current_user = User.create!
        news = Krant::News.about('my_app')
        news.item(:some_news,
                  title: { en: 'Big news' },
                  text: { en: 'This is brand new' })

        news.persist
        news.seen_by!(current_user)
        item = news.all(for_user: current_user).first

        expect(item).to be_seen
      end

      it 'marks items as unseen that were persisted after the last time the user saw news' do
        current_user = User.create!
        news = Krant::News.about('my_app')
        news.item(:some_news,
                  title: { en: 'Big news' },
                  text: { en: 'This is brand new' })


        Timecop.freeze(2.days.ago) do
          news.seen_by!(current_user)
        end
        news.persist
        item = news.all(for_user: current_user).first

        expect(item).to be_unseen
      end

      it 'does not mix news items from different collections' do
        current_user = User.create!
        news_1 = Krant::News.about('library_1')
        news_2 = Krant::News.about('library_2')
        news_1.item(:some_news,
                    title: { en: 'First news' })
        news_2.item(:some_news,
                    title: { en: 'Other news' })

        news_1.persist
        news_2.persist

        expect(news_1.all(for_user: current_user).first.title).to eq('First news')
        expect(news_2.all(for_user: current_user).first.title).to eq('Other news')
      end

      it 'keeps separate timestamps for news with same name in different collections' do
        current_user = User.create!
        old_news = Krant::News.about('library_1')
        recent_news = Krant::News.about('library_2')

        old_news.item(:some_news,
                      title: { en: 'Old news' })
        recent_news.item(:some_news,
                         title: { en: 'Recent news' })

        recent_news.persist
        old_news.persist
        old_news.seen_by!(current_user)
        old_item = old_news.all(for_user: current_user).first
        recent_item = recent_news.all(for_user: current_user).first

        expect(old_item).to be_seen
        expect(recent_item).to be_unseen
      end

      it 'keeps last seen state per user' do
        current_user = User.create!
        other_user = User.create!
        news = Krant::News.about('library_1')
        news.item(:some_news,
                  title: { en: 'Some news' })

        news.persist
        news.seen_by!(current_user)

        expect(news.all(for_user: current_user).first).to be_seen
        expect(news.all(for_user: other_user).first).to be_unseen
      end

      it 'lists the newest items first' do
        news = Krant::News.about('my_app')
        current_user = User.create!

        Timecop.freeze(2.days.ago) do
          news.item(:some_news, title: { en: 'Old news' })
          news.persist
        end
        Timecop.freeze(1.day.ago) do
          news.item(:other_news, title: { en: 'Recent news' })
          news.persist
        end
        items = news.all(for_user: current_user)

        expect(items.map(&:title)).to eql(['Recent news', 'Old news'])
      end

      it 'calling persist multiple times does not create multiple database records' do
        news = Krant::News.about('my_app')

        news.item(:some_news, title: { en: 'Old news' })
        news.persist
        news.persist
        news.persist

        expect(NewsItem.count).to eq(1)
      end

      it 'registering the same icon multiple times does not create multiple database records' do
        news = Krant::News.about('my_app')

        news.item(:some_news, title: { en: 'Old news' })
        news.item(:some_news, title: { en: 'Old news' })
        news.item(:some_news, title: { en: 'Old news' })
        news.persist

        expect(NewsItem.count).to eq(1)
      end

      it 'ignores unknown persisted items' do
        current_user = User.create!
        news = Krant::News.about('my_app')
        news.item(:some_news, title: { en: 'Old news' })
        news.persist
        news = Krant::News.about('my_app')

        expect(news.all(for_user: current_user).map(&:title)).to eq([])
      end
    end

    describe '#unseen_items?' do
      it 'is true if there are items which have been persisted after last time user saw news' do
        current_user = User.create!
        news = Krant::News.about('my_app')

        Timecop.freeze(1.day.ago) do
          news.seen_by!(current_user)
        end
        news.item(:some_news, title: { en: 'Old news' })
        news.persist

        expect(news.unseen_items?(for_user: current_user)).to eq(true)
      end

      it 'is true if there are items and user never saw news' do
        current_user = User.create!
        news = Krant::News.about('my_app')

        news.item(:some_news, title: { en: 'Old news' })
        news.persist

        expect(news.unseen_items?(for_user: current_user)).to eq(true)
      end

      it 'is false if there all items have been persisted before the last time user saw news' do
        current_user = User.create!
        news = Krant::News.about('my_app')

        news.item(:some_news, title: { en: 'Old news' })
        news.persist
        news.seen_by!(current_user)

        expect(news.unseen_items?(for_user: current_user)).to eq(false)
      end

      it 'is false if there are no items even if user has never seen news' do
        current_user = User.create!
        news = Krant::News.about('my_app')

        expect(news.unseen_items?(for_user: current_user)).to eq(false)
      end
    end

    describe '#seen_by!' do
      it 'does not create multiple last seen state records on multiple calls' do
        current_user = User.create!
        news = Krant::News.about('my_app')

        news.seen_by!(current_user)
        news.seen_by!(current_user)
        news.seen_by!(current_user)

        expect(LastSeenState.count).to eq(1)
      end
    end

    describe '#persist' do
      it 'yields new news items' do
        news = Krant::News.about('my_app')
        news.item('some_feature', {})

        names = []
        news.persist do |item|
          names << item.name
        end

        expect(names).to eq(['some_feature'])
      end

      it 'yields allows accessing template attributes' do
        news = Krant::News.about('my_app')
        news.item('some_feature', title: { en: 'title' })

        titles = []
        news.persist do |item|
          titles << item.title
        end

        expect(titles).to eq(['title'])
      end

      it 'does not yield if item already persisted' do
        news = Krant::News.about('my_app')
        news.item('some_feature', {})

        news.persist

        expect { |probe| news.persist(&probe) }.not_to yield_control
      end
    end
  end
end
