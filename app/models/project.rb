class Project < Fume::Settable::Base
  yaml_provider Rails.root.join("config/settings.local.yml")
  ruby_provider Rails.root.join("config/settings.local.rb")

  yaml_provider Rails.root.join("config/settings.yml")
  ruby_provider Rails.root.join("config/settings.rb")

  class << self
    def method_missing(name, *args, &block)
      self.settings.send(name, *args, &block)
    end
  end
end