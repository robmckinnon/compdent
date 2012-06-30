# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../../lib/compdent/copyright_parser'

describe Compdent::CopyrightParser do

  let(:parser) { Compdent::CopyrightParser.new line }

  let(:year) { '2007' }
  let(:copyright_symbol) { '&copy;' }
  let(:name) { 'Acme' }
  let(:number) { 'SC894646' }

  shared_examples 'correct number' do
    it 'should return number' do
      parser.company_number.should == number
    end
  end

  shared_examples 'correct name' do
    it 'should return name' do
      parser.organisation_name.should == name
    end
  end

  shared_examples 'return nil' do
    it 'should return nil' do
      parser.organisation_name.should be_nil
    end
  end

  describe "asked for company number" do
    context 'number after Registered in England No' do
      let(:line) { "Registered in England No #{number}" }
      include_examples 'correct number'
    end

    context "number after Company registration number:" do
      let(:line) { "Company registration number: #{number}" }
      include_examples 'correct number'
    end

    context "numbers after registered in England and Wales with company registration numbers" do
      let(:line) { "registered in England and Wales with company registration numbers 04252091 & 04252093" }
      let(:number) { ['04252091', '04252093'] }
      include_examples 'correct number'
    end

    context "number after Company Reg No: 3736872" do
      let(:line) { "Company Reg No: #{number}" }
      include_examples 'correct number'
    end
  end

  describe "asked for organisation name" do

    context "name after copyright symbol and year" do
      let(:line) { "All content is #{copyright_symbol} #{year} #{name} | Website design by Blah"}
      include_examples 'correct name'
    end

    context "name between copyright symbol and year" do
      let(:line) { "#{copyright_symbol} #{name} #{year}"}
      include_examples 'correct name'
    end

    context 'name between year and ". "' do
      let(:name) { 'Acme Inc' }
      let(:line) { "#{year} #{name}. #{copyright_symbol}"}
      include_examples 'correct name'
    end

    context "name between year and final ." do
      let(:line) { "#{copyright_symbol} Copyright #{year} #{name}." }
      include_examples 'correct name'
    end

    context 'name between copyright symbol + Copyright of and year' do
      let(:line) { "#{copyright_symbol} Copyright of #{name} #{year}" }
      include_examples 'correct name'
    end

    context 'name after copyright symbol + Copyright of ' do
      let(:line) { "#{copyright_symbol} Copyright of #{name}" }
      include_examples 'correct name'
    end

    context 'name after copyright symbol' do
      let(:line) { "Footer links #{copyright_symbol} #{name}" }
      include_examples 'correct name'
    end

    context "name before copyright symbol" do
      let(:line) { "#{name} #{copyright_symbol}" }
      include_examples 'correct name'
    end

    context 'name after year followed by other stuff' do
      let(:line) { "#{copyright_symbol} #{year} #{name}. All rights reserved. Simply Business is authorised and regulated by the FSA. Company registration number: 0000000" }
      include_examples 'correct name'
    end

    context "year C All rights reserved" do
      let(:line) { "#{year} #{copyright_symbol} All rights reserved" }
      include_examples 'return nil'
    end

  end

end
