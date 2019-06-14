require 'rspec'
require 'set'
require_relative '../run_length_encoded_parser'

describe 'run-length-encoded parser' do

  let(:parser) { RunLengthEncodedParser.new }

  it 'can parse a very simple blinker' do

    pattern = "x = 3, y = 1, rule = B3/S23\n 3o!"

    expect(parser.parse(pattern)).to eq [coord(-1, 0), coord(0, 0), coord(1, 0)]
  end

  it 'can parse a glider' do

    pattern = "x = 3, y = 3\n bo$2bo$3o!"

    expect(parser.parse(pattern).to_set).to eq [
      coord(-1, -1),
      coord(0, -1),
      coord(0, 1),
      coord(1, -1),
      coord(1, 0)
    ].to_set
  end
end