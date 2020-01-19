require_relative 'parking_lot'

module AutomatedTicketingSystem

  class CommandLine
    def initialize
      @parking_lot = nil

      ARGF.each_line do |line|
        input_line = line.split(' ')
        command = input_line.shift

        handle_command(command, input_line)
      end
    end

    private

    def handle_command(command, arguments)
      case command
      when 'create_parking_lot' then
        unless @parking_lot.nil?
          puts 'Parking lot already exists'
          return
        end
        num_of_slots = arguments.first
        create_parking_lot(num_of_slots)
      when 'exit' then
        exit
      else
        run_command(command, arguments)
      end
    end

    def create_parking_lot(num_of_slots)
      @parking_lot = AutomatedTicketingSystem::ParkingLot.new(num_of_slots)
    rescue StandardError => e
      puts e
    end

    def run_command(command, arguments)
      if @parking_lot.nil?
        puts 'Parking lot doesn\'t exist, please create one first'
      else
        @parking_lot.run_command(command, arguments)
      end
    rescue StandardError => e
      puts e
    end
  end

end