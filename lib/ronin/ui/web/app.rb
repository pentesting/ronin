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

require 'ronin/ui/web/base'
require 'ronin/ui/web/apps'
require 'ronin/database'
require 'ronin/config'

module Ronin
  module UI
    module Web
      class App < Base

        # Default host to run the Web UI on
        DEFAULT_HOST = 'localhost'

        # Default port to run the Web UI on
        DEFAULT_PORT = 3030

        set :debug, false
        set :host, DEFAULT_HOST
        set :port, DEFAULT_PORT
        set :intro, true
        set :intro_completed, false

        configure do
          Config.load
          Database.setup
        end

        get '/' do
          if (App.intro && !(App.intro_completed))
            @intro = true
          end

          result = erb :index

          if @intro
            App.intro_completed = true
          end

          result
        end

      end
    end
  end
end
