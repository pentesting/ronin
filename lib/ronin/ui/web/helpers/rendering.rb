#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'rack/utils'
require 'json'

module Ronin
  module UI
    module Web
      module Helpers
        module Rendering
          include Rack::Utils

          alias :h :escape_html

          #
          # Renders a view.
          #
          # @param [String] name 
          #   Name of the view to render.
          #
          # @param [Hash] options
          #   Additional options.
          #
          # @option options [Symbol] :engine (:erb)
          #   The template engine to use.
          #
          # @return [String]
          #   The rendered view.
          #
          # @since 0.4.0
          #
          def show(name,options={})
            engine = (options[:engine] || :erb)

            return render(engine,name.to_sym,options)
          end

          #
          # Renders a partial view.
          #
          # @param [String] name
          #   Name of the partial to render.
          #
          # @param [Hash] options
          #   Additional options.
          #
          # @option options [Symbol] :engine (:erb)
          #   The template engine to use.
          #
          # @return [String]
          #   The rendered partial view.
          #
          # @since 0.4.0
          #
          def partial(name,options={})
            engine = (options[:engine] || :erb)
            template = :"_#{name}"

            return render(engine,template,options.merge(:layout => false))
          end

          #
          # Renders a JSON blob.
          #
          # @param [Object] obj
          #   The object to convert to a JSON blob.
          #
          # @return [String]
          #   The encoded JSON blob.
          #
          # @since 0.4.0
          #
          def json(obj)
            content_type :json

            obj = obj.to_s unless obj.respond_to?(:to_json)
            return obj.to_json
          end
        end
      end
    end
  end
end
