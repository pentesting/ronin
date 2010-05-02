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

module Ronin
  module UI
    module Web
      module Helpers
        module Params
          #
          # Converts a nested Hash of Sinatra params into an options Hash.
          #
          # @param [Symbol] name
          #   The name of the param to convert.
          #
          # @param [Hash{Symbol => Object]
          #   The options Hash.
          #
          # @since 0.4.0
          #
          def options(name)
            nested_hash = params[name]
            options = {}

            if nested_hash.kind_of?(Hash)
              nested_hash.each do |name,value|
                value = if value.kind_of?(Hash)
                          params_to_options(value)
                        elsif (value.kind_of?(String) && value.empty?)
                          nil
                        else
                          value
                        end

                options[name.to_sym] = value
              end
            end

            return options
          end
        end
      end
    end
  end
end
