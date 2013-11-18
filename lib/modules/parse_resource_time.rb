require "parse_resource/base"

module ParseResource
  class Base
    def get_attribute(k)
      #raise "".to_yaml
      attrs = @unsaved_attributes[k.to_s] ? @unsaved_attributes : @attributes
      case attrs[k]
        #raise "".to_yaml
        when Hash
          klass_name = attrs[k]["className"]
          klass_name = "User" if klass_name == "_User"
          case attrs[k]["__type"]
            when "Pointer"
              result = klass_name.constantize.find(attrs[k]["objectId"])
            when "Object"
              result = klass_name.constantize.new(attrs[k], false)
            when "Date"
              result = DateTime.parse(attrs[k]["iso"]).to_time.localtime#to_time_in_current_zone
            when "File"
              result = attrs[k]["url"]
            when "GeoPoint"
              result = ParseGeoPoint.new(attrs[k])
          end #todo: support other types https://www.parse.com/docs/rest#objects-types
        else
          result =  attrs["#{k}"]
      end
      result
    end
  end
end