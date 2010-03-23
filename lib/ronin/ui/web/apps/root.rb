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
require 'ronin/installation'
require 'ronin/platform'
require 'ronin/database'
require 'ronin/config'

module Ronin
  module UI
    module Web
      module Apps
        class Root < Base

          self.lib_root = File.join(File.dirname(__FILE__),'..','..','..','..','..')
          self.menu = {
            'Database' => '/database',
            'Overlays' => '/overlays',
            'About' => '/about'
          }

          set :intro, false
          set :skip_intro, false

          error Platform::OverlayNotFound do
            flash[:error] = request.env['sinatra.error'].message

            redirect '/overlays'
          end

          error Platform::DuplicateOverlay do
            flash[:error] = request.env['sinatra.error'].message

            redirect '/overlays'
          end

          get '/' do
            unless (Root.skip_intro || Root.intro)
              Root.intro = true

              redirect '/intro'
            end

            erb :index
          end

          get '/intro' do
            erb :intro, :layout => false
          end

          get '/database' do
            @repositories = Database.repositories

            erb :database
          end

          get '/database/new' do
            erb :database_new
          end

          post '/database/add' do
            if params[:name].blank?
              flash[:error] = "No Database Repository name given."
              redirect '/database/add'
            end

            if params[:uri].blank?
              flash[:error] = "No Database Repository URI given."
              redirect '/database/add'
            end

            name = params[:name].to_sym

            Database.save do
              Database.repositories[name] = params[:uri]
            end

            flash[:notice] = "Database repository #{params[:name]} added."
            redirect '/database'
          end

          post '/database/:name/set' do
            Database.save do
              Database.repositories[name] = params[:uri]
            end

            flash[:notice] = "Database repository #{params[:name]} was set to #{params[:uri]}."
            redirect '/database'
          end

          post '/database/:name/remove' do
            name = params[:name].to_sym

            Database.save do
              Database.repositories.delete(name)
            end

            flash[:notice] = "Database repository #{params[:name]} was removed."
            redirect '/database'
          end

          get '/overlays' do
            @overlays = Platform::Overlay.all

            erb :overlays
          end

          get '/overlays/:name/:domain' do
            @overlay = Platform::Overlay.get(
              "#{params[:name]}/#{params[:domain]}"
            )

            erb :overlay
          end

          get '/overlays/add' do
            erb :overlays_add
          end

          post '/overlays/add' do
            if params[:path].blank?
              flash[:error] = "Must specify a path to add."
              redirect '/overlays/add'
            end

            overlay = Platform::Overlay.add!(
              :path => params[:path],
              :uri => params[:uri],
              :scm => params[:scm]
            )

            flash[:notice] = "Overlay #{overlay} was successfully added."
            redirect '/overlays'
          end

          get '/overlays/install' do
            erb :overlays_install
          end

          post '/overlays/install' do
            if params[:uri].blank?
              flash[:error] = "Must specify a URI to install from."
              redirect '/overlays/add'
            end

            overlay = Platform::Overlay.install!(
              :uri => params[:uri],
              :scm => params[:scm]
            )

            flash[:notice] = "Overlay #{overaly} was successfilly installed."
            redirect '/overlays'
          end

          get '/overlays/:name/:domain/uninstall' do
            @overlay = Platform::Overlay.get(
              "#{params[:name]}/#{params[:domain]}"
            )

            erb :overlays_uninstall
          end

          post '/overlays/uninstall' do
            if params[:name].blank?
              flash[:error] = "The 'name' of the Overlay to uninstall was not given"
              redirect '/overlays'
            end

            if params[:domain].blank?
              flash[:error] = "The 'domain' of the Overlay to uninstall was not given"
              redirect '/overlays'
            end

            overlay = Platform::Overlay.uninstall!(
              "#{params[:name]}/#{params[:domain]}"
            )

            flash[:notice] = "Overlay #{overlay} was successfully uninstalled."
            redirect '/overlays'
          end

          get '/console' do
            flash[:notice] = "Console not yet implemented."
            redirect '/'
          end

          get '/about' do
            erb :about
          end

        end
      end
    end
  end
end
