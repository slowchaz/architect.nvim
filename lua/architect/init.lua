local M = {}
local curl = require('plenary.curl')

function M.setup()
    vim.keymap.set("n", "<Leader>h", function()
        print("Hello from the Architect!")
    end)

    vim.api.nvim_set_keymap("v", "<leader>g", ':lua require("architect").get_selected_text()<CR>', { noremap = true, silent = true })
end

function M.get_selected_text()
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')

    local bufnr = 0
    local start_row, start_col = start_pos[1] - 1, start_pos[2]
    local end_row, end_col = end_pos[1] - 1, end_pos[2]

    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    if #lines == 0 then
        vim.notify("No text selected", vim.log.levels.WARN)
        return
    end

    -- TODO: Support Visual Block Mode
    if #lines == 1 then
        lines[1] = lines[1]:sub(start_col + 1, end_col + 1)
    else
        lines[1] = lines[1]:sub(start_col + 1)
        lines[#lines] = lines[#lines]:sub(1, end_col + 1)
    end

    local selected_text = table.concat(lines, "\n")


    local response = M.send_prompt(selected_text, "groq")
    M.write_text(response, end_row + 1)
end

function M.send_prompt(prompt, endpoint)
    local system_prompt = "You are a programming assistant. Prioritize giving concise responses. Give the most performant and efficient solutions when able."
    local url
    local auth_header
    local model_name

    if endpoint == "openai" then
        url = "https://api.openai.com/v1/char/completions"
        auth_header = "Bearer " .. vim.env.OPENAI_KEY
        model_name = "gpt-3.5-turbo"
    elseif endpoint == "groq" then
        url = "https://api.groq.com/openai/v1/chat/completions"
        auth_header = "Bearer " .. vim.env.GROQ_KEY
        model_name = "llama3-70b-8192"
    else
        print("Invalid endpoint")
    end

    local response = curl.post(url, {
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = auth_header 
        },
        body = vim.fn.json_encode({ 
            model = model_name,
            messages = {
                { role = "system", content = system_prompt }, 
                { role = "user", content = prompt }
            },
            temperature = 0.7
        })
    })
    
    if response.status == 200 then
        local parsed_body = vim.fn.json_decode(response.body)
        local content = parsed_body.choices[1].message.content
        return content
    else
        print("Request failed with status: " .. response.status)
        print("Error: " .. response.body)
    end
end

function M.write_text(response, insert_line)
    local bufnr = 0
    local response_lines = vim.split(response, "\n")
    vim.api.nvim_buf_set_lines(bufnr, insert_line, insert_line, false, response_lines)
end

return M
