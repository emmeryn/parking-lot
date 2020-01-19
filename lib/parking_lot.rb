require_relative 'slot'
require_relative 'car'
require_relative 'errors/errors'
require_relative 'commands/park_command'
require_relative 'commands/leave_command'
require_relative 'commands/status_command'
require_relative 'commands/reg_num_for_cars_with_colour_command'
require_relative 'commands/slot_num_for_cars_with_colour_command'

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

    def run_command(command, arguments)
      valid_commands = ['park',
                        'leave',
                        'status',
                        'registration_numbers_for_cars_with_colour',
                        'slot_numbers_for_cars_with_colour',
                        'slot_number_for_registration_number']

      if valid_commands.include? command
        public_send(command, *arguments)
      else
        puts 'Unrecognised command'
      end
    end

    def park(car_reg_num, car_colour)
      car = Car.new(car_reg_num, car_colour)
      ParkCommand.run(car, @slots)
    end

    def leave(slot_num)
      LeaveCommand.run(slot_num, @slots)
    end

    def status
      StatusCommand.run(@slots)
    end

    def registration_numbers_for_cars_with_colour(car_colour)
      RegNumForCarsWithColourCommand.run(car_colour, @slots)
    end

    def slot_numbers_for_cars_with_colour(car_colour)
      SlotNumForCarsWithColourCommand.run(car_colour, @slots)
    end

    def slot_number_for_registration_number(car_reg_num)

    end
  end

end