module Slugifiable
  module ClassMethods
    def find_by_slug(slug)
      self.all.find {|s| s.slug == slug}
    end
  end

  module InstanceMethods
    def slug
      @slug ||= self.name.gsub(" ", "-").downcase
    end
  end
end
