# Dotfiles

macOS development setup for Zsh, Ghostty, Starship, Git, SSH, Zed, and Atuin. Homebrew Bundle installs tools and GNU Stow links the configs.

## Set up a Mac

```bash
git clone https://github.com/Stringsaeed/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
./install.sh
```

The installer works from any checkout path. If it starts the Xcode Command Line Tools installer, rerun it after that installation finishes.

The full installer also runs `./setup-fonts.sh`. You can run it separately to install Paper Mono through Homebrew when the font is missing. It recognizes the official variable and regular font files in the user and system font directories.

On an existing Mac with Stow installed, run `./install.sh --dry-run` first. Back up conflicting files or old links individually, then use `./install.sh --link-only` to link configs with your existing tools. Stow leaves conflicting paths in place and reports them. Keep application directories in place so state such as Zed conversations stays with the app.

## Optional bundles

| Bundle | Includes |
| --- | --- |
| `brewfiles/Brewfile.agents` | ChatGPT with Codex, Codex CLI, Claude, Claude Code, OpenCode CLI and desktop, Cursor, T3 Code, and Grok Bot |
| `brewfiles/Brewfile.mobile` | Ruby 3.3, CocoaPods, Fastlane, Maestro, Android Studio, and Zulu 17 |
| `brewfiles/Brewfile.backend` | Colima, Docker, LazyDocker, and Supabase |
| `brewfiles/Brewfile.vscode` | VS Code and editor extensions |
| `brewfiles/Brewfile.desktop` | Espanso, Fork, Hex, and Spotify |

Install a bundle with `brew bundle --file=brewfiles/Brewfile.agents`, substituting the profile you want. On a Mac where these apps are already installed, keep using their existing install and update channels.

## Language runtimes

| Work | Setup |
| --- | --- |
| TypeScript and JavaScript | Open a new Zsh shell and run `nvm install 24` for the same Node major as this Mac. Zsh switches versions for projects with an `.nvmrc`. Use the npm bundled with Node and install TypeScript in the project. |
| Vite+ and pnpm | Install the global `vp` CLI, then use `vp env off node` to prefer NVM's Node and `vp env on pnpm` for Vite+'s pnpm management. Pin the project's package manager in `package.json` and use the project's own install command. [Vite+ setup](https://viteplus.dev/guide/) · [Environment modes](https://viteplus.dev/guide/env#environment-modes) |
| Bun | The core bundle installs Bun. Use it for projects that select Bun or require its runtime. |
| Python and agent tools | The core bundle installs `uv`. Use `uv sync` and `uv run` in projects with a `pyproject.toml`. Use `uvx` for standalone Python tools and `uv python install` with the version a project requires. [uv Python guide](https://docs.astral.sh/uv/guides/install-python/) |
| Rust | Install `rustup` once. Keep Rust and Cargo on PATH through its shell setup and use `rust-toolchain.toml` for project-specific versions. [Rust installer](https://rust-lang.org/tools/install/) |
| React Native and iOS | Install the mobile bundle, select full Xcode for iOS, and set up the Android SDK through Android Studio. Use the project's Ruby version, `Gemfile`, and `Gemfile.lock` for CocoaPods and Fastlane. Run `bundle install` and `bundle exec pod install` when the project uses Bundler. Existing standalone Maestro installs can use their local PATH entry. |

When an agent launches a project, use that project's checked-in runtime pins and commands. If a tool resolves differently in an agent terminal, check `type -a node npm pnpm bun uv ruby cargo` there and compare it with your regular terminal.

## Agent setup

- Sign in separately to the agents you use. Keep auth, MCP credentials, session history, and machine-level approval settings in the app's local storage. Track project instructions, build commands, and dependency pins in each project. [Codex CLI](https://learn.chatgpt.com/docs/cli) · [Grok Bot](https://x.ai/bot)
- T3 Code can orchestrate the installed agent CLIs. Install the separate Cursor CLI if you want `cursor-agent` in terminal workflows. [T3 Code](https://t3.codes/) · [Cursor CLI](https://prod.cursor.com/help/integrations/cli)
- Install Rex from your Superlogical beta account. Its **Install Rex for Agents** command can add the Rex skill and integrations after your agent CLIs are installed. [Rex installation](https://www.superlogical.com/rex/docs/installation) · [Agent integration](https://www.superlogical.com/rex/docs/automate/agent-skill)

## Local settings

- `~/.zprofile.local` for login environment and machine-specific paths
- `~/.zshrc.local` for interactive integrations and local overrides
- `~/.gitconfig.local` for your identity, signing configuration, and credential helpers
- `~/.ssh/config.local` for SSH hosts, identity paths, and includes
- OS credential stores or private configuration files for secrets

Edit the managed files through the checkout or their home directory symlinks. Review changes from the checkout before committing.
