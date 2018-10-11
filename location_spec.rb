require 'spec_helper'

require 'model/location'

describe Location do
  describe 'a new instance' do
    context 'given no arguments' do
      it 'has an empty latitude' do
        expect(subject.latitude).to be_nil
      end
      it 'has an empty longitude array' do
        expect(subject.longitude).to be_nil
      end
    end
    context 'given :latitude' do
      subject{ described_class.new(latitude: 12345) }

      it 'has the given latitude' do
        expect(subject.latitude).to eq(12345)
      end
    end

    context 'given :longitude' do
      subject{ described_class.new(longitude: 12345) }

      it 'has the given longitude' do
        expect(subject.longitude).to eq(12345)
      end
    end

  end
end
