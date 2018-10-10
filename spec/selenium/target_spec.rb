# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Applitools::Selenium::Target do
  context 'send_dom' do
    it 'Responds to \'send_dom\'' do
      expect(subject).to respond_to :send_dom
    end
    it 'Returns self' do
      expect(subject.send_dom(true).object_id).to eq subject.object_id
    end
    it 'Sets options' do
      subject.send_dom(false)
      expect(subject.options[:send_dom]).to be false
      subject.send_dom(true)
      expect(subject.options[:send_dom]).to be true
    end
    it ':send_dom default value' do
      expect(subject.options[:send_dom]).to be true
    end
  end
end