import Config

alias Still.Image

alias Still.Preprocessor.{
  Frontmatter,
  EEx,
  Markdown,
  OutputPath,
  AddLayout,
  Save,
  AddContent
}

config :still, Still.Preprocessor.Markdown, use_responsive_images: true

config :still,
  domain: "http://localhost:3000",
  dev_layout: true,
  template_helpers: [GabrielPoca.ViewHelpers],
  input: Path.join(Path.dirname(__DIR__), "priv/site"),
  output: Path.join(Path.dirname(__DIR__), "_site"),
  pass_through_copy: ["fonts", "music/files", "CNAME", ~r/\.dmg/, "admin/config.yml"],
  url_fingerprinting: false,
  ignore_files: ["assets"],
  watchers: [
    npx: [
      "tailwindcss",
      "-o",
      "../global.css",
      "--watch",
      "-i",
      "global.css",
      cd: "priv/site/assets",
      env: [{"NODE_ENV", if(Mix.env() == :prod, do: "production", else: "development")}]
    ]
  ],
  preprocessors: %{
    ".svg" => [AddContent],
    ~r/\.jpe?g/ => [GabrielPoca.BlogPath, Image.Preprocessor],
    ".png" => [GabrielPoca.BlogPath, Image.Preprocessor],
    ".xml" => [AddContent, EEx, GabrielPoca.XMLPreprocessor, OutputPath, Save],
    ".html" => [AddContent, EEx, Frontmatter, OutputPath, AddLayout, Save],
    ".eex" => [AddContent, EEx, Frontmatter, OutputPath, AddLayout, Save],
    ".md" => [
      AddContent,
      EEx,
      Frontmatter,
      Markdown,
      GabrielPoca.BlogPath,
      GabrielPoca.Seo,
      AddLayout,
      Save
    ]
  }

import_config("#{Mix.env()}.exs")
