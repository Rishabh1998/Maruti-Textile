# This module adds methods such as find, all_ids, valid, all_name, indexed_by_name
module I18nBase

  # This class implements Internationalization class methods
  # Author:: Raj
  module ClassMethods
    # Abstract method
    def all
      raise NotImplementedError, 'Extending class should implement this method'
    end

    # Author:: Raj
    # Written on:: 2016-01-04
    #
    # <b>Returns</b>
    # * <b>Enumerator</b> Enumerator for ids
    #
    def all_ids
      @all_ids ||= all.keys
    end

    # Author:: Raj
    # Written on:: 2016-01-04
    #
    # <b>Returns</b>
    # * <b>Enumerator</b> Enumerator for names
    #
    def all_names
      @all_names ||= indexed_by_name.keys
    end

    # Author:: Raj
    # Written on:: 2016-01-04
    #
    # <b>Returns</b>
    # * <b>Hash</b> Hash indexed by name
    #
    def indexed_by_name
      @indexed_by_name ||= all.inject({}) { |hash, (_, info)| hash[info.name] = info; hash }
    end

    # Author:: Raj
    # Written on:: 2016-01-04
    #
    # <b>Expects</b>
    # * <b>id</b> <em>(Integer)</em>
    #
    # <b>Returns</b>
    # * <b>Object:</b> Respective object
    #
    def find(id)
      all[id.to_i]
    end

    # Author:: Raj
    # Written on:: 2016-01-04
    #
    # <b>Expects</b>
    # * <b>id</b> <em>(Integer)</em> -  Id
    #
    # <b>Returns</b> <em>(Boolean)</em>:
    # * <b>true / false :</b> : Boolean
    #
    def valid?(id)
      all.key?(id)
    end

    # Author:: Raj
    # Written on:: 2016-01-04
    #
    # <b>Expects</b>
    # * <b>name</b> <em>(String)</em> -  name
    #
    # <b>Returns</b> <em>(Boolean)</em>:
    # * <b>object</b> : Respective object
    #
    def find_by_name(name)
      indexed_by_name[name.to_s]
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
