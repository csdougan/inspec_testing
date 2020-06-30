fstype="xfs"
volumegroup="datavg"
control 'rhel-ver' do
  title 'Check RHEL version'
  desc 'check the version of rhel'
    describe os[:family] do
        it { should eq 'redhat'}
    end
    describe os[:arch] do
      it { should eq 'x86_64' }
    end

    describe os[:release] do
      it { should start_with '7' }
    end
end

control 'check was mounts' do
  title 'Check WAS Filesystem mounts'
    describe etc_fstab.where { device_name == '/dev/mapper/' + volumegroup + '-ibmlv' } do
      its ('mount_point') { should cmp '/opt/IBM' }
      its ('file_system_type') { should cmp fstype }
      its ('mount_options') {should cmp [['defaults']]}
    end
    describe etc_fstab.where { device_name == '/dev/mapper/' + volumegroup + '-wassoftwarelv' } do
      its ('mount_point') { should cmp '/opt/IBM/Installation' }
      its ('file_system_type') { should cmp fstype }
      its ('mount_options') {should cmp [['defaults']]}
    end
    describe etc_fstab.where { device_name == '/dev/mapper/' + volumegroup + '-webspherelv' } do
      its ('mount_point') { should cmp '/opt/IBM/WebSphere' }
      its ('file_system_type') { should cmp fstype }
      its ('mount_options') {should cmp [['defaults']]}
    end
    describe etc_fstab.where { device_name == '/dev/mapper/' + volumegroup + '-wasprofilelv' } do
      its ('mount_point') { should cmp '/opt/IBM/WebSphere/profiles' }
      its ('file_system_type') { should cmp fstype }
      its ('mount_options') {should cmp [['defaults']]}
    end
    describe etc_fstab.where { device_name == '/dev/mapper/' + volumegroup + '-waslogslv' } do
      its ('mount_point') { should cmp '/opt/IBM/WebSphere/logs' }
      its ('file_system_type') { should cmp fstype }
      its ('mount_options') {should cmp [['defaults']]}
    end
end

control 'check active mounts' do
  title 'check actively mounted filesystems'
    describe mount('/opt/IBM') do
      it { should be_mounted }
      its('device') { should eq '/dev/mapper/datavg-ibmlv' }
      its('type') { should eq 'xfs' }
      its('options') { should include 'rw' }
    end
    describe mount('/opt/IBM/Installation') do
      it { should be_mounted }
      its('device') { should eq '/dev/mapper/datavg-wassoftwarelv' }
      its('type') { should eq 'xfs' }
      its('options') { should include 'rw' }
    end
    describe mount('/opt/IBM/WebSphere') do
      it { should be_mounted }
      its('device') { should eq '/dev/mapper/datavg-webspherelv' }
      its('type') { should eq 'xfs' }
      its('options') { should include 'rw' }
    end
    describe mount('/opt/IBM/WebSphere/profiles') do
      it { should be_mounted }
      its('device') { should eq '/dev/mapper/datavg-wasprofilelv' }
      its('type') { should eq 'xfs' }
      its('options') { should include 'rw' }
    end
    describe mount('/opt/IBM/WebSphere/logs') do
      it { should be_mounted }
      its('device') { should eq '/dev/mapper/datavg-waslogslv' }
      its('type') { should eq 'xfs' }
      its('options') { should include 'rw' }
    end
end
control 'check vg exists' do
  title 'check volume groups'
    describe directory('/dev/datavg') do
      it {should exist}
    end
end

control 'check lv exists' do
  title 'check logical volumes'
    describe file('/dev/mapper/datavg-ibmlv') do
      it {should exist}
    end
    describe file('/dev/mapper/datavg-wassoftwarelv') do
      it {should exist}
    end
    describe file('/dev/mapper/datavg-webspherelv') do
      it {should exist}
    end
    describe file('/dev/mapper/datavg-wasprofilelv') do
      it {should exist}
    end
    describe file('/dev/mapper/datavg-waslogslv') do
      it {should exist}
    end
end

control 'check users exist' do
  title 'check users'
    describe user('wasuser') do
      it {should exist}
    end
    describe user('db2inst1') do
      it {should exist}
    end
end
