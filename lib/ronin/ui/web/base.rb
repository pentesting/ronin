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

require 'ronin/ui/web/helpers/rendering'

require 'sinatra/base'
require 'rack/flash'

module Ronin
  module UI
    module Web
      class Base < Sinatra::Base
        
        STATIC_DIR = File.join('static','ronin','ui','web')

        #
        # Sets the root of the Web application, relative to the root
        # of the library.
        #
        # @param [String] lib_root
        #   The root of the library.
        def self.lib_root=(lib_root)
          set :root, File.expand_path(File.join(lib_root,STATIC_DIR))
        end

        #
        # Caches a template into the Web application.
        #
        # @param [Symbol, String] name
        #   The name of the template.
        #
        # @param [String] file_name
        #   The file name of the template.
        #
        # @since 0.4.0
        #
        def self.cache_template(name,file_name=nil)
          if file_name
            file_name = File.join(self.root,file_name)
          else
            file_name = File.join(self.views,"#{name}.erb")
          end

          template(name.to_sym) do
            File.read(file_name)
          end
        end

        #
        # The menu items and their links for the Web application.
        #
        # @return [Hash]
        #   The names and links for the menu.
        #
        # @since 0.4.0
        #
        def self.menu
          @menu ||= {}
        end

        #
        # Adds entries to the Web application's menu.
        #
        # @param [Hash{String => String}]
        #   New names and links to add to the menu.
        #
        # @since 0.4.0
        #
        def self.menu=(new_menu)
          self.menu.merge!(new_menu)
        end

        #
        # The menu of the Web application.
        #
        # @return [Hash{String => String}].
        #   The menu's names and links.
        #
        # @since 0.4.0
        #
        def menu
          self.class.menu
        end

        self.lib_root = File.join(File.dirname(__FILE__),'..','..','..','..')

        set :environment, :production
        enable :methodoverride, :static, :sessions

        use Rack::Flash, :sweep => true

        helpers Helpers::Rendering

        cache_template :layout, File.join('layouts','default.erb')
        cache_template '404'
        cache_template 'error'

        error do
          @error = request.env['sinatra.error']

          status 500
          erb :error
        end

        error 404 do
          erb :"404"
        end

      end
    end
  end
end
