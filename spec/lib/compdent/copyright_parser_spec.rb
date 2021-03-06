# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../../lib/compdent/copyright_parser'

describe Compdent::CopyrightParser do

  let(:parser) { Compdent::CopyrightParser.new line }

  let(:year) { '2007' }
  let(:copyright_symbol) { '&copy;' }
  let(:name) { 'Acme' }
  let(:website_name) { 'Acme.co.uk' }
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

    context "number after Company Reg No:" do
      let(:line) { "Company Reg No: #{number}" }
      include_examples 'correct number'
    end

    context "number after England & Wales No." do
      let(:line) { "Registered in England & Wales No. #{number}" }
      include_examples 'correct number'
    end

    context 'reg no them company name' do
      let(:line) { "Registration No. #{number}" }
      include_examples 'correct number'
    end

    context 'after in England and Wales, company no.' do
      let(:line) { "in England and Wales, company no. #{number}" }
      include_examples 'correct number'
    end

    context 'after Registered in England and Wales. No.' do
      let(:line) { "Registered in England and Wales. No. #{number}" }
      include_examples 'correct number'
    end

    context 'after company number' do
      let(:line) { "Loaf Social Enterprise Ltd (company number #{number})" }
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

		context 'company name ending in "Ltd"' do
		  let(:ltd_name) { 'Acme Co Ltd' }
  		let(:line) { "#{copyright_symbol} #{year} #{website_name} All Rights Reserved.\n#{ltd_name}. is authorised" }
		  let(:name) { website_name }
      include_examples 'correct name'
    end

    context "website ltd" do
      let(:name) { "Acme.co.uk Limited"}
      let(:line) { "#{copyright_symbol} #{year} #{name}. All Rights Reserved." }
    end

    context 'company name ending in "(UK) Limited"' do
		  let(:name) { 'Acme (UK) Limited' }
  		let(:line) { "Brand Advertising\n#{copyright_symbol} #{year} #{name}" }
      include_examples 'correct name'
    end

    context 'copyright symbol years' do
      let(:line) { "Copyright #{copyright_symbol} 2009-2012" }
      include_examples 'return nil'
    end

    context 'copyright symbol years' do
      let(:line) { "Copyright #{copyright_symbol} 2009 - 2012 " }
      include_examples 'return nil'
    end

    context 'reg no them company name' do
      let(:line) { "Registration No. #{number}     #{copyright_symbol} #{year} #{name}. All Rights Reserved." }
      include_examples 'correct name'
    end

    context 'after year-year' do
      let(:line) { "#{copyright_symbol} 2003-#{year} #{name}" }
      include_examples 'correct name'
    end

    context 'name between copyright symbol and year' do
		  let(:name) { 'Acme (UK) Limited' }
      let(:line) { "#{copyright_symbol} #{name} #{year} | Version 2.1.0.6" }
      include_examples 'correct name'
    end

    context 'between symbol and year with preceeding text' do
      let(:line) { "Important regulatory information and risk warnings
      Copyright #{copyright_symbol} #{name} #{year}" }
      include_examples 'correct name'
    end

    context 'after symbolyear' do
      let(:line) { "#{copyright_symbol}#{year} #{name}" }
      include_examples 'correct name'
    end

    context 'web design line' do
      let(:line) { "#{copyright_symbol} All rights reserved. Web Design Cumbria by Wombat" }
      include_examples 'return nil'
    end

    context 'name before symbol and year with succeeding text' do
      let(:line) { "#{name} #{copyright_symbol} #{year}\n\nUnlicensed Software" }
      include_examples 'correct name'
    end

    context 'when dash in name' do
      let(:name) { "Micro-Business Ltd" }
      let(:line) { "#{name} #{copyright_symbol} #{year}-2011Privacy Policy" }
      include_examples 'correct name'
    end

    context "followed by copyright and years" do
      let(:line) { "#{name} #{copyright_symbol} #{year} - 2012" }
      include_examples 'correct name'
    end

    context "dots in following" do
      let(:line) { "#{copyright_symbol} #{year} #{name}. All Rights Reserved.Powered by WordPress." }
      include_examples 'correct name'
    end

    context 'quote in name' do
      let(:name) { "Acme's Supplies Ltd" }
      let(:line) { "#{copyright_symbol} Copyright #{name} #{year}" }
      include_examples 'correct name'
    end

    context 'comma after year' do
      let(:line) { "#{copyright_symbol} Copyright 1998-#{year}, #{name}. All rights reserved." }
      include_examples 'correct name'
    end

    context "year before ltd" do
      let(:name) { 'Acme Limited' }
      let(:line) { "Contact Us\nprovided by #{name}.  #{copyright_symbol} #{year} #{name} its affiliates and licensors" }
      include_examples 'correct name'
    end

  end

end
