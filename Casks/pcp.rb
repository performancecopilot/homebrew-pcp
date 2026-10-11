cask "pcp" do
  version "7.2.2-1"
  sha256 "3f421ca6fc7541cf469d702e8a56929de116b9684f956a5f2ea07623d38617c2"

  url "https://github.com/performancecopilot/pcp/releases/download/#{version.sub(/-\d+$/, "")}/pcp-#{version}.dmg",
      verified: "github.com/performancecopilot/pcp/"
  name "Performance Co-Pilot"
  desc "System performance analysis toolkit"
  homepage "https://pcp.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  pkg "pcp-#{version}.pkg"

  uninstall script: {
    executable: "/usr/local/libexec/pcp/bin/uninstall-pcp",
    args:       ["--force"],
    sudo:       true,
  }

  caveats <<~EOS
    PCP has been installed with the following services:
      • io.pcp.pmcd    - Performance Metrics Collector Daemon
      • io.pcp.pmie    - Performance Metrics Inference Engine
      • io.pcp.pmlogger - Performance Metrics Logger
      • io.pcp.pmproxy  - Performance Metrics Proxy

    These services start automatically at system boot.

    Configuration: /etc/pcp/
    Data directory: /var/lib/pcp/
    Log files: /var/log/pcp/
  EOS
end
