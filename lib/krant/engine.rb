require 'active_admin'
require 'kramdown'
require 'redcarpet'
require 'redcarpet/render_strip'

module Krant
  # Rails integration
  # @api private
  class Engine < ::Rails::Engine
    isolate_namespace Krant

    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end
  end
end
