module Krant
  module BasePagePatch
    def header(*args)
      insert_tag(Krant::Views::HeaderWithBroadcastMessages, *args)
    end
  end
end
