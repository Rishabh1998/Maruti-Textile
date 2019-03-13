class QueryHelper
  class << self
    def prepare_query(query_data)
      extracted_fields = []
      normalize_fields('', query_data['fields'], extracted_fields)
      query_string = 'SELECT ' + extracted_fields.join(',') + ' FROM ' + query_data['table_name']
      query_string += ' WHERE ' + normalize_constraints(query_data['constraints']) if query_data['constraints'].present?
      query_string
    end

    def perform_multiple_insert_query(table_name, fields, values, non_updatable_fields = ['created_at'])
      return if table_name.blank? || fields.blank? || values.blank?
      query = insert_clause(table_name, fields) + values_clause(fields,values) + update_clause(fields, non_updatable_fields)
      ActiveRecord::Base.connection.execute(query)
    end

    private
    def normalize_fields(parent, fields, result)
      fields.each {|key, value|
        if value.is_a?(Hash)
          key = [parent,key].join('.') if parent.present? && key.present?
          normalize_fields(key, value, result)
        else
          value.each do |v|
            final_key = v
            final_key = key + '.' + final_key if key.present?
            final_key = parent + '.' + final_key if parent.present?
            result << final_key
          end
        end
      }
    end

    def normalize_constraints(constraints)
      constraint_map = []
      constraints.each do |constraint|
        constraint_map << "#{constraint['field']} #{constraint['op']} #{constraint['value']}"
      end
      constraint_map.join(' AND ')
    end

    def serialize_fields(fields,value_map)
      ordered_fields = []
      fields.each do |field_name|
        value = value_map[field_name]
        if field_name == 'id'
          value = 'NULL' if value.blank?
        elsif value.is_a? String
          value = "'#{value.gsub(/'/){ "\\'" }}'"
        end
        ordered_fields << value
      end
      "(#{ordered_fields.join(',')})"
    end

    def insert_clause(table_name, fields)
      fields_string = fields.join(',')
      "INSERT INTO #{table_name} (#{fields_string})"
    end

    def values_clause(fields,values)
      opp_item_values = values.map{|value_map| serialize_fields(fields,value_map.with_indifferent_access)}.join(",")
      " VALUES #{opp_item_values}"
    end

    def update_clause(fields, non_updatable_fields)
      updatable_fields = fields - non_updatable_fields
      field_updation_string = updatable_fields.map{|field_name| "#{field_name}=VALUES(#{field_name})"}.compact.join(',')
      " ON DUPLICATE KEY UPDATE " + field_updation_string
    end
  end
end
