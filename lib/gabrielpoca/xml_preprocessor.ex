defmodule GabrielPoca.XMLPreprocessor do
  use Still.Preprocessor

  @impl true
  def extension(_) do
    ".xml"
  end

  @impl true
  def render(file) do
    file
  end
end
