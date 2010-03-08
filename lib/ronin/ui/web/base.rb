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
require 'ronin/config'

require 'sinatra/base'
require 'static_paths/finders'

module Ronin
  module UI
    module Web
      class Base < Sinatra::Base

        include StaticPaths::Finders

        # The `public/` directory for the Web UI
        PUBLIC_DIR = File.join('ronin','ui','web','public')

        set :views, '/'

        set :environment, :production
        enable :methodoverride, :sessions

        helpers Helpers::Rendering

        configure do
          Config.load
          Database.setup
        end

        error 404 do
          erb :"404"
        end

        not_found do
          full_path = find_static_file(File.join(PUBLIC_DIR,request.path))

          if full_path
            ext = File.extname(full_path)

            unless (ext.empty? || ext == '.')
              content_type ext[1..-1].to_sym
            end

            File.new(full_path,'rb')
          else
            [404, {'Content-Type' => 'text/html'}, erb(:"404")]
          end
        end

      end
    end
  end
end
