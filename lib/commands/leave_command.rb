module AutomatedTicketingSystem
  class LeaveCommand < Command
    def self.run(slot_num, slots)
      slot_num = slot_num.to_i(10)
      raise InvalidSlotNumberError if slot_num <= 0 || slot_num > slots.length

      slot = slots.find { |s| s.id == slot_num }
      slot.unpark
      puts "Slot number #{slot_num} is free"
    end
  end
end