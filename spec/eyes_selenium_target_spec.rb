require 'spec_helper'
 RSpec.describe Applitools::Selenium::Target do
   it_behaves_like 'has chain methods', fully: nil, ignore_caret: [false]
   context 'ignore_caret' do
     it 'sets ignore_caret option' do
       subject.ignore_caret(true)
       expect(subject.options[:ignore_caret]).to be true
     end

     it 'sets default value when called without args' do
       subject.ignore_caret()
       expect(subject.options[:ignore_caret]).to be false
     end

     it 'false by default' do
       expect(subject.options[:ignore_caret]).to be false
     end
   end
 end