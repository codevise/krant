module Krant
  # @api private
  class TranslatedBroadcastMessage
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def self.active
      Query.new.active
    end

    # @api private
    class Query
      def active
        scope = BroadcastMessage.active

        scope = with_translation(scope, 'current_locale', I18n.locale)
        scope = with_translation(scope, 'default_locale', I18n.default_locale)

        scope.map do |broadcast_message|
          TranslatedBroadcastMessage.new(broadcast_message.current_locale_text.presence ||
                                         broadcast_message.default_locale_text)
        end
      end

      private

      def with_translation(scope, name, locale)
        table_alias = "#{name}_translations"

        scope
          .select("#{table_alias}.text as #{name}_text")
          .joins(sanitize_sql(<<-SQL, locale))
            LEFT JOIN krant_broadcast_message_translations #{table_alias}
            ON #{table_alias}.broadcast_message_id = krant_broadcast_messages.id AND
               #{table_alias}.locale = ?
        SQL
      end

      def sanitize_sql(sql, interpolations)
        ActiveRecord::Base.send(:sanitize_sql_array, [sql, interpolations])
      end
    end
  end
end
