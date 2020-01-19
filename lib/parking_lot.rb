require_relative 'slot'
require_relative 'car'
require_relative 'errors/errors'
require_relative 'commands/command'
require_relative 'commands/park_command'
require_relative 'commands/leave_command'
require_relative 'commands/status_command'
require_relative 'commands/registration_numbers_for_cars_with_colour_command'
require_relative 'commands/slot_numbers_for_cars_with_colour_command'
require_relative 'commands/slot_number_for_registration_number_command'

module AutomatedTicketingSystem

  class ParkingLot
    attr_accessor :slots

    def initialize(num_of_slots)
      raise InvalidNumberOfSlotsError if num_of_slots.nil?

      @slots = []

      begin
        num_of_slots = num_of_slots.to_i
        raise InvalidNumberOfSlotsError if num_of_slots <= 0

        @slots = Array.new(num_of_slots)
        @slots.fill { |idx| Slot.new((idx + 1).to_s) }
        puts "Created a parking lot with #{num_of_slots} slots"
      end
    end

    def run_command(command, arguments = nil)
      valid_commands = ['park',
                        'leave',
                        'status',
                        'registration_numbers_for_cars_with_colour',
                        'slot_numbers_for_cars_with_colour',
                        'slot_number_for_registration_number']

      if valid_commands.include? command
        module_klass = Object.const_get(AutomatedTicketingSystem.name)
        command_klass = "#{module_klass}::#{camelize("#{command}_command")}"
        command_message = Object.const_get(command_klass)
                                .public_send('run', @slots, *arguments)
        puts command_message
      else
        puts 'Unrecognised command'
      end
    end

    private

    def camelize(str)
      str.split('_').map(&:capitalize).join
    end
  end
end