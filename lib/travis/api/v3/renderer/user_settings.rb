module Travis::API::V3
  class Renderer::UserSettings < CollectionRenderer
    type           :settings
    collection_key :settings

    def render
      super.tap do |result|
        result[:settings].select!(&method(:allow?))
      end
    end

    def allow?(setting)
      return true unless setting[:name] == :allow_config_imports
      repo.private? && allow_config_imports?
    end

    def allow_config_imports?
      Features.owner_active?(:config_imports, repo.owner)
    end

    def repo
      @repo ||= Repository.find(list.repository_id)
    end
  end
end
