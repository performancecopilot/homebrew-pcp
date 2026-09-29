cask "pcp" do
  version "7.2.1-1"
  sha256 "2f1d404fbb2c1f56380ac8efe84955878a8cf02ca3d6c4a66abf479e0a37579f"

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
