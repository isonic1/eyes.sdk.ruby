require 'applitools/selenium/visual_grid/emulation_base_info'
module Applitools
  module Selenium
    class ChromeEmulationInfo < EmulationBaseInfo
      module DEVICES
        IPhone4 = 'iPhone 4'.freeze
        IPhone5SE = 'iPhone 5/SE'.freeze
        IPhone678 = 'iPhone 6/7/8'.freeze
        IPhone678Plus = 'iPhone 6/7/8 Plus'.freeze
        IPhoneX = 'iPhone X'.freeze
        IPad = 'iPad'.freeze
        IPadPro = 'iPad Pro'.freeze
        BlackBerryZ30 = 'BlackBerry Z30'.freeze
        Nexus4 = 'Nexus 4'.freeze
        Nexus5 = 'Nexus 5'.freeze
        Nexus5X = 'Nexus 5X'.freeze
        Nexus6 = 'Nexus 6'.freeze
        Nexus6P = 'Nexus 6P'.freeze
        Pixel2 = 'Pixel 2'.freeze
        Pixel2XL = 'Pixel 2 XL'.freeze
        LGOptimusL70 = 'LG Optimus L70'.freeze
        NokiaN9 = 'Nokia N9'.freeze
        NokiaLumia520 = 'Nokia Lumia 520'.freeze
        MicrosoftLumia550 = 'Microsoft Lumia 550'.freeze
        MicrosoftLumia950 = 'Microsoft Lumia 950'.freeze
        GalaxyS3 = 'Galaxy S III'.freeze
        GalaxyS5 = 'Galaxy S5'.freeze
        KindleFireHDX = 'Kindle Fire HDX'.freeze
        IPadMini = 'iPad Mini'.freeze
        BlackberryPlayBook = 'Blackberry PlayBook'.freeze
        Nexus10 = 'Nexus 10'.freeze
        Nexus7 = 'Nexus 7'.freeze
        GalaxyNote3 = 'Galaxy Note 3'.freeze
        GalaxyNote2 = 'Galaxy Note II'.freeze
        LaptopWithTouch = 'Laptop with touch'.freeze
        LaptopWithHDPIScreen = 'Laptop with HiDPI screen'.freeze
        LaptopWithMDPIScreen = 'Laptop with MDPI screen'.freeze
      end

      class << self
        def i_phone_4(orientation)
          new DEVICES::IPhone4, orientation
        end

        def i_phone_5_se(orientation)
          new DEVICES::IPhone5SE, orientation
        end

        def i_phone_6_7_8(orientation)
          new DEVICES::IPhone678, orientation
        end

        def i_phone_6_7_8_plus(orientation)
          new DEVICES::IPhone678Plus, orientation
        end

        def i_phone_x(orientation)
          new DEVICES::IPhoneX, orientation
        end

        def i_pad(orientation)
          new DEVICES::IPad, orientation
        end

        def i_pad_pro(orientation)
          new DEVICES::IPadPro, orientation
        end

        def black_berry_z30(orientation)
          new DEVICES::BlackBerryZ30, orientation
        end

        def nexus_4(orientation)
          new DEVICES::Nexus4, orientation
        end

        def nexus_5(orientation)
          new DEVICES::Nexus5, orientation
        end

        def nexus_5x(orientation)
          new DEVICES::Nexus5X, orientation
        end

        def nexus_6(orientation)
          new DEVICES::Nexus6, orientation
        end

        def nexus_6p(orientation)
          new DEVICES::Nexus6P, orientation
        end

        def pixel_2(orientation)
          new DEVICES::Pixel2, orientation
        end

        def pixel_2xl(orientation)
          new DEVICES::Pixel2XL, orientation
        end

        def lg_optimus_l70(orientation)
          new DEVICES::LGOptimusL70, orientation
        end

        def nokia_n9(orientation)
          new DEVICES::NokiaN9, orientation
        end

        def nokia_lumia_520(orientation)
          new DEVICES::NokiaLumia520, orientation
        end

        def microsoft_lumia_550(orientation)
          new DEVICES::MicrosoftLumia550, orientation
        end

        def microsoft_lumia_950(orientation)
          new DEVICES::MicrosoftLumia950, orientation
        end

        def galaxy_s3(orientation)
          new DEVICES::GalaxyS3, orientation
        end

        def galaxy_s5(orientation)
          new DEVICES::GalaxyS5, orientation
        end

        def kndle_fire_hdx(orientation)
          new DEVICES::KindleFireHDX, orientation
        end

        def i_pad_mini(orientation)
          new DEVICES::IPadMini, orientation
        end

        def blackberry_play_book(orientation)
          new DEVICES::BlackberryPlayBook, orientation
        end

        def nexus_10(orientation)
          new DEVICES::Nexus10, orientation
        end

        def nexus_7(orientation)
          new DEVICES::Nexus7, orientation
        end

        def galaxy_note_3(orientation)
          new DEVICES::GalaxyNote3, orientation
        end

        def galaxy_note_2(orientation)
          new DEVICES::GalaxyNote2, orientation
        end

        def laptop_with_touch(orientation)
          new DEVICES::LaptopWithTouch, orientation
        end

        def laptop_with_hdpi_screen(orientation)
          new DEVICES::LaptopWithHDPIScreen, orientation
        end

        def laptop_with_mdpi_screen(orientation)
          new DEVICES::LaptopWithMDPIScreen, orientation
        end
      end

      attr_accessor :device_name

      def initialize(device_name, screen_orientation)
        super(screen_orientation)
        self.device_name = device_name
      end

      def json_data
        {
          deviceName: device_name,
          screenOrientation: screen_orientation
        }
      end
    end
  end
end