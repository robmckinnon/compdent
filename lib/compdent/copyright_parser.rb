module Compdent

  # Find company name in copyright line
  class CopyrightParser

    YEAR = '\d\d\d\d'
    NO = '[A-Z]?[A-Z]?\d+'

    def initialize line
      @line = CopyrightLine.new line
    end

    def company_number
      case @line.cleaned
      when /(?:Registered in England No|Company (?:registration|Reg) (?:number|No))\:?\s(#{NO})/i
        $1
      when /registered in England and Wales with company registration numbers (#{NO}) & (#{NO})/
        [$1, $2]
      else
        nil
      end
    end

    def organisation_name
      case @line.cleaned
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

  end

  # represents copyright line
  class CopyrightLine

    C = '&copy;'

    TO_REMOVE = ['Footer links ',
      /Copyright\sof\s|Copyright\sby\s|Copyright\s/,
      /\sAll\srights\sreserved/i,
      /#{C}\s/,
      /\s#{C}/]

    def initialize line
      @line = line
      clean
    end

    def cleaned
      @line
    end

    def clean
      @line.gsub!(/\s/,' ')
      @line.squeeze!(' ')
      @line.strip!
      # puts line if line.size > 0

      TO_REMOVE.each {|remove| @line.sub!(remove,'') }
    end

  end

end


