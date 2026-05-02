class SpiceVdagent < Formula
  desc "SPICE guest agent for macOS (built from UTM vd_agent)"
  homepage "https://github.com/utmapp/vd_agent"
  url "https://github.com/utmapp/vd_agent/archive/refs/tags/spice-vdagent-0.22.1-macOS.tar.gz"
  sha256 "1898290b283de9f1c4d2dfd9e785f85d9170b6e44ba7b9e3ba8cdd340279399c"
  license "GPL-3.0-or-later"

  depends_on "glib" => :build
  depends_on "pkg-config" => :build

  bottle do
    root_url "https://github.com/proxmox-mac-guest/spice-vdagent/releases/download/spice-vdagent-0.22.1-1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0149fb71c187190584f84c248148389ea66085b7f5d0787b01911eb0fc406eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "283b6ce34652ca861fd91e41b3315cc9cb0ee6d339a50a3d54b1277a246265b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5545a06c778e06f94dcb8a1f6ee422fb43c256acfafa789f14ade1f03641e110"
    sha256 cellar: :any_skip_relocation, sequoia: "6827417e05b070c3816047c54f232aadf1b698141a8454470b90096c410fe2e7"
    sha256 cellar: :any_skip_relocation, sonoma: "187eade16133b87044b029a8c1a9c2461d643a82248c0da4c9b843fd6dd46c6d"
    sha256 cellar: :any_skip_relocation, tahoe: "9c255004c8ee3f6f931f1831635f959fc7da00fb560f1dc517fcd08bde54d349"
  end
