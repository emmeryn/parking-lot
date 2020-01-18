module AutomatedTicketingSystem

  class ParkingLot

    attr_accessor :slots

    def initialize(num_of_slots)
      @slots = []

      begin
        num_of_slots = Integer(num_of_slots)
        @slots = Array.new(num_of_slots)
        puts "Created a parking lot with #{num_of_slots} slots"
      rescue StandardError
        raise 'Invalid number of slots'
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

    def park(veh_reg_num, veh_colour)

    end

    def leave(slot_num)

    end

    def status

    end

    def registration_numbers_for_cars_with_colour(veh_colour)

    end

    def slot_numbers_for_cars_with_colour(veh_colour)

    end

    def slot_number_for_registration_number(veh_reg_num)

    end
  end

end