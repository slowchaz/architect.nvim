# Architect.nvim

Architect.nvim is a custom Neovim plugin designed to streamline your coding workflow by integrating GPT-based assistance directly into your editor. Architect waits for your request and avoids the frustrating aspects of something like GitHub Copilot. Current API integration support includes Groq and OpenAI.

## Installation

Use your preferred plugin manager to install Architect.nvim. For example, with Lazy.nvim:

```lua
{
    'slowchaz/architect.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
}
```

## Key Mappings

- **Visual Mode**: Press `<Leader>g` to send the selected text to the GPT model and insert the response below the selected text.

## Usage

### Get Selected Text

In visual mode, select the text you want to process and press `<Leader>g`. The plugin sends the selected text to a GPT model and inserts the response below the selected text.

## Configuration

The plugin uses different endpoints and models depending on the environment variables set in your system.

- `OPENAI_KEY`: Your API key for OpenAI.
- `GROQ_KEY`: Your API key for GROQ.

By default, the plugin sends requests to the GROQ endpoint. You can change the endpoint by modifying the `get_selected_text` function.

## Example

Select a piece of code in visual mode and press `<Leader>g` to get a response from the GPT model. The response will be inserted directly below the selected text, providing insights or improvements based on the selected snippet.

## Notes

- Ensure you have the necessary API keys set in your shell's environment variables.
- The plugin currently supports visual mode selection and insertion of responses. Visual block mode is not yet supported.
