require 'fileutils'

require_relative 'ttf/ttf'
require_relative 'ttf/ttc'

# Reads, writes, and processes any data not related to the font format
# itself; namely, the font file and image data
module Emoji
  class << self
    def read
      f = File.open('Apple Color Emoji.ttc', 'rb')
      @contents = f.read
    end

    def run
      read()

      # Process TTC container
      ttc = TTF::TTC.new(@contents)
      # puts ttc.fonts[0].tables.keys

      font = ttc.fonts[0]
      numGlyphs = font.tables['maxp'].numGlyphs
      mapping = font.tables['cmap'].map(numGlyphs)

      FileUtils.mkdir_p('img/160')
      font.tables['sbix'].strikes[8].glyphs.each.with_index do |glyph, index|
        next if glyph == nil

        char = mapping[index]
        next if char == 0

        hex = char.to_s(16)
        File.open("img/160/#{hex}.png", 'wb') do |f|
          f.write(glyph.data)
        end
      end
    end
  end
end

Emoji.run()
