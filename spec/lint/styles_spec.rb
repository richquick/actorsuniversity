require 'spec_helper'

describe Stylesheets do
  let(:command) { 'ack url app/assets/stylesheets/ | grep -v asset_ | grep -v variables' }
  let(:exceptional_case) { "app/assets/stylesheets/_framework/skin/components/mobile/type.css.scss:3:@import url($sk_default_font_import);\n" }

  specify "only use asset_url in sass" do
    `#{command}`.should == exceptional_case
  end
end
