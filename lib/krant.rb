require 'krant/engine'
require 'krant/version'

# Global settings
module Krant
  # Determines for which locales text boxes should be displayed in the
  # broadcast message edit form.
  mattr_accessor :broadcast_message_locales
  self.broadcast_message_locales = [:en, :de]

  # Unshift to Active Admin load path.
  def self.active_admin_load_path
    Dir[Krant::Engine.root.join('admin')].first
  end
end
