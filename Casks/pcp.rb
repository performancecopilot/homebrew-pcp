cask "pcp" do
  version "7.0.4-1"
  sha256 "fba2444517bdafa0d66399456328a31509dedc83859bb81e6ee594246f3fd6ef"

  url "https://github.com/performancecopilot/pcp/releases/download/#{version.sub(/-\d+$/, '')}/pcp-#{version}.dmg",
      verified: "github.com/performancecopilot/pcp/"
  name "Performance Co-Pilot"
  desc "System performance analysis toolkit"
  homepage "https://pcp.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

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
