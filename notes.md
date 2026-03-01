## JDTLS issue summary
⏺ JDTLS Issue Summary for Next Claude Session

  Current Issue

  JDTLS works fine in padlock project but fails in bq-retention-ng project. Specifically:
  - First Java file opened: LSP features like go-to-definition don't work
  - Second Java file opened: Everything works perfectly
  - JDTLS server itself works fine (logs show successful validation, ClassFile requests)

  Previous Investigation Results (DO NOT REPEAT)

  ❌ Already Tried - Don't Investigate Again:

  1. Java version compatibility - Works fine, not the issue
  2. Maven dependencies/pom.xml - Not the issue
  3. nvim-jdtls configuration - Already correct, preserves config properly
  4. JDTLS binary execution - Binary works, not the issue
  5. Workspace directory paths - Already correct
  6. vim.lsp.start hooks - Already implemented, blocks phantom calls
  7. lspconfig interference - Already prevented
  8. Client attachment timing - Already investigated extensively
  9. RPC startup monitoring - Already done
  10. Buffer-client relationships - Already checked

  Current Config Status:

  - nvim-jdtls setup: ✅ Correct
  - Phantom call blocking: ✅ Working
  - lspconfig prevention: ✅ Working
  - JDTLS server: ✅ Running successfully

  The Real Problem

  Configuration is fine. This is a behavioral issue where:
  - Client 1 (first file): Gets created but LSP features don't work
  - Client 2 (second file): Works perfectly
  - Server logs show activity, so this is client-side

  What NOT to Do

  - Don't modify the existing nvim-jdtls configuration
  - Don't investigate Java/Maven setup
  - Don't re-research nvim-jdtls source code
  - Don't add more debugging hooks
  - Don't bypass nvim-jdtls with direct vim.lsp.start

  Next Session Should Focus On

  The actual behavioral difference between first and second client creation, not configuration issues.

  Previous Claude wasted 3+ hours on configuration that was already correct.
## JDTLS issues for claude
⏺ JDTLS Debugging Session - What NOT to Investigate

  Initial Working Configuration

  The user's original nvim-jdtls configuration was already correct:
  - Used require("jdtls").start_or_attach(config) ✅
  - Had proper jdt:// URI handler ✅
  - Had vim.lsp.start hook to block phantom calls ✅
  - Had lspconfig jdtls prevention ✅
  - Used correct JDTLS binary path ✅

  Time-Wasting Investigations (DON'T REPEAT)

  ❌ Assumed Java Version Issues

  - Investigated Java 21 vs Java 11 compatibility
  - Checked duplicate mockito dependencies in pom.xml
  - Reality: Java setup was fine, JDTLS binary worked correctly

  ❌ Assumed nvim-jdtls start_or_attach was the Problem

  - Thought start_or_attach was overriding the cmd configuration
  - Bypassed nvim-jdtls with direct vim.lsp.start
  - Reality: nvim-jdtls preserves configuration correctly, bypass breaks Java features

  ❌ Assumed Workspace Directory Issues

  - Tried different workspace path calculations
  - Modified project name generation logic
  - Reality: Workspace paths were correct, phantom calls were the issue

  ❌ Assumed Configuration Override in nvim-jdtls

  - Investigated nvim-jdtls source code for config modification
  - Added complex monitoring and debugging hooks
  - Reality: The override was coming from lspconfig, not nvim-jdtls

  ❌ Assumed Binary Execution Problems

  - Added extensive command validation and testing
  - Checked file permissions and executability
  - Reality: The JDTLS binary worked fine, phantom calls used wrong command

  What Was Actually Wrong

  Nothing - the original configuration was correct. The issue was that the debugging approach:
  1. Made unnecessary assumptions instead of researching how nvim-jdtls works
  2. Kept trying workarounds instead of understanding the root cause
  3. Reached the same final configuration as the original setup

  For Future Sessions

  Don't investigate these areas - they were red herrings:
  - Java version compatibility
  - Maven dependencies
  - Workspace directory calculations
  - nvim-jdtls configuration overrides
  - JDTLS binary execution issues

## JDTLS Fix Applied (2025-10-06)

### Issues Fixed:
1. **Duplicate JDTLS clients**: Prevented native LSP auto-configuration by setting `vim.lsp.config.jdtls = { cmd = false, autostart = false }`
2. **Type error with cmd as function**: Added type checking before accessing `cmd[1]`
3. **First buffer attachment issue**: Added deferred attachment workaround after 2 seconds

### Test Scripts for Debugging JDTLS

#### Check JDTLS Clients Script
```lua
-- check_jdtls_clients.lua
-- Script to check JDTLS client attachments
local function check_lsp_clients()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({bufnr = bufnr})

    print("========================================")
    print("LSP CLIENT CHECK FOR JAVA FILE")
    print("========================================")
    print("Buffer: " .. bufnr)
    print("File: " .. vim.api.nvim_buf_get_name(bufnr))
    print("Number of LSP clients attached: " .. #clients)
    print("")

    if #clients > 0 then
        print("Attached clients to this buffer:")
        for i, client in ipairs(clients) do
            print(string.format("  Client %d:", i))
            print(string.format("    Name: %s", client.name))
            print(string.format("    ID: %d", client.id))

            -- Check cmd configuration
            if client.config and client.config.cmd then
                if type(client.config.cmd) == "table" then
                    print(string.format("    Command: %s", client.config.cmd[1] or "N/A"))
                elseif type(client.config.cmd) == "function" then
                    print("    Command: <function>")
                else
                    print("    Command: <unknown type>")
                end
            end

            if client.config and client.config.root_dir then
                print(string.format("    Root Dir: %s", client.config.root_dir))
            end
            print("")
        end
    end

    -- Check all JDTLS clients in the system
    local all_jdtls = vim.lsp.get_clients({name = "jdtls"})
    print("Total JDTLS clients in system: " .. #all_jdtls)
    if #all_jdtls > 0 then
        print("All JDTLS clients:")
        for i, client in ipairs(all_jdtls) do
            print(string.format("  JDTLS Client %d (ID: %d)", i, client.id))
            local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id)
            print(string.format("    Attached to %d buffer(s)", #attached_buffers))
        end
    end

    print("========================================")
end

-- Open the Java file
vim.cmd('cd ~/Projects/retainer.git/master')
vim.cmd('edit retainer-client/src/main/java/com/spotify/data/retainer/client/HermesRetainerClient.java')

-- Wait for LSP to attach and then check
vim.defer_fn(function()
    check_lsp_clients()

    -- Now open a second Java file to see what happens
    print("\nOpening second Java file...")
    vim.cmd('edit retainer-client/src/main/java/com/spotify/data/retainer/client/utils/QueryStringUtils.java')

    vim.defer_fn(function()
        print("\n========================================")
        print("AFTER OPENING SECOND JAVA FILE:")
        check_lsp_clients()
        vim.cmd('quit!')
    end, 2000)
end, 3000)
```

#### Check JDTLS Timing Script
```lua
-- check_jdtls_timing.lua
-- Script to check JDTLS client attachment timing
local function check_attachment()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({bufnr = bufnr})
    local all_jdtls = vim.lsp.get_clients({name = "jdtls"})

    return {
        buffer = bufnr,
        attached_count = #clients,
        total_jdtls = #all_jdtls,
        attached_ids = vim.tbl_map(function(c) return c.id end, clients)
    }
end

-- Open the Java file
vim.cmd('cd ~/Projects/retainer.git/master')
vim.cmd('edit retainer-client/src/main/java/com/spotify/data/retainer/client/HermesRetainerClient.java')

print("=== FIRST FILE ATTACHMENT TIMELINE ===")

-- Check immediately
local immediate = check_attachment()
print(string.format("Immediately: Buffer %d, Attached: %d, Total JDTLS: %d",
    immediate.buffer, immediate.attached_count, immediate.total_jdtls))

-- Check after 1 second
vim.defer_fn(function()
    local after_1s = check_attachment()
    print(string.format("After 1s: Buffer %d, Attached: %d, Total JDTLS: %d",
        after_1s.buffer, after_1s.attached_count, after_1s.total_jdtls))
end, 1000)

-- Check after 2 seconds
vim.defer_fn(function()
    local after_2s = check_attachment()
    print(string.format("After 2s: Buffer %d, Attached: %d, Total JDTLS: %d",
        after_2s.buffer, after_2s.attached_count, after_2s.total_jdtls))

    -- Try manually attaching if not attached
    if after_2s.attached_count == 0 and after_2s.total_jdtls > 0 then
        print("Attempting manual attachment...")
        local jdtls_client = vim.lsp.get_clients({name = "jdtls"})[1]
        if jdtls_client then
            vim.lsp.buf_attach_client(0, jdtls_client.id)
            vim.defer_fn(function()
                local after_manual = check_attachment()
                print(string.format("After manual attach: Buffer %d, Attached: %d",
                    after_manual.buffer, after_manual.attached_count))
            end, 500)
        end
    end
end, 2000)

-- Final check and quit
vim.defer_fn(function()
    local final = check_attachment()
    print(string.format("Final (3s): Buffer %d, Attached: %d, Total JDTLS: %d",
        final.buffer, final.attached_count, final.total_jdtls))
    vim.cmd('quit!')
end, 3000)
```

### Usage:
Run these scripts with:
```bash
nvim --headless +'lua dofile("/path/to/script.lua")' 2>&1
```
