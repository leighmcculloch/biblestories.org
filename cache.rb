$cache = FileCache.new("api-cache", "caches")
module GetOrSet
  def get_or_set(key)
    value = self.get(key)
    return value if value
    value = yield
    self.set(key, value)
    value
  end
end
$cache.extend(GetOrSet)