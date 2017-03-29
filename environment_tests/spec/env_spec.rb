require 'spec_helper'
require 'docker_files_list'

RSpec.describe 'Environment tests' do
  include Rspec::Shell::Expectations

  let(:stubbed_env) { create_stubbed_env }

  DockerFilesList.dockerfiles do |dockerfile, _dir|
    it dockerfile do
      _stdout, _stderr, status = stubbed_env.execute(
        "docker run  -v $PWD/../:/source_dir -w /workdir #{dockerfile} " \
        "/source_dir/environment_tests/spec/scripts/prepare_repo_and_run_tests.sh > log/#{dockerfile}.log 2>&1"
      )
      expect(status.exitstatus).to eq 0
    end
  end
end
