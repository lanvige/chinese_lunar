# encoding: utf-8

require 'spec_helper'

require "chinese_lunar/lunar"

module ChineseLunar
  describe Lunar do

    it "should convert to chinese lunar success" do
      luanr = Lunar.new(Date.new(2012, 3, 26))
      luanr.lunar_date_in_chinese.should eq "壬辰年 三月 初五"
    end

    it "should convert 2012 year to 壬辰 success" do
      luanr = Lunar.new(Date.new(2012, 3, 26))
      luanr.lunar_date_year_in_chinese.should eq "壬辰"
    end

    it "should convert 1983 success" do
      luanr = Lunar.new(Date.new(1983, 7, 23))
      luanr.lunar_date.should eq "1983-6-14"
    end

    it "should convert 1985 success" do
      luanr = Lunar.new(Date.new(1985, 2, 2))
      luanr.lunar_date.should eq "1984-12-13"
    end

    it "should convert 1993 success" do
      luanr = Lunar.new(Date.new(1993, 8, 11))
      luanr.lunar_date.should eq "1993-6-24"
    end

    it "should convert 2012 success" do
      luanr = Lunar.new(Date.new(2012, 3, 26))
      luanr.lunar_date.should eq "2012-3-5"
    end
  end
end