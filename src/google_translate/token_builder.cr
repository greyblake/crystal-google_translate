module GoogleTranslate
  # Adapted ruby code, taken from here: https://github.com/Stichoza/google-translate-php/issues/32#issuecomment-174027042
  # Thanks @galeto!
  class TokenBuilder
    def build(text)
      tk(text)
    end

    def char_code_at(str, index)
      str[index].ord
    end

    def tk(a)
      e = tkk.split(".")
      h = e[0].to_i64
      g = [] of Int32
      f = 0

      a.size.times do |f|
        c = char_code_at(a, f)
        if 128 > c
          g << c
        else
          if 2048 > c
            g << (c >> 6 | 192)
          else
            if 55296 == (c & 64512) && f + 1 < a.size && 56320 == (char_code_at(a, f+1) & 64512)
                c = 65536 + ((c & 1023) << 10) + (char_code_at(a,f+=1) & 1023)
                g << (c >> 18 | 240)
                g << (c >> 12 & 63 | 128)
            else
              g << (c >> 12 | 224)
              g << (c >> 6 & 63 | 128)
            end
          end
          g << (c & 63 | 128)
        end
      end

      a = h
      d = 0
      while d < g.size
        a+= g[d]
        a = b(a, "+-a^+6")
        d+=1
      end

      a = b(a, "+-3^+b+-f")
      a ^= (e[1]).to_i
      0 > a && (a = (a & 2147483647) + 2147483648);
      a %= 1E6.to_i
      return a.to_i.to_s + "." + (a.to_i ^ h).to_s;
    end

    def tkk : String
      a = 561666268;
      b = 1526272306;
      return 406398.to_s + '.' + (a + b).to_s;
    end

    def b(a, b)
      d = 0
      while d < (b.size - 2)
        c = b[d+2]
        c = 'a' <= c ? c.ord - 87 : c.to_i
        c = '+' == b[d+1] ? a >> c : a << c
        a = '+' == b[d] ? a + c & 4294967295 : a ^ c
        d += 3
      end
      a
    end
  end
end
