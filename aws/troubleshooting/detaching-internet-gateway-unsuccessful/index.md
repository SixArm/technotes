# Detaching internet gateway unsuccessful

Troubleshooting any of these error messages...

Detaching internet gateway unsuccessful. Network vpc-0f4c763c15495be68 has some mapped public address(es). Please unmap those public address(es) before detaching the gateway.

Delete network interface. The network interface can't be deleted. The selected network interface can't be deleted. Network interface is currently in use and is of type "interface".

Delete subnets. Some subnets cannot be deleted. 0 out of 1 subnets can be deleted. To delete the remaining 1 subnets, first make the following changes. You can refresh each section when you are done. Subnets have network interfaces and cannot be deleted. The following subnets contain one or more network interfaces, and cannot be deleted until those network interfaces have been deleted. 

Delete network ACLs. Cannot be deleted. The following default network ACLs cannot be deleted.

Delete security groups. Some security groups can't be deleted. The following security groups can't be deleted. They are either default security groups, referenced by other security groups, or they are associated with instances or network interfaces. 

## Solution

Delete any attached EC2 instance and RDS server.
