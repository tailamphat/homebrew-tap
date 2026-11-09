cask "visor" do
  version "0.1.0"
  sha256 "ba63719f2a899da3b259a3eb694b358d177c826716b82fa02e256865824e1a42"

  url "https://github.com/tailamphat/visor/releases/download/v#{version}/Visor-#{version}.zip"
  name "Visor"
  desc "Notch app for AI agent usage, approvals, clipboard and music"
  homepage "https://github.com/tailamphat/visor"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Visor.app"

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
    Visor is signed ad hoc and not notarized. If macOS says it is damaged or
    will not open, clear the quarantine flag:
      xattr -dr com.apple.quarantine "#{appdir}/Visor.app"

    Disconnect your agents from Visor's menu before uninstalling, so the
    entries it added to Claude Code, Copilot CLI and Antigravity are removed.
  EOS
end
