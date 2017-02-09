# Due to OSX Sandboxing you will want to run "install" with "--no-sandbox"
#

class Grfosphor < Formula
  desc "gr-fosphor, gr-osmocom"
  homepage "http://sdr.osmocom.org/trac/wiki/fosphor"
  url "https://github.com/osmocom/gr-fosphor.git", :branch => "master"
  version "1"

  depends_on :xcode => "8.2"
  depends_on "swig" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python"
  depends_on "doxygen"
  depends_on "glfw"
  depends_on "cartr/qt4/qt"
  depends_on "cartr/qt4/pyqt"
  depends_on "qwt" # Our version that uses QT4, not the current QT5 version...
  depends_on "gnuradio"
  
  # These may be fixed with cmake flags, for now they conflict because incorect versions are detected
  conflicts_with "qt5"
  conflicts_with "qt@5.7"
  conflicts_with "qt@5.5"
  conflicts_with "pyqt5"

  resource "grosmosdr" do
      url "https://github.com/osmocom/gr-osmosdr.git", :branch => "master"
  end

  patch do
      url "http://www.digitalmunition.com/gr-fosphor_sierra.diff"
      sha256 "ad7c6a59aa86d3971b11b98b5aa7cf9f52bdfc8b3ba709212b2be0bc78b88b5e"
  end
        
  def install
    ENV.prepend_create_path "PATH", "/usr/local/texlive/2016/bin/x86_64-darwin/"
    ENV["CMAKE_PREFIX_PATH"] = "$CMAKE_PREFIX_PATH:/usr/local/Cellar/qwt/6.1.3/:/usr/local/Cellar/qt/4.8.7_3/:/usr/local/Cellar/gnuradio/3.7.9.1_3"
    ENV["MAKEFLAGS"] = "-j8"

    resource("grosmosdr").stage do
      system  "pwd"

      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DPYTHON_LIBRARY=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/Python
        -DPYTHON_EXECUTABLE=/usr/local/Cellar/python/2.7.13/bin/python
        -DPYTHON_INCLUDE_DIR=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/Headers
        -DGR_PYTHON_DIR=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/
      ]
        
      mkdir "build" do
          system "cmake", "..", *args
          system "make"
          system "make", "install"
      end
    end
    
    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DPYTHON_LIBRARY=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/Python
      -DPYTHON_EXECUTABLE=/usr/local/Cellar/python/2.7.13/bin/python
      -DPYTHON_INCLUDE_DIR=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/Headers
      -DGR_PYTHON_DIR=/usr/local/Cellar/python/2.7.13/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/
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
