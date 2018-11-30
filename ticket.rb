class Ticket
  attr_accessor :number, :title, :status

  def initialize number = '', title = '', status = ''
    @number = number
    @title = title
    @status = status
  end

  def create_ticket
    %w(number title status).each {|s| build_ticket s }
  end

  def build_ticket section
    case section
    when 'number'
      puts "GC ticket number?"
      print ":> "
      self.number = gets.chomp
    when 'title'
      puts "Ticket title?"
      print ":> "
      self.title = gets.chomp
    when 'status'
      puts "Ticket status?"
      print ":> "
      self.status = gets.chomp
    end
  end

  def display_message
    print "-"
    if !self.number.empty? then print " GC-#{self.number}" end
    if !self.title.empty? then print " #{self.title}:" end
    print " #{self.status} \n"
  end

end