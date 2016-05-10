require 'csv'
require 'pg'
require 'pp'


# Represents a person in an address book .
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @@conn = PG.connect(
    host: 'localhost',
    dbname: 'contacts',
    user: 'development',
    password: 'development'
    )

  attr_accessor :first_name, :last_name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(id = nil, first_name, last_name, email)
    # TODO: Assign parameter values to instance variables.
    @id = id
    @first_name = first_name
    @last_name = last_name
    @email = email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      @@conn.exec('SELECT * FROM contacts ORDER BY id;') do |contacts|
        contacts.map do |c|
          puts "#{c['id']}, #{c['first_name']}, #{c['last_name']}, #{c['email']}"
        end
      end
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(first_name, last_name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      @@conn.exec("INSERT INTO contacts (first_name, last_name, email) VALUES ($1, $2, $3) RETURNING id;", [first_name.downcase, last_name.downcase, email.downcase]) do |results|
          @id = results[0]["id"]
        end
      puts "Contact Created"
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.

      @@conn.exec("SELECT * FROM contacts WHERE id = $1::int;", [id]) do |results|
        results.map do |c|
            puts "This is the contact found:"
            puts "#{c['id']}, #{c['first_name']}, #{c['last_name']}, #{c['email']}"
          end
        end
      end
      
    # def finds_contact(id)

    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      results = @@conn.exec_params("SELECT * FROM contacts WHERE first_name LIKE '%#{term}%';")
          results.map do |c|
          puts "#{c['id']}, #{c['first_name']}, #{c['last_name']}, #{c['email']}"
      end
    end

    def update(id, new_first_name, new_last_name, new_email)
      @@conn.exec("UPDATE contacts SET first_name = $2, last_name = $3, email = $4 WHERE id = $1::int;", [id,new_first_name,new_last_name,new_email])
      puts "Contact updated"
    end

    def destroy(id)
      @@conn.exec("DELETE FROM contacts WHERE id = $1::int;", [id])
      puts "Contact Deleted"
    end

  end

end
