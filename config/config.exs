import Config

alias Still.Preprocessor.{
  Frontmatter,
  EEx,
  Markdown,
  OutputPath,
  AddLayout,
  Save,
  AddContent,
  Image
}

config :still,
  dev_layout: true,
  template_helpers: [GabrielPoca.ViewHelpers, Still.Snowpack.TemplateHelpers],
  input: Path.join(Path.dirname(__DIR__), "priv/site"),
  output: Path.join(Path.dirname(__DIR__), "_site"),
  pass_through_copy: ["fonts", "music/files", "CNAME"],
  url_fingerprinting: false,
  preprocessors: %{
    ".svg" => [AddContent],
    ~r/\.jpe?g/ => [GabrielPoca.BlogPath, Image],
    ".png" => [GabrielPoca.BlogPath, Image],
    ".xml" => [AddContent, EEx, GabrielPoca.XMLPreprocessor, OutputPath, Save],
    ".html" => [AddContent, EEx, Frontmatter, OutputPath, AddLayout, Save],
    ".eex" => [AddContent, EEx, Frontmatter, OutputPath, AddLayout, Save],
    ".md" => [AddContent, EEx, Frontmatter, Markdown, GabrielPoca.BlogPath, AddLayout, Save]
  }

config :still_snowpack,
  port: 3003,
  input: Path.join(Path.dirname(__DIR__), "assets"),
  output: Path.join([Path.dirname(__DIR__), "_site", "assets"])

config :logger,
  level: :debug

import_config("#{Mix.env()}.exs")
