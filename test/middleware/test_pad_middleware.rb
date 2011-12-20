require File.expand_path(File.dirname(__FILE__)) + '/../helper'

class PadMiddlewareTest < Test::Unit::TestCase
  def test_shift_supports_hash_init
    receiver = flexmock
    m = Tracksperanto::Middleware::Pad.new(receiver, 
      :left_pad => 0.5, :right_pad => 0, :top_pad => -0.2)
    assert_in_delta 0.5, m.left_pad, 0.001 
    assert_in_delta 0.0, m.bottom_pad, 0.001 
  end
  
  def test_shift_bypasses_methods
    receiver = flexmock
    cropped_w, cropped_h = (720 * 0.75).ceil, (610 * 1.1).ceil
    puts [cropped_w, cropped_h]
    receiver.should_receive(:start_export).once.with(cropped_w, cropped_h)
    receiver.should_receive(:start_tracker_segment).once.with("Tracker")
    receiver.should_receive(:export_point).once.with(1, 123, 95, 0)
    receiver.should_receive(:end_tracker_segment).once
    receiver.should_receive(:end_export).once
    
    m = Tracksperanto::Middleware::Pad.new(receiver, :left_pad => -0.25, :bottom_pad => 0.10)
    m.start_export(720, 576)
    m.start_tracker_segment("Tracker")
    m.export_point(1, 60, 30, 0)
    m.end_tracker_segment
    m.end_export
  end
  
end