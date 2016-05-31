require 'csv'
require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact < ActiveRecord::Base

  @@conn = PG.connect(
  host: 'localhost',
  dbname: 'contactlistapp',
  user: 'development',
  password: 'development'
)

  attr_accessor :id, :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(id, name, email)
    # TODO: Assign parameter values to instance variables.
    @id = id
    @name = name
    @email = email
  end

  def to_array
    [id, name, email]
  end

  def to_s
    "#{id}: #{name}, #{email}"
  end
  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      @@conn.exec('SELECT * FROM contacts;') do |results|
        results.each do |contact|
          puts contact.inspect
      end
    end
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email

    def save(name, email)
      @@conn.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2)', [name, email])
    end

    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      save(name, email)
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      @@conn.exec_params('SELECT * FROM contacts WHERE ID = $1::int', [id])
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      @@conn.exec_params('SELECT name FROM contacts WHERE name LIKE $1', ["%#{term}%"])
    end

  end
end