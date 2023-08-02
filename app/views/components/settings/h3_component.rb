module Settings
  class H3Component < ApplicationComponent
    def template(&)
      h3(class: "mb-1 mt-1 text-500 font-bold text-md", &)
    end
  end
end
  