RSpec.describe 'BeEF Extensions' do

  it 'loaded successfully' do
    expect {
      BeEF::Extensions.load
    }.to_not raise_error

    exts = BeEF::Core::Configuration.instance.get('beef.extension').select{|k,v|
      v['enable']
    }
    expect(exts.length).to be > 0

    exts.each do |k,v|
      expect(v).to have_key('name')
      expect(v).to have_key('enable')
      expect(v).to have_key('loaded')
      expect(v['loaded']).to be(true)
    end

  end

end
