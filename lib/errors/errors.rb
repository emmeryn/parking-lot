module AutomatedTicketingSystem

  class InvalidNumberOfSlotsError < StandardError
    def initialize(msg=nil)
      @message = msg
      super
    end

    def to_s
      @message || 'Invalid number of slots'
    end
  end

  class InvalidSlotNumberError < StandardError
    def initialize(msg=nil)
      @message = msg
      super
    end

    def to_s
      @message || 'Invalid slot number'
    end
  end

  class NoFreeSlotError < StandardError
    def initialize(msg=nil)
      @message = msg
      super
    end

    def to_s
      @message || 'Sorry, parking lot is full'
    end
  end

  class ExistingCarInSlotError < StandardError; end

  class SlotAlreadyEmptyError < StandardError
    attr_reader :slot_num
    def initialize(msg=nil, slot_num='')
      @message = msg
      @slot_num = slot_num
      super(msg)
    end

    def to_s
      @message || "No car in slot number #{@slot_num}"
    end
  end
end