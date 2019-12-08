require 'spec_helper'

RSpec.describe 'vg_resource' do
  let(:content) { |example| File.read(example.description) }
  it 'spec/fixtures/applitools_logo_combined.svg' do
    block = proc do |list, url|
      expect(url).to be_a(URI)
      expect(url.to_s).to eq('https://applitools.com')
      expect(list).to include('logo.svg')
      expect(list).to include('company_name.png')
      expect(list).to include('slogan.svg')
    end

    Applitools::Selenium::VGResource.new(
      'https://applitools.com',
      'image/svg+xml',
      content,
      on_resources_fetched: block
    )
  end

  it 'spec/fixtures/chevron.svg' do
    block = proc do |l, u|
      expect(l).to be_a(Array)
      expect(u).to be_a(URI)
      expect(u.to_s).to eq('https://applitools.com')
    end
    expect do
      Applitools::Selenium::VGResource.new(
          'https://applitools.com',
          'image/svg+xml',
          content,
          on_resources_fetched: block
      )
    end.to_not raise_error
  end

  it 'spec/fixtures/fa-regular-400.svg' do
    block = proc do |l, u|
      expect(l).to be_a(Array)
      expect(u).to be_a(URI)
      expect(u.to_s).to eq('https://applitools.com')
    end
    expect do
      Applitools::Selenium::VGResource.new(
          'https://applitools.com',
          'image/svg+xml',
          content,
          on_resources_fetched: block
      )
    end.to_not raise_error
  end
end
