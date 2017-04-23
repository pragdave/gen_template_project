defmodule Mix.Gen.Template.Project do

  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))

  use MixTemplates,
    name:       :project,
    short_desc: "Simple template for projects (with optional app and supervision)",
    source_dir: "../template",
    options:    [
      sup: [
        to:       :is_supervisor?,          
        default:  false,
        desc:     "creates a top-level supervisor, and adds the app to mix.exs"
      ],
      supervisor:  [ same_as: :sup ],

      app: [
        to:       :app,
        required: false,
        takes:    "app_name",
        desc:     "sets the application name to «app_name»"
      ],
      application: [ same_as: :app ],

      module: [
         to:        :project_name_camel_case,
         required:  false,
         takes:     "«project_name»",
         desc:      "sets the name of the module to «project_name»"
       ]
    ]


end
