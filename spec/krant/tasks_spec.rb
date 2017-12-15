require 'rails_helper'

module Krant
  RSpec.describe Tasks do
    before(:each) do
      Rake::Task.define_task('environment')
    end

    describe 'news:persit task' do
      it 'prints names of persisted news items' do
        news = News.about('my_app')
        news.item('some_feature', title: { en: 'Some feature' })

        Tasks.install { news }

        expect {
          Rake.application['news:persist'].invoke
        }.to output(/some_feature: Some feature/).to_stdout
      end
    end
  end
end
