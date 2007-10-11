# some friendly formatting for rake
module RakeTools
  def h1(text)  
    puts ''
    puts text
    puts '-='*(text.length/2.to_i)+ '-'
    puts ''
  end

  def h2(text)  
    puts text
    puts '--'*(text.length/2.to_i) + '-'
    puts ''
  end

  def br
    puts ''
  end

  def ask(question)
    br
    print question + " [Y/n] : "
  end

  def yes
    STDIN.gets =~ /^[yY\n]$/
  end
  
  def clear
    1.upto(50) do
      puts ""
    end
  end
  
  def request(text, options={})
    if (default = options[:default])
      text << " or hit enter to use '#{default}'"
    end
    puts text + " : "
    (((response = STDIN.gets.chomp) == '') && default) ? default : response
  end
  
  def set_flash(type, msg)
    @flash ||= []
    @flash << "[... #{msg} ...]" if type == :notice
    @flash << "[!!! #{msg} !!!]" if type == :error
  end

  def flash
    if @flash
      @flash.each {|f| puts f if f}
      puts br
      @flash = []
    end
  end
  
end
