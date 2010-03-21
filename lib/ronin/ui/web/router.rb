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

require 'ronin/ui/web/apps/root'
require 'ronin/ui/web/apps'
require 'ronin/installation'
require 'ronin/database'
require 'ronin/config'

require 'set'
require 'rack'

module Ronin
  module UI
    module Web
      #
      # The {Router} is in charge of receiving HTTP requests for the Web UI,
      # auto-loading Web UI sub-apps and routing the requests to the
      # appropriate sub-app.
      #
      class Router < Rack::Builder

        # Default host to run the Web UI on
        DEFAULT_HOST = 'localhost'

        # Default port to run the Web UI on
        DEFAULT_PORT = 3030

        # Default server to run under
        DEFAULT_SERVER = 'Thin'

        #
        # The sub-app names and classes that the Router will route
        # requests to.
        #
        # @return [Hash{String => Class}]
        #   The sub-app names and classes.
        #
        # @since 0.4.0
        #
        def Router.sub_apps
          unless defined?(@@ronin_ui_web_apps)
            @@ronin_ui_web_apps = {}

            pattern = File.join('lib',Apps.namespace_root,'*.rb')

            Installation.each_file_in(pattern) do |path,gem|
              name = path.gsub(/\.rb$/,'')

              unless name == 'root'
                @@ronin_ui_web_apps[name] = nil
              end
            end
          end

          return @@ronin_ui_web_apps
        end

        #
        # Creates a new Router Rack app.
        #
        # @return [Router]
        #   The new Router app.
        #
        # @since 0.4.0
        #
        def Router.app
          Router.new do
            map '/' do
              run Apps::Root
            end

            Router.sub_apps.each_key do |name|
              map "/#{name}" do
                run lambda { |env|
                  unless Router.sub_apps[name]
                    Router.sub_apps[name] = Apps.require_const(name)
                  end

                  Router.sub_apps[name].call(env)
                }
              end
            end
          end
        end

        #
        # Runs the Router using the Thin web server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :host (DEFAULT_HOST)
        #   The interface to bind to.
        #
        # @option options [String] :port (DEFAULT_PORT)
        #   The port to listen on for requests.
        #
        # @since 0.4.0
        #
        def Router.start(options={})
          Config.load
          Database.setup

          Rack::Handler.get(DEFAULT_SERVER).run(
            Router.app,
            :Host => (options[:host] || DEFAULT_HOST),
            :Port => (options[:port] || DEFAULT_PORT)
          )
        end

      end
    end
  end
end
