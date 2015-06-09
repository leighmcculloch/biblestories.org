module GetOrSet
  def get_or_set(key)
    value = self.get(key)
    return value if value
    value = yield
    self.set(key, value)
    value
  end
end

def get_cache(locale, platform)
  root = "caches"
  domain =
    case locale
    when :en, :es, :"zh-Hans"
      "api-cache"
    else
      "api-cache-#{locale}-#{platform}"
    end
  FileCache.new(domain, root).extend(GetOrSet)
end