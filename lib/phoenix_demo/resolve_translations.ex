defmodule PhoenixDemo.ResolveTranslations do
  alias PhoenixDemo.Schemas.TextContent

  def resolve_text_content(%TextContent{} = text_content, locale) do
    if Map.has_key?(text_content, :translations) && is_list(text_content.translations) &&
         text_content.translations != [] do
      translation =
        Enum.find(text_content.translations, text_content.original_text, fn translation ->
          translation.language.code == locale
        end)

      # Determine if the translation map is found or not
      case translation do
        %{} = translation -> Map.get(translation, :translated_text, text_content.original_text)
        # Other will be the default set in the previous Enum.find
        other -> other
      end
    else
      text_content.original_text
    end
  end

  def resolve_text_content(any, _locale) do
    any
  end
end
