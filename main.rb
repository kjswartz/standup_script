load 'standup.rb'
load 'ticket.rb'

####################################################################
@standup = Standup.new
####################################################################
# helper methods
def is_yes answer
  if answer.empty? 
    return false 
  else
    lcase = answer.downcase
    if lcase === 'y' || lcase === 'yes' || lcase === '1' || lcase === 1
      return true
    end
  end
end

def preview_standup
  puts "\n" 
  puts "STANDUP:"
  @standup.preview
end

def create_ticket section
  ticket = Ticket.new
  ticket.create_ticket
  @standup.add_ticket ticket, section
end

def edit_loop ticket, section
  loop do
    ticket.display_message
    puts "Edit Number[n], Title[t], or Status[s]? Delete[d]?"
    print ":> "
    answer = gets.chomp
    break if answer.empty? || answer === "q"
    case answer.downcase
    when 'n'
      puts "GC ticket number?"
      print ":> "
      ticket.number = gets.chomp
    when 't'
      puts "Ticket title?"
      print ":> "
      ticket.title = gets.chomp
    when 's'
      puts "Ticket status?"
      print ":> "
      ticket.status = gets.chomp
    when 'd'
      # @standup.remove_ticket ticket, section
      return ticket
    end
  end
end

def edit_standup
  %w(previously today blockers).each do |section| 
    puts "#{section.upcase}: "
    if @standup.public_send(section).empty?
      puts("- none")
      puts "Edit?"
      print ":> "
      answer = gets.chomp
      if is_yes answer
        create_ticket section
      end
    else
      # setup delete ticket array
      delete_tickets = []
      @standup.public_send(section).each do |t|
        delete_tickets << edit_loop(t, section)
      end
      # if tickets to delete remove them
      if delete_tickets.any?
        delete_tickets.each { |t| @standup.remove_ticket(t, section) }
      end
      # finished loop through current tickets ask if they want to add a new one
      loop do
        puts "Add a new ticket to #{section} section?"
        print ":> "
        answer = gets.chomp
        break if answer.empty? || answer == "n"
        create_ticket section
      end
    end
  end
end
####################################################################
# Open file and grab last entry for display
previsouly = IO.readlines("/Users/kyleswartz/Documents/standup").last(25)

# set starting line
starting_line = 0
previsouly.each_with_index do |line, i|
  if line.include?("*today*"); starting_line = i end
end

# bool line markers
at_blockers = false
# loop through the lines and build todays standup
previsouly.drop(starting_line).each do |line|
  if line.include?("*blockers*"); at_blockers = true end

  if !at_blockers && line.include?("- ")
    @standup.add_ticket Ticket.new('', '', line.gsub("- ","").gsub("\n","")), 'previously'
  end

  if at_blockers && line.include?("- ")
    @standup.add_ticket Ticket.new('', '', line.gsub("- ","").gsub("\n","")), 'blockers'
  end
end

####################################################################
# Display Preview and ask for Edits else Save
preview_standup
edit_standup
loop do
  preview_standup
  puts "Would you like to Save[s][y][1]?"
  print ":> "
  answer = gets.chomp
  puts "\n"
  break if answer == 1 || answer == "y" || answer == "s" || answer == "q"
  edit_standup
end

# write to file
# f = File.open("/Users/kyleswartz/Documents/standup", "a")
# f.write(standup.preview)
# f.close
puts "SAVED!"