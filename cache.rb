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
  domain = "api-cache-#{locale}-#{platform}"
  FileCache.new(domain, root).extend(GetOrSet)
end