class CentralCache
  @logger = Rails.logger

  DEFAULT_TTL = 1.day.to_i

  class << self

    # Calculates time to live based on ttl parameter
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    # Params:
    # +ttl+:: ttl duration
    #
    # Returns ttl timestamp based on duration provided
    def get_ttl(ttl)
      ttl = ttl.to_i == 0 ? DEFAULT_TTL : ttl.to_i
    end

    # Writes a value to cache with provided key
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    # Params:
    # +key+:: key for cache object
    # +value+:: value for cache object
    #
    def write(key, value, ttl = 0)
      $central_cache.set(key, value)
      $central_cache.expire(key, get_ttl(ttl))
      true
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: write: K: #{key}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    alias_method :set, :write

    # Gets value from cache with provided key
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    # Params:
    # +key+:: key for cache object
    #
    # Return data if present else nil
    #
    def read(key)
      $central_cache.get(key)
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: read: K: #{key}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    alias_method :get, :read

    # Reads multiple keys from cache store
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    # Params:
    # +keys+:: array of keys to read
    #
    # Return data if present else nil
    #
    def read_multi(keys)
      $central_cache.mget(*keys)
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: read_multi: K: #{key}. M: #{exc.message}, I: #{exc.inspect}" }
      return {}
    end

    alias_method :get_multi, :read_multi

    # Gets value from cache with provided key if present, otherwise fetches data and stores in cache
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    # Params:
    # +key+:: key for cache object
    #
    # Return value for the provided key
    #
    def fetch(key, ttl = 0)
      if block_given?
        cached = read(key)

        if cached.present?
          cached
        else
          data_to_cache = yield
          write(key, data_to_cache, ttl)
          data_to_cache
        end
      else
        read(key)
      end
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: fetch: K: #{key.inspect}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    # Checks if the key exists in cache store
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    # Params:
    # +key+:: key to be checked
    # +options+:: additional options if required
    #
    # Return true if exists otherwise false
    #
    def exist?(key, options = nil)
      read(key).present?
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: exists?: K: #{keys.inspect}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end
    alias :exists? :exist?

    # Deletes a particular key from cache store
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    # Params:
    # +key+:: key to be deleted
    #
    def delete(key, options = nil)
      $central_cache.del(key)
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: delete: K: #{key.inspect}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    alias_method :delete_memcached, :delete

    # Clears the cache store
    #
    # Author:: Raj
    # Date:: 09/04/2018
    # Reviewed By::
    #
    def clear
      keys = $central_cache.keys '*'
      $central_cache.del keys if keys.present?
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: clear: M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

  end
end