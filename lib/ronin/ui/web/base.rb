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

require 'sinatra/base'

module Ronin
  module UI
    module Web
      class Base < Sinatra::Base

        # The public/ directory for the Web UI
        PUBLIC_DIR = File.join('ronin','ui','web','public')

        #
        # Sets the public directory for a Web app.
        #
        # @param [String] static_dir
        #   The path to the apps static-content directory.
        #
        # @since 0.4.0
        #
        def self.public!(static_dir)
          set :public, File.join(static_dir,PUBLIC_DIR)
        end

      end
    end
  end
end
