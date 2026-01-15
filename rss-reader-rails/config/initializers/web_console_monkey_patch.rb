module WebConsole
  class WhinyRequest < SimpleDelegator
    def permitted?
      Rails.env.development?
    end
  end
end
