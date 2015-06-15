require 'spec_helper'


describe 'autofs::executor' do
  let (:facts) { { :osfamily => 'Debian', :require => 'Package[aurora-executor]', :require => 'Class[aurora-repo]' } }

  describe 'default' do
    it { should contain_package('[aurora-doc,aurora-executor]').with_ensure('aurora::version') }
    it { should contain_file('/etc/default/thermos').with_ensure('present').with_content('puppet:///aurora/thermos.erb').with_params(':mode => 0644') }
  end

end

##########

$attributes = {
  :ensure => 'present',
  :owner => 'root',
  :mode => '0644' ,
  :require => 'Package[aurora-executor]',
  :source => 'puppet:///aurora/thermos.erb'
}

describe 'aurora::executor' do
  let(:title) {'$packages'}

  it { should contain_class('aurora::executor') }

  it { should run.with_params('$packages') }

  # check that name $packages is an array of exactly 2 items,
  # and is the items we expect
  expect('$packages').to have(2).items
  expect('$packages').to contain_exactly('aurora-doc',
  'aurora-executor')

  it do
    should contain_package('$packages').with(
    'ensure' => '$aurora::version',
    'require' => 'Class[aurora::repo]',
    ) }
  end

  it do
    should contain_file('/etc/default/thermos').with($attributes)
  end


  # check when thermos file is not present
  context 'thermos file absent'
  let(:title) {'$packages'}

  $bad_attributes = {
    :ensure => 'present',
    :owner => 'root',
    :mode => '000' ,
    :require => 'Package[aurora-executor]',
    :source => 'puppet:///aurora/thermos.erb'
  }

  it do
    should contain_file('/etc/default/thermos').with($bad_attributes)

    it do
      expect {
        should compile
      }.to raise_error()
    end
  end


  #context '$packages parameter missing values'
  #let(:params) ## with_content { {:compress => true} }