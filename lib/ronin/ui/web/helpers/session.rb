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

require 'ronin/ui/async_console'

module Ronin
  module UI
    module Web
      module Helpers
        module Session
          #
          # The flash messages for the session.
          #
          # @return [Hash]
          #   The flash messages and their categories.
          #
          # @since 0.4.0
          #
          def flash
            if session[:flash] && session[:flash].class != Hash
              session[:flash] = {}
            else
              session[:flash] ||= {}
            end
          end

          #
          # The console used by this session.
          #
          # @return [AsyncConsole]
          #   The asynchronous console.
          #
          # @since 0.4.0
          #
          def console(context=Ronin)
            session[:console] ||= AsyncConsole.new(context)
          end
        end
      end
    end
  end
end
