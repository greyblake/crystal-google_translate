module GoogleTranslator
  # Adapted ruby code, taken from here: https://github.com/Stichoza/google-translate-php/issues/32#issuecomment-174027042
  # Thanks @galeto!
  class TokenBuilder
    def build(text)
      tl(text)
    end

    def shr32(x, bits)
      return x if bits.to_i <= 0
      return 0 if bits.to_i >= 32

      bin = x.to_u32.to_s(2) # to binary
      l = bin.size
      if l > 32
        bin = bin[(l - 32), 32]
      elsif l < 32
        bin = bin.rjust(32, '0')
      end

      bin = bin[0, (32 - bits)]
      (bin.rjust(32, '0')).to_i(2)
    end

    def char_code_at(str, index)
      str[index].ord
    end

    def rl(a, b)
      c = 0
      while c < (b.size - 2)
        d = b[c+2]
        d = (d >= 'a') ? d.ord - 87 : d.to_i
        d = (b[c+1] ==  '+') ? shr32(a.to_u32, d.to_u32) : a << d
        a = (b[c] == '+') ? (a + d & 4294967295) : a ^ d
        c += 3
      end
      a
    end

    def tl(a)
      b = 402890
      d = [] of Int32
      e = 0
      f = 0

      while f < a.size
        g = char_code_at(a, f)
        if 128 > g
          d << g
        else
          if 1048 > g
            d[e] = g >> 6 | 192
          else
            if (55296 == (g & 64512) && f + 1 < a.size && 56320 == (char_code_at(a, (f+1)) & 64512))
              g = 65536 + ((g & 1023) << 10) + (char_code_at(a, f += 1) & 1023)
              d[e] = g >> 18 | 240
              d[e] = g >> 12 & 63 | 128
            else
              d[e] = g >> 12 | 224
              d[e] = g >> 6 & 63 | 128
            end
          end
          d[e] = g & 63 | 128
        end
        e +=1
        f += 1
      end

      a = b
      e = 0

      while e < d.size
        a += d[e]
        a = rl(a.to_u32, "+-a^+6")
        e += 1
      end

      a = rl(a, "+-3^+b+-f")
      a = (a & 2147483647) + 2147483648 if 0 > a
      a %= (10 ** 6).to_i
      return ("#{ a }.#{ a ^ b }")
    end
  end
end
