defmodule Mix.Gen.Template.Project do

  @moduledoc File.read!("README.md")
  
  use MixTemplates,
    name:       :project,
    short_desc: "Simple template for projects (with optional app and supervision)",
    source_dir: "../template"
  
end
