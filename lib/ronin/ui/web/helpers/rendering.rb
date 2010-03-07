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

require 'static_paths/finders'

require 'rack/utils'

module Ronin
  module UI
    module Web
      module Helpers
        module Rendering
          include StaticPaths::Finders
          include Rack::Utils

          alias :h :escape_html

          # The `views/` directory for the Web UI
          VIEWS_DIR = File.join('ronin','ui','web','views')

          #
          # Finds a template within the static-resource directories and
          # renders it.
          #
          # @param [Symbol] engine
          #   The template engine to use.
          #
          # @param [Symbol]
          #   The name of the template to search for.
          #
          # @param [Hash] options
          #   Additional options to render the template with.
          #
          # @option options [String] :views (VIEWS_DIR)
          #   The `views/` directory to search within.
          #
          # @option options [Symbol, Boolean] :layout
          #   If set to false, no layout is rendered, otherwise
          #   the specified layout is used.
          #
          # @option options [Hash] :locals
          #   Local variables that should be available in the template.
          #
          def render(engine,template,options={},locals={})
            views_dir = (options[:views] || Rendering::VIEWS_DIR)
            template = File.join(views_dir,template)
            full_path = find_static_file(template)

            unless full_path
              raise(RuntimeError,"could not find the template #{template}",caller)
            end

            return super(engine,full_path,options,locals)
          end

          #
          # Renders a partial page.
          #
          # @param [String] page
          #   Name of the partial to render.
          #
          # @param [Hash] options
          #   Additional options.
          #
          # @option options [Symbol] :engine (:erb)
          #   The template engine to use.
          #
          # @return [String]
          #   The rendered page.
          #
          # @see #render
          #
          # @since 0.4.0
          #
          def partial(page,options={})
            engine = (options[:engine] || :erb)
            template = :"_#{page}"

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
