module Settings
  class ControlRowComponent < ApplicationComponent

    slots :icon, :title, :description, :control, :second_control, :third_control, :fourth_control, :fifth_control

    def template
      div class: "py-4 flex items-center gap-4 group group-data-[capsule=true]:px-4" do
        if @icon
          div class: "inset-y-0 self-stretch shrink-0 flex items-center", &@icon
        end
        div class: "grow overflow-hidden" do
          div class: "text-600 text-sm", &@title
          if @description
            div class: "text-500 text-sm max-w-[500px]", &@description
          end
        end
        div class: "items-center flex gap-4", &@control
        div class: "items-center flex gap-4", &@second_control
        div class: "items-center flex gap-4", &@third_control
        div class: "items-center flex gap-4", &@fourth_control
        div class: "items-center flex gap-4", &@fifth_control
      end
    end
  end
end
