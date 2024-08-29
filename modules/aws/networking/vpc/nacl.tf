module "nacl" {
  source = "../vpc-network-acls"

  vpc_id                         = aws_vpc.this.id
  public_subnet_ids              = aws_subnet.public.*.id
  private_subnet_ids             = aws_subnet.private_app.*.id
  private_persistence_subnet_ids = aws_subnet.private_persistence.*.id
}
