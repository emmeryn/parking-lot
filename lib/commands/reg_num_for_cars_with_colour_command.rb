module AutomatedTicketingSystem
  class RegNumForCarsWithColourCommand < Command
    def self.run(car_colour, slots)
      reg_num_lines = []
      slots.each do |slot|
        next if slot.available?
        reg_num_lines.push(slot.car.reg_num) if slot.car.colour == car_colour
      end

      if reg_num_lines.empty?
        'Not found'
      else
        reg_num_lines.join(', ')
      end
    end
  end
end