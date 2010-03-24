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

require 'ronin/ui/command_line/command'
require 'ronin/ui/web'

module Ronin
  module UI
    module CommandLine
      module Commands
        class WebApp < Command

          desc 'Starts the Ronin Web UI'
          class_option :host, :default => Web::DEFAULT_HOST,  :aliases => '-I'
          class_option :port, :default => Web::DEFAULT_PORT, :aliases => '-p'
          class_option :skip_intro, :type => :boolean

          #
          # Starts the local Ronin Web UI.
          #
          def execute
            Web::Apps::Root.skip_intro = options.skip_intro?

            Web.start(:host => options[:host], :port => options[:port])
          end

        end
      end
    end
  end
end
