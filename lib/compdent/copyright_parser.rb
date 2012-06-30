module Compdent

  # Find company name in copyright line
  class CopyrightParser

    YEAR = '\d\d\d\d'
    C = '&copy;'
    NO = '[A-Z]?[A-Z]?\d+'

    def initialize line
      @line = line
    end

    def company_number
      case @line
      when /(?:Registered in England No|Company (?:registration|Reg) (?:number|No))\:?\s(#{NO})/i
        $1

      when /registered in England and Wales with company registration numbers (#{NO}) & (#{NO})/
        [$1, $2]

      end
    end

    def organisation_name
      case clean_line
      when /(.+)\s#{YEAR}(\s|$|\.)/
        $1
      when /#{YEAR}\s([^.]+)\.?/
        $1
      when /^#{YEAR}$/
        nil
      when /(.+)/
        $1
      else
        nil
      end
    end

    def clean_line
      line = @line.gsub(/\s/,' ')
      line.squeeze!(' ')
      line.strip!
      # puts line if line.size > 0

      TO_REMOVE.each {|remove| line.sub!(remove,'') }

      line
    end

    TO_REMOVE = ['Footer links ',
      /Copyright\sof\s|Copyright\sby\s|Copyright\s/,
      /\sAll\srights\sreserved/i,
      /#{C}\s/,
      /\s#{C}/]
  end

end
