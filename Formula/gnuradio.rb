# Be sure to clean the cache before running this formula
# In particular ~/Library/Caches/Homebrew/gnuradio--git
#
# Due to OSX Sandboxing you will want to run "install" with "--no-sandbox"
#
# We would need the following changes inside sandbox.rb which violates Brew standards, so the above serves as a less destructive workaround
#
# allow_write_path "/usr/local/Cellar/uhd/003.010.000.000_2/share/uhd/images"
# allow_write_path "/usr/local/lib/python2.7/site-packages"
# allow_write_path "/usr/local"
#

class Gnuradio < Formula
  desc "macOS Sierra, GNURadio 3.7.x, QT4, wxgui, zeromq, gnuradio-companion, gr-fosphor, gr-osmocom"
  homepage "http://gnuradio.org/redmine/projects/gnuradio/wiki/MacInstall#From-Source"
  url "https://github.com/gnuradio/gnuradio.git", :branch => "master"
  version "3.7.9.1"
  revision 3

  depends_on :xcode => "8.2"
  depends_on "swig" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "jack"
  depends_on "portaudio"
  depends_on "wxpython"
  depends_on "libunwind-headers"
  depends_on "python"
  depends_on "doxygen"
  depends_on "fftw"
  depends_on "uhd"
  depends_on "glfw"
  depends_on "zeromq"
  depends_on "cppunit"
  depends_on "gsl"
  depends_on "sdl"
  depends_on "log4cpp"
  depends_on "pygtk"
  depends_on "cartr/qt4/qt"
  depends_on "cartr/qt4/pyqt"
  depends_on "qwt" # Our version that uses QT4, not the current QT5 version...
  depends_on "wget"
  
  # These may be fixed with cmake flags, for now they conflict because incorect versions are detected
  conflicts_with "qt5"
  conflicts_with "qt@5.7"
  conflicts_with "qt@5.5"
  conflicts_with "pyqt5"

  system "brew tap cartr/qt4"
  system "brew install cartr/qt4/qt cartr/qt4/pyqt"
  
  if !File.exist? "/usr/local/texlive/2016/bin/x86_64-darwin/"
    system "brew install Caskroom/cask/mactex"
  end

  system "wget https://raw.githubusercontent.com/zeromq/cppzmq/master/zmq.hpp -O /usr/local/Cellar/zeromq/4.2.1/include/zmq.hpp"

  def install
    ENV.prepend_create_path "PATH", "/usr/local/texlive/2016/bin/x86_64-darwin/"
    ENV["CMAKE_PREFIX_PATH"] = "$CMAKE_PREFIX_PATH:/usr/local/Cellar/qwt/6.1.3/:/usr/local/Cellar/qt/4.8.7_3/:/usr/local/Cellar/zeromq/4.2.1/"
    ENV["ZeroMQ_ROOT_DIR"] = "/usr/local/Cellar/zeromq/4.2.1/"
    ENV["PC_ZEROMQ_INCLUDE_DIR"] = "/usr/local/Cellar/zeromq/4.2.1/include/"
    ENV["ZEROMQ_INCLUDE_DIRS"] = "/usr/local/Cellar/zeromq/4.2.1/include/"
    ENV["MAKEFLAGS"] = "-j8"

    system "git", "submodule", "init"
    system "git", "submodule", "update"

    # Make sure you have permission! run 'sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local/'
    system "pip", "install", "--upgrade", "pip", "setuptools"
    system "pip", "install", "requests", "mako", "pyopengl", "Cheetah", "lxml", "matplotlib", "numpy", "scipy", "pyzmq", "docutils", "sphinx", "--ignore-installed", "six"
    system "/usr/local/Cellar/uhd/003.010.000.000_2/lib/uhd/utils/uhd_images_downloader.py" # Pull firmware for SDR

    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DENABLE_GR_ZEROMQ=ON
      -DENABLE_DOXYGEN=OFF
      -DPYTHON_LIBRARY=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/Python
      -DPYTHON_EXECUTABLE=/usr/local/Cellar/python/2.7.13/bin/python
      -DPYTHON_INCLUDE_DIR=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/Headers
      -DGR_PYTHON_DIR=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/
      -DQWT_INCLUDE_DIRS=/usr/local/Cellar/qwt/6.1.3/lib/qwt.framework/Versions/6/Headers/
      -DQWT_LIBRARIES=/usr/local/Cellar/qwt/6.1.3/lib/qwt.framework/qwt
      -DZEROMQ_INCLUDE_DIRS=/usr/local/Cellar/zeromq/4.2.1/include/
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
    
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-companion").chomp
  end

  # How can clean up cache files in ~/Library/Caches/Homebrew/ ?

end
