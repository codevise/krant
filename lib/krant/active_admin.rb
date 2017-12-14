module Krant
  # Integration for Active Admin
  module ActiveAdmin
    def self.load_path
      Krant::Engine.root.join('admin')
    end
  end
end
