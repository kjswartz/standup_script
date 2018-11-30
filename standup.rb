require 'date'

class Standup
  attr_accessor :previously, :today, :blockers

  def initialize
    @previously = []
    @today = []
    @blockers = []
  end

  def add_ticket ticket, section
    case section
    when 'blockers'
      @blockers << ticket
    when 'previously'
      @previously << ticket
    when 'today'
      @today << ticket
    end
  end

  def remove_ticket ticket, section
    case section
    when 'blockers'
      @blockers.delete ticket
    when 'previously'
      @previously.delete ticket
    when 'today'
      @today.delete ticket
    end
  end

  # displays standup
  def preview
    puts Date.today().strftime('%m/%d/%y')
    puts "*previously*"
    @previously.empty? ? puts("- none") : @previously.each do |t| 
      t.display_message
    end
    puts "*today*"
    @today.empty? ? puts("- none") : @today.each do |t| 
      t.display_message
    end
    puts "*blockers*"
    @blockers.empty? ? puts("- none") : @blockers.each do |t| 
      t.display_message
    end
    puts "\n"
  end
end