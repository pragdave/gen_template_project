# Project: a new mix template for projects

This is an alternative for `mix new`, creating what I feel is an
easier to read and maintain set of basic files.

You use it in combination with the `mix gen` mix task, which you will need
to install.

## New Project Template

        mix gen project «name» [ --into «path» ] [--sup[ervisor]] [--app[lication] «app»] [--module «module»]

## Install

This template is installed using the `template.install` mix task.
Projects are generated from it using the `mix gen` task.

So, before using templates for the first time, you need to install these two tasks:

    $ mix archive.install mix_templates
    $ mix archive.install mix_generator
    
Then you can install this template using

    $ mix template.install gen_template_project
    

## Use

To create a basic project, with no supervision and no application, run:

~~~
$ mix gen project «project_name»
~~~

`«project_name»` is both the name of the subdirectory that will hold the
project and the name that will be given to the application. This
affects entries in `mix.exs` as well as the names of the main
file in `lib/` and the skeleton test in `test/`. The application
module name will be the camelcase version of «name».

By default the subdirectory will be created under your
current directory; you can change this with the `--into` option:

~~~
$ mix gen project «project_name» --into some/other/dir
~~~

### Variants

To create a project with a top-level supervisor contained in an
application callback, use the `--sup` (or `--supervisor`) option. 

~~~
$ mix gen project «project_name» --sup
~~~

The application's `start` function is created in
`lib/«name»/application.ex`, along with a basic supervisor.

You can change the name used for the application:

~~~
$ mix gen project «project_name» --app[lication] «app»
~~~

The original «project_name» parameter will be the
name used for the directory, and «app» will be used when
creating file names in that directory and when customizing the
file contents.

Finally, you can override the name used for the application module:


~~~
$ mix gen project «project_name» `--module «Module»`
~~~

«Module» must be a valid Elixir module name or alias.


## Background

You probably use `mix new` and/or `mix phoenix.new` to create new Elixir
projects. 

I never really liked the code these generators created. The layout made things
hard to read, and even harder to change. For example, the `mix.exs`
file looked like this:

~~~ elixir
defmodule Myapp.Mixfile do
  use Mix.Project

  def project do
    [app: :myapp,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end
end
~~~

Let's look at a couple of problems.

The various lists are written in a really compact form:

~~~ elixir
[app: :myapp,
 version: "0.1.0",
 elixir: "~> 1.4",
 build_embedded: Mix.env == :prod,
 start_permanent: Mix.env == :prod,
 deps: deps()]
~~~

The indention is a unconventional single space, the entries are in an
apparently random order, and the layout makes it hard to distinguish
keys from values.

So, as a first iteration, I'd change this to:

~~~ elixir
[
  app:     :myapp,
  version: "0.1.0",
  deps:    deps(),
  elixir:  "~> 1.4",
  build_embedded:  Mix.env == :prod,
  start_permanent: Mix.env == :prod,
]
~~~

This moves the most commonly changed things to the top and aligns the
values. It also has the list ending with a comma. This makes no
difference to the internal representation of the list, but makes it a
lot easier to change the order of entries and add new lines.

Next, let's remove the duplication:

~~~ elixir
in_production = Mix.env == :prod
[
  app:     :myapp,
  version: "0.1.0",
  deps:    deps(),
  elixir:  "~> 1.4",
  build_embedded:  in_production,
  start_permanent: in_production,
]
~~~

All very well, but why are we exposing people to `build_embedded` and
`start_permanent` as if they were as important as the application name
and version? In fact, do you even know what they do? (I didn't until I
started looking into all this.)

So let's split out the important (and changeable) stuff, and give it
its own section in the mixfile.

~~~ elixir
defmodule Myapp.Mixfile do
  use Mix.Project

  @app     :myapp
  @version "0.1.0"
  
  @deps    []
  
  # ------------------------------------------------------------
  
  def project do
    in_production = Mix.env == :prod
    [
      app:     :app,
      version: @version,
      deps:    @deps,
      elixir:  "~> 1.4",
      build_embedded:  in_production,
      start_permanent: in_production,
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end
end
~~~

Notice we no longer have a `dep()` function, and all the associated noise.

Now let's think about the `application` function. Every application
out there has the Logger started. How many use it? I'm guessing less
than 50%. But we normally just leave it in because it seems like it's
needed. It also doesn't help that the comments don't really make it
clear what `extra_applications` is actually for.

So let's cut this down a little, and reformat the list.

~~~ elixir
# Type "mix help compile.app" for more information
def application do
  [
    # extra_applications: [:logger],
  ]
end
~~~

