# kubeadm AWS Kubernetes Cluster Lab - Progress

## Phase 0 - Preparation
- [x] 0.1 Create local project folder
- [x] 0.2 Skip commands.md until final documentation
- [x] 0.3 Decide AWS instance plan

## Phase 1 - AWS Setup with Terraform
- [x] T1.1 Verify Terraform and AWS CLI
- [x] T1.2 Configure AWS CLI profile
- [x] T1.3 Generate local SSH key pair
- [x] T1.4.1 Create Terraform base files
- [x] T1.4.2 Create Terraform AWS resources files
- [x] T1.5 Run terraform init
- [x] T1.6 Run terraform plan
- [x] T1.7 Run terraform apply
- [x] T1.8 Test SSH access

## Phase 2 - Node Preparation
- [x] 2.1 Update all nodes
- [x] 2.2 Set hostnames
- [x] 2.3 Disable swap
- [x] 2.4 Configure kernel modules and sysctl
- [x] 2.5 Install containerd
- [x] 2.6 Install kubeadm, kubelet, kubectl

## Phase 3 - Control Plane
- [x] 3.1 Run kubeadm init
- [x] 3.2 Configure kubectl

## Phase 4 - CNI
- [x] 4.1 Install CNI plugin
- [x] 4.2 Verify system pods
- [x] 4.3 Verify master node Ready

## Phase 5 - Workers
- [x] 5.1 Join worker-1
- [x] 5.2 Join worker-2
- [x] 5.3 Verify all nodes Ready

## Phase 6 - Test App
- [x] 6.1 Create nginx deployment
- [x] 6.2 Scale replicas
- [x] 6.3 Check pods distribution
- [x] 6.4 Expose service
- [x] 6.5 Test access

## Phase 7 - Documentation
- [ ] 7.1 Write README
- [ ] 7.2 Add architecture diagram
- [ ] 7.3 Add final commands documentation
- [ ] 7.4 Add troubleshooting notes
- [ ] 7.5 Add screenshots

## Phase 8 - Cleanup
- [ ] 8.1 Delete Kubernetes test resources
- [ ] 8.2 Run terraform destroy
- [ ] 8.3 Check for leftover AWS resources

## Phase 9 - GitHub
- [ ] 9.1 Create GitHub repo
- [ ] 9.2 Push project
