# frozen_string_literal: true

module Behaveable
  module RouteExtractor
    def extract(behaveable = nil, resource = nil)
      resource_name   = resource_name_from(params)
      behaveable_name = behaveable_name_from(behaveable)
      location_url = "#{resource_name}_url"
      return regular(location_url, resource) unless behaveable
      location_url = "#{behaveable_name}_#{resource_name}_url"
      nested(location_url, behaveable, resource)
    end

    private

      def regular(location_url, resource)
        return send(location_url) unless resource
        send(location_url, resource)
      end

      def nested(location_url, behaveable, resource)
        return send(location_url, behaveable) unless resource
        send(location_url, behaveable, resource)
      end

      def resource_name_from(params)
        inflect = params[:id].present? ? 'singular' : 'plural'
        params[:controller].split('/').last.send("#{inflect}ize")
      end

      def behaveable_name_from(behaveable)
        return unless behaveable
        behaveable.class.name.underscore
      end
  end
end
