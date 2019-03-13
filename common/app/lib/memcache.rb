class Memcache
  @logger = Rails.logger

  DEFAULT_TTL = 1.day.to_i

  class << self

    # Calculates time to live based on ttl parameter
    #
    # Author:: Raj
    # Date:: 01/06/2016
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
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +key+:: key for cache object
    # +value+:: value for cache object
    #
    def write(key, value, ttl = 0, marshaling = true)
      Rails.cache.write(key, value, {expires_in: get_ttl(ttl), raw: !marshaling})
      nil
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: write: K: #{key}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    alias_method :set, :write
    alias_method :set_memcached, :write

    # Adds a value to cache with provided key
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +key+:: key for cache object
    # +value+:: value for cache object
    #
    # Return true if added, otherwise false
    #
    def add(key, value, ttl = 0, marshaling = true)
      Rails.cache.write(key, value, {expires_in: get_ttl(ttl), raw: !marshaling, unless_exist: true})
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: add: K: #{key}. M: #{exc.message}, I: #{exc.inspect}" }
      false
    end

    alias_method :add_memcached, :add

    # Gets value from cache with provided key
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +key+:: key for cache object
    #
    # Return data if present else nil
    #
    def read(key, _marshaling = true)
      Rails.cache.read(key)
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: read: K: #{key}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    alias_method :get, :read
    alias_method :get_memcached, :read

    # Reads multiple keys from cache store
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +keys+:: array of keys to read
    #
    # Return data if present else nil
    #
    def read_multi(keys, _marshaling = true)
      Rails.cache.read_multi(*keys)
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: read_multi: K: #{key}. M: #{exc.message}, I: #{exc.inspect}" }
      return {}
    end

    alias_method :get_multi, :read_multi
    alias_method :get_multi_memcached, :read_multi

    # Gets value from cache with provided key if present, otherwise fetches data and stores in cache
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +key+:: key for cache object
    #
    # Return value for the provided key
    #
    def fetch(key, ttl = 0, marshaling = true)
      if block_given?
        Rails.cache.fetch(key, {expires_in: get_ttl(ttl), raw: !marshaling}) do
          yield
        end
      else
        Rails.cache.read(key)
      end
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: fetch: K: #{key.inspect}. M: #{exc.message}, I: #{exc.inspect}, \n#{exc.backtrace}" }
      nil
    end

    alias_method :get_set_memcached, :fetch

    # Gets multiple value from cache with provided keys if present, otherwise fetches data and stores in cache
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +keys+:: array of keys for cache object
    #
    # Return values for provided keys
    #
    def fetch_multi(keys, ttl = 0, marshaling = true)
      if block_given?
        Rails.cache.fetch_multi(*keys, {expires_in: get_ttl(ttl), raw: !marshaling}) do
          yield
        end
      else
        Rails.cache.read_multi(*keys)
      end
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: fetch_multi: K: #{keys.inspect}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    # Checks if the key exists in cache store
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +key+:: key to be checked
    # +options+:: additional options if required
    #
    # Return true if exists otherwise false
    #
    def exist?(key, options = nil)
      Rails.cache.exist?(key, options)
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: exists?: K: #{keys.inspect}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end
    alias :exists? :exist?

    # Deletes a particular key from cache store
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    # Params:
    # +key+:: key to be deleted
    #
    def delete(key, options = nil)
      Rails.cache.delete(key, options)
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: delete: K: #{key.inspect}. M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

    alias_method :delete_memcached, :delete

    # Clears the cache store
    #
    # Author:: Raj
    # Date:: 01/06/2016
    # Reviewed By::
    #
    def clear
      Rails.cache.clear
    rescue => exc
      @logger.error { "MEMCACHE-ERROR: clear: M: #{exc.message}, I: #{exc.inspect}" }
      nil
    end

  end
end