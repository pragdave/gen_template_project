defmodule <%= @project_name_camel_case %>.Mixfile do
  use Mix.Project

  @name    :<%= @project_name %>
  @version "0.1.0"

  @deps [
    # { :earmark, ">0.1.5" },                      # if in hex
    # { :ex_doc,  "1.2.3", only: [ :dev, :test ] }
    # { :my_app:  path: "../my_app" },
  ]
  
  # ------------------------------------------------------------
  
  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      deps:    @deps,
      elixir:  "~> 1.4",
      build_embedded:  in_production,
      start_permanent: in_production,
    ]
  end

  def application do
    [
<%= if @is_supervisor do %>
      mod: { <%= @project_name_camel_case %>.Application, [] },         # Entry point module and parameters
<% end %>
      extra_applications: [         # built-in apps that need starting    
        :logger
      ], 
    ]
  end

end
