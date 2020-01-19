module AutomatedTicketingSystem
  class StatusCommand
    def self.run(slots)
      header_line = 'Slot No.    Registration No    Colour'
      data_lines = generate_status_data(slots)
      if data_lines.empty?
        puts 'No cars in parking lot'
      else
        output_lines = [header_line].concat(data_lines)

        output_lines.each do |line|
          puts line
        end
      end
    end

    def self.generate_status_data(slots)
      data_lines = []
      slots.each do |slot|
        next if slot.available?
        slot_num = slot.id.to_s.ljust(12, ' ')
        reg_num = slot.car.reg_num.to_s.ljust(19, ' ')
        colour = slot.car.colour.to_s

        data_lines.push "#{slot_num}#{reg_num}#{colour}"
      end
      data_lines
    end
  end
end