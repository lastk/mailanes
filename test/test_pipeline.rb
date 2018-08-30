# Copyright (c) 2018 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'rack/test'
require 'yaml'
require_relative 'test__helper'
require_relative '../objects/lists'
require_relative '../objects/lanes'
require_relative '../objects/campaigns'
require_relative '../objects/pipeline'

class PipelineTest < Minitest::Test
  def test_picks_letters_for_delivery
    owner = random_owner
    list = Lists.new(owner: owner).add
    list.recipients.add('test@mailanes.com')
    lane = Lanes.new(owner: owner).add
    campaign = Campaigns.new(owner: owner).add(list, lane)
    campaign.toggle
    letter = lane.letters.add
    letter.toggle
    post1 = FakePostman.new
    Pipeline.new.fetch(post1)
    assert(post1.deliveries.find { |d| d.letter.id == letter.id })
    post2 = FakePostman.new
    Pipeline.new.fetch(post2)
    assert(!post2.deliveries.find { |d| d.letter.id == letter.id })
  end

  class FakePostman
    attr_reader :deliveries

    def initialize
      @deliveries = []
    end

    def deliver(delivery)
      @deliveries << delivery
    end
  end
end
