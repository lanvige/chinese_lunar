# encoding: utf-8
# Modify from http://my.oschina.net/tomsu/blog/700

module ChineseLunar
  class Lunar

    @@lunar_info = [0x04bd8, 0x04ae0, 0x0a570,
                    0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,
                    0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0,
                    0x0ada2, 0x095b0, 0x14977, 0x04970, 0x0a4b0, 0x0b4b5, 0x06a50,
                    0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970, 0x06566,
                    0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0,
                    0x1c8d7, 0x0c950, 0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4,
                    0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557, 0x06ca0, 0x0b550,
                    0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950,
                    0x06aa0, 0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260,
                    0x0f263, 0x0d950, 0x05b57, 0x056a0, 0x096d0, 0x04dd5, 0x04ad0,
                    0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
                    0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40,
                    0x0af46, 0x0ab60, 0x09570, 0x04af5, 0x04970, 0x064b0, 0x074a3,
                    0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0, 0x0c960,
                    0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0,
                    0x092d0, 0x0cab5, 0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9,
                    0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930, 0x07954, 0x06aa0,
                    0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65,
                    0x0d530, 0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0,
                    0x1d0b6, 0x0d250, 0x0d520, 0x0dd45, 0x0b5a0, 0x056d0, 0x055b2,
                    0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0]

    @@nstr = ["", "正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"]
    @@gan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    @@zhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    @@nnimals = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]

    attr_reader :Date

    def initialize(date = Date.today)
      @date = date
    end

    # Get Lundar date in Chinese text
    def lunar_date_in_chinese() 
      l = convert(@date.year, @date.month, @date.day)
      cyclical_year(l[0]) + "年 " + @@nstr[l[1]] + "月 " + get_day_in_chinese(l[2])
    end

    def lunar_date_year_in_chinese()
      l = convert(@date.year, @date.month, @date.day)
      cyclical_year(l[0])
    end

    # Get the Lundar date in 'xxxx-xx-xx' fromat
    def lunar_date() 
      l = convert(@date.year, @date.month, @date.day)
      l[0].to_s + "-" + l[1].to_s + "-" + (/^\d+/.match(l[2].to_s)).to_s
    end

  private

    def cyclical_year(y)
      num = y - 1900 + 36
      cyclicalm(num)
    end

    def cyclicalm(num)
      @@gan[num % 10] + @@zhi[num % 12]
    end

    # 传出y年m月d日对应的农历.
    # year0 .month1 .day2 .yearCyl3 .monCyl4 .dayCyl5 .isLeap6
    def convert(y, m, d)
      nongDate = []   
      i = 0
      temp = 0
      leap = 0
      baseDate = Date.new(0 + 1900, 1, 31)
         
      objDate = Date.new(y, m, d);
      offset = objDate - baseDate
      nongDate[5] = offset + 40;
      nongDate[4] = 14;

      i = 1900
      while (i < 2050 && offset > 0)
        temp = days_in_lunar_date(i)
        offset -= temp
        nongDate[4] += 12

        i += 1
      end

      if (offset < 0)
        offset += temp
        i -= 1
        nongDate[4] -= 12
      end

      nongDate[0] = i
      nongDate[3] = i - 1864
      leap = leap_month(i) #闰哪个月
      nongDate[6] = 0

      i = 1  
      while(i<13 && offset > 0)
        #闰月
        if (leap > 0 && i == (leap + 1) && nongDate[6] == 0)
          i -= 1
          nongDate[6] = 1
          temp = leap_days( nongDate[0])
        else  
          temp = monthDays( nongDate[0], i)
        end   

        #解除闰月   
        if (nongDate[6] == 1 && i == (leap + 1))
          nongDate[6] = 0  
        end   
          offset -= temp   
          if (nongDate[6] == 0)   
            nongDate[4] += 1  
        end   

        i += 1  
      end   
      
      if (offset == 0 && leap > 0 && i == leap + 1)
        if (nongDate[6] == 1)
          nongDate[6] = 0
        else  
          nongDate[6] = 1
          i -= 1  
          nongDate[4] -= 1  
        end
      end   
      
      if (offset < 0)
        offset += temp
        i -= 1
        nongDate[4] -= 1
      end
      
      nongDate[1] = i
      nongDate[2] = offset + 1
    
      nongDate
    end

    def get_day_in_chinese(day)
      a = ""  
        if (day == 10)
          return "初十"
        elsif (day == 20)
          return "二十"
        elsif (day == 30)
          return "三十"
      end
             
      two = ((day) / 10).to_i()

      if (two == 0)   
        a = "初"  
      elsif (two == 1)   
        a = "十"
      elsif (two == 2)   
        a = "廿"
      elsif (two == 3)   
        a = "三"
      else
        a = "ERROR"  
      end   
      
      one =  (day % 10)   
    
      case one   
        when 1 then a += "一"
        when 2 then a += "二"
        when 3 then a += "三"
        when 4 then a += "四"
        when 5 then a += "五"
        when 6 then a += "六"
        when 7 then a += "七"
        when 8 then a += "八"
        when 9 then a += "九"
      end
      
      return a 
    end

    # Return the days in lunar of y year.
    def days_in_lunar_date(y)
      sum = 348  
      i = 0x8000  
      while i > 0x8  
        if ((@@lunar_info[y - 1900] & i) != 0)   
          sum += 1  
        end   
        i >>= 1  
      end
    
      sum + leap_days(y)
    end   

    # Return the leap days in y year.
    def leap_days(y)
       if (leap_month(y) != 0)    
         if ((@@lunar_info[y - 1900] & 0x10000) != 0)   
           return 30  
         else  
           return 29  
         end   
       else  
         return 0  
       end
    end   

    #传回农历 y年闰哪个月 1-12 , 没闰传回 0  
    def leap_month(y)
      @@lunar_info[y - 1900] & 0xf
    end
    
    # Return the days of m month in y year.
    def  monthDays(y, m)
      if ((@@lunar_info[y - 1900] & (0x10000 >> m)) == 0)
        return 29
      else
        return 30
      end
    end

  end
end
