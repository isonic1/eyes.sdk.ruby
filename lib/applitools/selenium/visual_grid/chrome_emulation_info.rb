require 'applitools/selenium/visual_grid/emulation_base_info'
module Applitools
  module Selenium
    class ChromeEmulationInfo < EmulationBaseInfo
      class << self
        def i_phone_4(orientation)
          new Devices::IPhone4, orientation
        end

        def i_phone_5_se(orientation)
          new Devices::IPhone5SE, orientation
        end

        def i_phone_6_7_8(orientation)
          new Devices::IPhone678, orientation
        end

        def i_phone_6_7_8_plus(orientation)
          new Devices::IPhone678Plus, orientation
        end

        def i_phone_x(orientation)
          new Devices::IPhoneX, orientation
        end

        def i_pad(orientation)
          new Devices::IPad, orientation
        end

        def i_pad_pro(orientation)
          new Devices::IPadPro, orientation
        end

        def black_berry_z30(orientation)
          new Devices::BlackBerryZ30, orientation
        end

        def nexus_4(orientation)
          new Devices::Nexus4, orientation
        end

        def nexus_5(orientation)
          new Devices::Nexus5, orientation
        end

        def nexus_5x(orientation)
          new Devices::Nexus5X, orientation
        end

        def nexus_6(orientation)
          new Devices::Nexus6, orientation
        end

        def nexus_6p(orientation)
          new Devices::Nexus6P, orientation
        end

        def pixel_2(orientation)
          new Devices::Pixel2, orientation
        end

        def pixel_2xl(orientation)
          new Devices::Pixel2XL, orientation
        end

        def lg_optimus_l70(orientation)
          new Devices::LGOptimusL70, orientation
        end

        def nokia_n9(orientation)
          new Devices::NokiaN9, orientation
        end

        def nokia_lumia_520(orientation)
          new Devices::NokiaLumia520, orientation
        end

        def microsoft_lumia_550(orientation)
          new Devices::MicrosoftLumia550, orientation
        end

        def microsoft_lumia_950(orientation)
          new Devices::MicrosoftLumia950, orientation
        end

        def galaxy_s3(orientation)
          new Devices::GalaxyS3, orientation
        end

        def galaxy_s5(orientation)
          new Devices::GalaxyS5, orientation
        end

        def kndle_fire_hdx(orientation)
          new Devices::KindleFireHDX, orientation
        end

        def i_pad_mini(orientation)
          new Devices::IPadMini, orientation
        end

        def blackberry_play_book(orientation)
          new Devices::BlackberryPlayBook, orientation
        end

        def nexus_10(orientation)
          new Devices::Nexus10, orientation
        end

        def nexus_7(orientation)
          new Devices::Nexus7, orientation
        end

        def galaxy_note_3(orientation)
          new Devices::GalaxyNote3, orientation
        end

        def galaxy_note_2(orientation)
          new Devices::GalaxyNote2, orientation
        end

        def laptop_with_touch(orientation)
          new Devices::LaptopWithTouch, orientation
        end

        def laptop_with_hdpi_screen(orientation)
          new Devices::LaptopWithHDPIScreen, orientation
        end

        def laptop_with_mdpi_screen(orientation)
          new Devices::LaptopWithMDPIScreen, orientation
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