module FormHelper
    def input_is_empty?(input)
        input == nil || input == ""
    end
end