5. Delete the instance, Security Group, and key pair.

### Delete the instance, security group and key pair

The order matters: a security group can't be deleted while an instance
still uses it.

### 1. Terminate the instance
EC2 → Instances → select the instance → Instance state → Terminate(delete) instance

Wait until the state is Terminated. Its disk (EBS volume) is deleted with it.

### 2. Delete the security group
EC2 → Security Groups → `launch-wizard-1` → Actions → Delete security groups

### 3. Delete the key pair
EC2 → Key Pairs → `daws-92s` → Actions → Delete

This only removes the public key from AWS. The key files on my laptop stay.
I deleted them too, since this key was only for this assignment:
```
rm daws-92s daws-92s.pub
```