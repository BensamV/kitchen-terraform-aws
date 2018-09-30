vpc_id_kt = attribute('vpc_id', description: 'VPC ID')
ami_id_kt = attribute('ami_id', description: 'AMI ID used by the EC2 instance')
subnet_id_kt = attribute('subnet_id', description: 'Subnet ID')
reachable_other_host_id_kt = attribute('reachable_other_host_id', description: 'ID of the EC2 instance')
test_target_ids_kt = attribute('test_target_ids', decription: 'ID of the test target EC2 instances')
security_group_id_kt = attribute('security_group_id_kt', description: 'Security group ID')
security_group_name_kt = attribute('security_group', description: 'Security group name')
sg_id = aws_security_group(group_name: security_group_name_kt, vpc_id: vpc_id_kt).group_id

control 'aws_resources' do
  describe aws_vpc(vpc_id_kt) do
    it { should exist }
    its('cidr_block') { should eq '192.168.0.0/20' }
  end

  describe aws_subnets.where( vpc_id: vpc_id_kt) do
    its('states') { should_not include 'pending' }
    its('cidr_blocks') { should include '192.167.5.0/24' }
    its('subnet_ids') { should include subnet_id_kt }
  end

  describe aws_security_group(group_name: security_group_name_kt, vpc_id: vpc_id_kt) do
    it { should exist }
    its('group_name') { should cmp security_group_name_kt}
    its('group_id') { should cmp security_group_id_kt}
    its('group_id') { should cmp sg_id}
    it { should allow_in(port: 22, ipv4_range: '198.144.101.2/32') }
    it { should allow_in(port: 22, ipv4_range: '73.61.21.227/32') }
    it { should_not allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
    #it { should allow_in(ipv4range: ['198.144.101.2/32', '73.61.21.227/32']) }
    it { should allow_in(port: 8080, ipv4_range: '198.144.101.2/32') }
    it { should allow_in(port: 8080, ipv4_range: '73.61.21.227/32') }
    it { should_not allow_in(port: 8080, ipv4_range: '0.0.0.0/0') }
    its('inbound_rules.count') { should cmp 2 }
  end

  describe sg_id do
    it {should eq security_group_id_kt}
  end

  test_target_ids_kt.each do |test_target_id|
      describe aws_ec2_instance(test_target_id) do
        it{ should exist }
        its('image_id') { should eq ami_id_kt }
        its('instance_type') { should eq 'm3.medium' }
        its('vpc_id') {should eq vpc_id_kt}
      end
  end

  describe aws_ec2_instance(reachable_other_host_id_kt) do
    it { should exist }
    its('image_id') { should eq ami_id_kt }
    its('instance_type') { should eq 'm3.medium' }
    its('vpc_id') {should eq vpc_id_kt}
    its('tags') { should include(key: 'Name', value: 'kitchen-terraform-reachable-other-host') }
  end
end
