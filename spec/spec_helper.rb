require 'rspec'
require 'model/models/basic_model'
require 'model/models/custom_model'
require 'model/models/authored_model'
require 'model/models/described_model'
require 'model/models/licensed_model'
require 'model/models/named_model'
require 'model/models/titled_model'
require 'helpers/repositories'

require 'ronin/spec/database'

include Ronin

RSpec.configure do |spec|
  spec.before(:suite) do
    [
      BasicModel,
      CustomModel,
      AuthoredModel,
      DescribedModel,
      LicensedModel,
      NamedModel,
      TitledModel,
      MyScript
    ].each(&:auto_migrate!)
  end

  spec.before(:suite) do
    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'local'),
      :name => 'local',
      :domain => Repository::LOCAL_DOMAIN
    )

    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'remote'),
      :uri => 'git@example.com/path/to/remote.git',
      :name => 'remote',
      :domain => 'example.com'
    )

    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'installed'),
      :uri => 'git@github.com/path/to/installed.git',
      :installed => true,
      :name => 'installed',
      :domain => 'github.com'
    )

    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'scripts'),
      :uri => 'git@github.com/path/to/scripts.git',
      :name => 'scripts',
      :domain => 'github.com'
    )
  end
end
