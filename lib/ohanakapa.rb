module Ohanakapa
  class Client
    module RecommendedTags
      def recommended_tags
        get("recommended_tags")
      end
    end
    module Languages
      def languages
        get("languages")
      end
    end
  end
end

module Ohanakapa
  class Client
    include Ohanakapa::Client::RecommendedTags
    include Ohanakapa::Client::Languages
  end
end
