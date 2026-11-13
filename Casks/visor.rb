cask "visor" do
  version "0.4.0"
  sha256 "70d7c7f6fe91c3c5e21f559f4eb7f5fd2d5d9e992e5cca6f9c5fb68f78c31e0b"

  url "https://github.com/tailamphat/visor/releases/download/v#{version}/Visor-#{version}.zip"
  name "Visor"
  desc "Notch app for AI agent usage, approvals, clipboard and music"
  homepage "https://tailamphat.github.io/visor/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Visor.app"

  # Until releases are signed with a Developer ID and notarized, clear the
  # quarantine flag on install and upgrade (Homebrew removed --no-quarantine).
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Visor.app"]
  end

  # `brew upgrade` backs up the old app first and stops if it's gone (moved to
  # the Trash, or removed by security software). An empty stand-in lets the
  # upgrade or uninstall carry on and put the new app in its place.
  uninstall_preflight_steps do
    unless_path_exists "Visor.app", base: :appdir do
      mkdir_p "Visor.app", base: :appdir
    end
  end

  zap trash: [
    "~/Library/Application Support/Visor",
    "~/Library/Caches/io.github.tailamphat.visor",
    "~/Library/Preferences/io.github.tailamphat.visor.plist",
  ]

  # Until releases are signed with a Developer ID and notarized.
  caveats <<~EOS
    Visor is signed ad hoc, not notarized. This tap clears the quarantine flag
    on install and upgrade so macOS opens it.

    Disconnect your agents from Visor's menu before uninstalling, so the
    entries it added to Claude Code, Copilot CLI and Antigravity are removed.
  EOS
end
