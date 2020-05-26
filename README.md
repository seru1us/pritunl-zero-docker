# pritunl-zero-docker... uh.... but instead for bastion hosts. Yeah this needs to get organized

[Pritunl-Zero](https://zero.pritunl.com) is a zero trust system
that provides secure authenticated access to internal services from untrusted
networks without the use of a VPN. Documentation and more
information can be found at
[docs.pritunl.com](https://docs.pritunl.com/docs/pritunl-zero)

# Usage

To use this container the `MONGO_URI` and `NODE_ID` must be set. The node ID
is used to identify the node in the cluster, it must be unique to each
running container.

```bash
docker run --rm \
	--name pritunl-bastion-host \
	-p 22:22 \
	-e HOST_TOKEN="YNkx7jit84CW" \
	-e BASTION_HOSTNAME="somethingotherthanbastioniguess" \
	-e PZ_HOST="your_lame_fqdn.geocities.io" \
	-e TP_URL="https://zero-mgmt.goatfield.us/ssh_public_key/whatever" \
	docker.io/seru1us/pritunl-zero
```
