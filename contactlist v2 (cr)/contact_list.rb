require_relative 'contact'
require 'pp'
require 'pry'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  if ARGV.empty?
    puts "Here is a list of available commands:
    new (first, lastname, email) - Create a new contact
    list                         - List all contacts
    show (id)                    - Show a contact
    search (any search term)     - Search contacts"
  end

  case ARGV[0]

  when "new"
    Contact.create(ARGV[1].downcase, ARGV[2].downcase, ARGV[3])
  when "list"
    Contact.all
  when "show"
    Contact.find(ARGV[1].to_i)
  when "search"
    Contact.search(ARGV[1].downcase)
  when "update"
    id = ARGV[1].to_i
    puts Contact.find(id)
    puts "What would you like to change this contacts first name to?"
    new_first_name = STDIN.gets.chomp
    puts "What would you like to change this contacts last name to?"
    new_last_name = STDIN.gets.chomp
    puts "What would you like to change this contacts email to?"
    new_email = STDIN.gets.chomp
    Contact.save(id, new_first_name, new_last_name, new_email)
  when "destroy"
    Contact.destroy(ARGV[1].to_i)
  end


end
# puts Contact.all
# puts Contact.find(2)
# @contact1 = Contact.create("Ray", "siddiqui.ra@gmail.com")
# @contact2 = Contact.create("Sandy", "sandy.grewal@gmail.com")
# Contact.search("Sandy")