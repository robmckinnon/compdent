# encoding: utf-8
module Compdent

  # Find company name in copyright line
  class CopyrightParser

    C = '&copy;'
    YEAR = '\d\d\d\d'
    NO = '[A-Z]?[A-Z]?\d+'

    def initialize line
      @line = CopyrightLine.new line
      first_line = line.split("\n").first.sub("\r",'')
      @first_line = first_line[/#{C}/] ? CopyrightLine.new(first_line) : nil
    end

    def company_number
      case @line.cleaned
      when /(?:Registered (?:in England(?: (?:&|and) Wales)?\.? )?No\.?|(?:Company )?(?:registration|Reg) (?:number|No))(?:\:|\.)?\s(#{NO})/i
        $1
      when /company no\. (#{NO})/i
        $1
      when /registered in England and Wales with company registration numbers (#{NO}) & (#{NO})/
        [$1, $2]
      else
        nil
      end
    end

    def organisation_name
      name = find_organisation_name
      name ? name.split(/\s\|\s/).first : name
    end

    NAME = /(?:\w|-|')/
    NAME_MATCH = /((?:#{NAME}+\s)+)(\(\w+\)\s)?(Ltd|Limited)/

    def find_organisation_name
      name = @line.name_between_symbol_and_year

      name = name ? name : find_organisation_name_from_cleaned_line(@first_line || @line)

      (name && name[/Web Design|document.write/i]) ? nil : name
    end

    def find_organisation_name_from_cleaned_line line
      case line.cleaned
      when /#{YEAR}\s+(#{NAME_MATCH})/, /\.\s+(#{NAME_MATCH})/, /(#{NAME_MATCH})\s+#{YEAR}/
        $1
      when /^#{YEAR}$/, /^\s*#{YEAR}\s*-\s*#{YEAR}\s*$/
        nil
      when /(?:\s|^)#{YEAR}(?:-\s*#{YEAR})?\,?\s([^-].+)\.?/, /(.+[^-])\s#{YEAR}(\s|$|\.)/, /(.+)/
        $1.squeeze('.').chomp('.').split('. ').first.strip
      else
        nil
      end
    end

  end

  # represents copyright line
  class CopyrightLine

    C = '&copy;'
    YEAR = '\d\d\d\d'

    TO_REMOVE = ['Footer links ',
      /Copyright\sof\s|Copyright\sby\s|Copyright\s/,
      /\sAll\srights\sreserved/i,
      /All\scontent\sis\s/,
      /#{C}\s/,
      /\s#{C}/,
      /#{C}/]

    def initialize line
      @line = line.gsub('–','-')
      clean
    end

    def cleaned
      @cleaned_line
    end

    def line
      @line
    end

    def clean
      @cleaned_line = @line.gsub(/\s/,' ')
      # puts @line if @line.size > 0

      TO_REMOVE.each {|remove| @cleaned_line.sub!(remove,' ') }
      @cleaned_line.squeeze!(' ')
      @cleaned_line.strip!
    end

    def name_between_symbol_and_year
      name = @line[/#{C}\s(.+)\s#{YEAR}/,1]

      if name && @cleaned_line[/#{name}/] && !name[/#{YEAR}\s*-/]
        name
      else
        nil
      end
    end

  end

end


