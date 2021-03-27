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
  base_url: "http://localhost:3000",
  dev_layout: true,
  template_helpers: [GabrielPoca.ViewHelpers],
  input: Path.join(Path.dirname(__DIR__), "priv/site"),
  output: Path.join(Path.dirname(__DIR__), "_site"),
  pass_through_copy: ["fonts", "music/files", "CNAME"],
  url_fingerprinting: false,
  preprocessors: %{
    ".svg" => [AddContent],
    ".jpg" => [GabrielPoca.BlogPath, Image],
    ".png" => [GabrielPoca.BlogPath, Image],
    ".xml" => [AddContent, EEx, GabrielPoca.XMLPreprocessor, OutputPath, Save],
    ".md" => [AddContent, EEx, Frontmatter, Markdown, GabrielPoca.BlogPath, AddLayout, Save]
  }

config :logger,
  level: :warn

import_config("#{Mix.env()}.exs")
